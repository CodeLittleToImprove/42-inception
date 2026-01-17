# Inception – Developer Documentation

## Overview

This document describes how developers can set up, build, run, and manage the Inception project.  
It focuses on the technical setup, Docker infrastructure, data persistence, and container management.

The project deploys a WordPress website using Docker Compose with three services:
- **Nginx**
- **WordPress (PHP-FPM)**
- **MariaDB**

All services run in isolated Docker containers and communicate via a private Docker network.


## 1. Environment Setup from Scratch

### 1.1 Prerequisites

The following software must be installed on the host system:
- Docker
- Docker Compose (v2)
- Make
- Git
- Text editor of your chose

The project is designed to run on a Linux system. And I tested on virtual machine with virtualbox running `Ubuntu 24.04.3 LTS`.


### 1.3 .env Setup

The project uses a .env file to configure service parameters.

Env directory: `srcs/.env`

Example file: `root/env.example`

The .env file must define the following variables:
- MYSQL_ROOT_USER 
- MYSQL_DATABASE 
- MYSQL_USER
- WORDPRESS_DB_HOST 
- WORDPRESS_DB_NAME 
- WORDPRESS_DB_USER 
- WP_URL 
- WP_TITLE 
- WP_ADMIN_USER
- WP_ADMIN_EMAIL
- WP_USER WP_EMAIL


### 1.4 secret Setup
Sensitive credentials are stored as Docker secrets.

Secrets directory: `root/secrets/`

Example directory: `root/secrets_example/`

Required secret files:
- db_root_password.txt
- db_user_password.txt
- wp_admin_password.txt
- wp_user_password.txt

#### Each textfile should only contain one password
#### Ensure that the `.env` and your `secrets text file` are **not tracked in Git (add to `.gitignore`)**

### 1.5 Hostname Configuration
To access the project locally, add the following entry to `/etc/hosts`:

`127.0.0.1 tbui-quo.42.fr`
This ensures the domain resolves locally instead of using an external DNS server.

## 2. Building and Launching the Project

### Using Makefile

The Makefiles contains follow commands for common tasks:

- **Build and start containers**
`make`

Creates required data directories, builds Docker images, and starts all containers in detached mode.

- **Stop running containers**
`make stop`

Stops all running containers without removing them.

- **Stop and remove containers**
`make down`

Stops and removes all containers defined in the Docker Compose file.

- **Remove containers and Docker images**
`make clean`

Stops containers, removes them, deletes associated volumes, and removes all Docker images built for the project.

- **Rebuild everything from scratch**
`make re`

Fully cleans the project (containers, images, volumes, and data) and rebuilds everything.

- **Stop and remove everything**
`make fclean`

Fully cleans the project (containers, images, volumes, and data) and also removes the project data directory defined by `DATA_PATH`.

- **Show container status**
`make ps`

Displays the status of all project containers.

- **Show container logs**
`make logs`

Show all logs from all running container services

- **Full project status overview**
`make status`

Displays:
- Container status
- Project Docker network
- Project Docker volumes

### Using Docker Compose Directly

- **Build images and start all services**

`docker compose up --build -d`

- **Stop and remove all services**

`docker compose down`

- **Rebuild a specific service**
`docker compose build <service_name>`

- **Full clearing everything**
`docker compose -p inception down -v`

## 3. Managing Containers and Volumes
The following commands can be used to inspect and control individual containers.

### Container managment
**List all running containers:**
`docker ps`

**Stop a specific container:**
`docker stop <container_name>`

**Remove a stopped container:**
`docker rm <container_name>`

**Access a running container shell:**
`docker exec -it <container_name> sh`

### Volumes management

**List all volumes:**
`docker volume ls`

**Inspect a specific volume**
`docker volume inspect <volume_name>`

**Remove unused volumes:**
`docker volume prune`

### Accessing the MariaDB Database

To inspect the database from the MariaDB container and check if the inception_db is empty :

**Open a shell in the MariaDB container and log in as root:**

`docker exec -it inception-mariadb-1 mariadb -u root -p`

**List all databases:**
`SHOW DATABASES;`

**Select the Inception database**
`USE inception_db;`

**List all tables in the database:**
`SHOW TABLES;`

## 4. Project Data Storage and Persistence
Docker volumes ensure data persistence across container restarts, specifically for:

- MariaDB database data

- WordPress files and uploads

It has required from the subject we also mount them on the host machine under path `/home/$USER/data`
These are only get cleaned with the `make fclean` command.