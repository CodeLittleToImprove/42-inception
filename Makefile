NAME        := inception
LOGIN       := kunel
DATA_DIR    := /home/$(LOGIN)/data

COMPOSE     := docker compose -p $(NAME) -f srcs/docker-compose.yml
VOLUMES     := $(NAME)_mariadb_data $(NAME)_wp_data

# Load env from a specific path
ENV_FILE := ./srcs/.env
export $(shell sed 's/=.*//' $(ENV_FILE))


all: up

up:
	@mkdir -p $(DATA_DIR)
	@$(COMPOSE) up --build -d

down:
	@echo "▶ Stopping containers"
	@$(COMPOSE) down

stop:
	@echo "▶ Stopping containers"
	@$(COMPOSE) stop

clean: down
	@echo "▶ Removing containers and images"
	@$(COMPOSE) down --rmi all

fclean: clean
	@echo "▶ Removing volumes"
	@for v in $(VOLUMES); do docker volume rm $$v || true; done

re: fclean all

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f


