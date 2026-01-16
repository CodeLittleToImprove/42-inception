#!/bin/sh

set -e

# Default port fallback if WP_PORT not defined
: "${WP_PORT:=9000}"

# Replace PHP-FPM listen line dynamically
sed -i "s|^listen = .*|listen = 0.0.0.0:${WP_PORT}|" /etc/php/8.2/fpm/pool.d/www.conf

echo $WP_PORT
# Go to WordPress directory
cd /var/www/html

# Increase PHP memory
sed -i 's/memory_limit = .*/memory_limit = 256M/' /etc/php/8.2/fpm/php.ini

# Safety fallback: if HOST is empty, use 'mariadb'
WORDPRESS_DB_HOST=${WORDPRESS_DB_HOST:-mariadb}

# Wait for the database to be ready
until nc -z "$WORDPRESS_DB_HOST" "$MYSQL_TCP_PORT"; do
    sleep 2
done

# Configure WordPress if not already
if [ ! -f wp-config.php ]; then
    echo "WordPress not configured. Setting up..."

    # Download WordPress
    wp core download --locale=en_US --allow-root

    # Create wp-config.php
  wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$(cat /run/secrets/db_user_password)" \
        --dbhost="$WORDPRESS_DB_HOST:$MYSQL_TCP_PORT" \
        --allow-root

    # Install WordPress
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$(cat /run/secrets/wp_admin_password)" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    # Optional: create extra user
    wp user create "$WP_USER" "$WP_EMAIL" \
        --user_pass="$(cat /run/secrets/wp_user_password)" \
        --role=author \
        --allow-root

    chmod -R 777 /var/www/html
else
    echo "WordPress already configured. Continuing..."
fi

# Start PHP-FPM in foreground
exec /usr/sbin/php-fpm8.2 -F -R

