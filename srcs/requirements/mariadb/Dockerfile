FROM debian:12.2-slim

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# REQUIRED: socket directory
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld


# Copy custom configuration if you have one / get ready when automatically when 
COPY my.cnf /etc/mysql/my.cnf

# Copies the database initialization script into a special MariaDB directory.
# Any .sh or .sql scripts in this folder are automatically executed by the 
# MariaDB entrypoint the very first time the container starts (when the volume is empty).
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

# IMPORTANT: run init manually, then start MariaDB

CMD ["sh", "-c", "mysqld_safe & sleep 5; /init.sh; wait"]



