# penultimate stable
FROM debian:12.2-slim

# Update package index and install required software
# - nginx: web server
# - openssl: for generating self-signed TLS certificates
# Then remove package cache to keep the image small
RUN apt-get update && \
    apt-get install -y nginx openssl netcat-openbsd curl && \
    rm -rf /var/lib/apt/lists/*



# Create a directory to store SSL certificates for NGINX
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed TLS certificate and private key
# -x509: generate a self-signed certificate
# -nodes: no passphrase for the private key (required for automated startup)
# -days 365: certificate valid for 1 year
# -subj: subject line for the certificate; change CN to your domain
# -newkey rsa:2048: create a new 2048-bit RSA key
RUN openssl req -x509 -nodes -days 365 \
    -subj "/CN=kunel.42.fr" \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

# Copy NGINX site configuration into the container
# This config should enforce TLSv1.2/1.3 and proxy to WordPress PHP-FPM
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose port 443 (HTTPS) to the host
EXPOSE 443

# Copy wait-for script
COPY ./tools/wait-for.sh /wait-for.sh
RUN chmod +x /wait-for.sh

# Start NGINX as PID 1 so the container keeps running
# The "-g 'daemon off;'" ensures NGINX runs in the foreground (required in Docker)
# Run NGINX after WordPress is ready
CMD ["/wait-for.sh", "wordpress", "9000", "nginx", "-g", "daemon off;"]