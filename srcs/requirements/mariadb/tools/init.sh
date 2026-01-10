#!/bin/sh
set -e

DB_ROOT_PASS=$(cat /run/secrets/db_root_password)
DB_USER_PASS=$(cat /run/secrets/db_user_password)

mysql -u root -p"$DB_ROOT_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- REMOVE any existing user definitions
DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';
DROP USER IF EXISTS '${MYSQL_USER}'@'%';

-- Recreate user with correct host
CREATE USER '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_USER_PASS}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF
