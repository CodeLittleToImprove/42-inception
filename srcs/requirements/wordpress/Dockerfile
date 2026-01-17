FROM debian:12.2-slim

RUN apt-get update && \
    apt-get install -y php-fpm php-mysql wget unzip netcat-openbsd curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy wait-for.sh for Makefile use
COPY ./tools/wait-for.sh /usr/local/bin/wait-for.sh
RUN chmod +x /usr/local/bin/wait-for.sh

# Copy entrypoint script
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set permissions for www-data
RUN chown -R www-data:www-data /var/www/html

# Expose 9000 for PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

