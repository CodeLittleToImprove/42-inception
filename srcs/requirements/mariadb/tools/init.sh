#!/bin/bash
set -e

DB_ROOT_PASS=$(cat /run/secrets/db_root_password)
DB_USER_PASS=$(cat /run/secrets/db_user_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "▶ Initializing empty MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
    echo "▶ MariaDB data directory already exists."
fi

echo "▶ Starting temporary MariaDB to verify users..."
mysqld --user=mysql --skip-networking &
PID=$!

# Wait for MariaDB to respond
for i in {30..0}; do
    if mysqladmin ping --silent; then
        break
    fi
    echo "▶ Waiting for MariaDB... ($i)"
    sleep 1
done

echo "▶ Applying SQL configuration..."
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
-- Create the user for remote connections (WordPress)
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
-- Ensure root can also connect remotely if needed (for debugging)
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASS}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "▶ Shutting down temporary MariaDB..."
mysqladmin -u root -p"${DB_ROOT_PASS}" shutdown
wait $PID

echo "▶ MariaDB is ready. Starting main process..."
exec mysqld --user=mysql