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