***This project has been created as part of the 42 curriculum by tbui-quo***

# Description
### Overview
The idea of this project is to get familiar with how to use a Docker and how it works in the background.  You have to create 3 seperated services: nginx, mariadb, wordpress. Each of them must run in each own container but they must be able to communicate with each other.

### Goals
- Learn about docker and networking
- Learn about security and password management through of .env and secrets

# Instructions
### Prerequisites
You need following applications installed to run this project.
```
Docker
Docker Compose
Make
GIT
```

### How to run this project
- You need to provide an .env in the cloned folder root/srcs. This env file is needed to prevent you to hardcode credentials into your files which you upload to you repository and which would be visible to everyone. There is an template in root of this repository called env.example. to get an idea how it should look like.

- You need to provide a folder called secrets in the cloned folder root with 4 textfiles which contains password to your database and wordpress: 
    - db_root_password
    - db_user_password
    - wp_admin_password
    - wp_user_password
- Finally you can call the `make` command in the root directory to use docker compose to create the 3 required services.

- To delete evertything which was created via `make` you use `make fclean`

# Project description

### Design choices
We are required to use the combination between nginx, Mariadb and Wordpress. That`s why we do not have any big design choices in this project. But those service are open source and lightweight and kinda easy to use because there are widely used.

For the Docker Images we had the option between Debian and Alpine, because I have never heard of Alpine I choose Debian and it is also widely used.

### Comparison of Concepts
The subject wants that we can explain following concepts

### Virtual Machines vs Docker
A Virtual machine compared to Docker is a "full package" and Docker only contains a bare mininum of processes which are needed to run your service. You can customize what should be installed in a dockerfile. A Virtual Machine starts a whole operating system, which contains subprocessed, preinstalled software, a GUI so can you access it like normal operating system.

### Secrets vs Environment Variables
Secrets and environment variables serve a similar purpose but the big difference you can access environment variables via the cmd 'docker inspect <servicename> inside of a container. Secrets on other hand are only read by scripts at runtime and are not exposed anywhere in a docker container. Secrets should be used for sensitive credentials, while environment variables should be used for non-sensitive configuration values that need to be accessible inside a container.

### Docker Network vs Host Network
Docker network provides an isolated virtual network for your docker containers, allowing them to communicate securely with each other without exposing services directly to the host network
Host Network shares the whole network stack with the container, meaning the container uses the host’s IP address and has direct access to the host network, including the internet.

### Docker Volumes vs Bind Mounts
Docker volumes are directly managed by docker which is stored in /var/lib/docker/volumes/`. This means they provide a persistent portable storage. On other hand bind mounts directly connects a host directory to the container which is nor portable and it always requires a hardcorded path a path on the host machine, which has to be created manualy before running a dockerfile.

## Ressources
Resource which helped me to get a better understand of thhis project and docker in general and other helpful toolks
#### Docker commands:
- https://docs.docker.com/reference/dockerfile/


#### PID 1 understanding
- https://www.marcusfolkesson.se/blog/pid1-in-containers/


#### Markdown visualizer tool
- https://markdownlivepreview.com/


#### How to combine Nginx, MariaDB and Wordpress
- https://www.ionos.com/digitalguide/hosting/blogs/wordpress-nginx/