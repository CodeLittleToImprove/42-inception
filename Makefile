NAME        := inception
LOGIN       := tbui-quo
DATA_PATH   := $(HOME)/data
MARIADB_DIR := $(DATA_PATH)/mariadb
WP_DIR      := $(DATA_PATH)/wordpress

# Paths to your source files
CONF_FILE   := srcs/docker-compose.yml
ENV_FILE    := srcs/.env

COMPOSE     := docker compose -p $(NAME) -f $(CONF_FILE) --env-file $(ENV_FILE)


all: up

up:
	@echo "▶ Creating data directories..."
	@mkdir -p $(MARIADB_DIR)
	@mkdir -p $(WP_DIR)
	@echo "▶ Starting containers..."
	@$(COMPOSE) up --build -d

down:
	@echo "▶ Stopping containers"
	@$(COMPOSE) down

stop:
	@echo "▶ Stopping containers"
	@$(COMPOSE) stop

clean: down
	@echo "▶ Removing images..."
	@docker system prune -a -f

fclean:
	@echo "▶ Total cleanup (Containers, Volumes, Images)..."
	@$(COMPOSE) down -v --rmi all
	@echo "▶ Deleting data folders safely..."
	@rm -rf $(MARIADB_DIR)
	@rm -rf $(WP_DIR)
	@rm -rf $(DATA_PATH)

re: fclean all

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f


