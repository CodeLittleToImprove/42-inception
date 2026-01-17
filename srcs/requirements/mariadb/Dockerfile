FROM debian:12.2-slim

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# create socket directory
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

COPY my.cnf /etc/mysql/my.cnf
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

CMD ["sh", "-c", "mysqld_safe & sleep 5; /init.sh; wait"]



