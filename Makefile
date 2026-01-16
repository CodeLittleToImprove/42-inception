NAME        := inception

# Paths to configuration
SRCS_DIR      := srcs
CONF_FILE     := $(SRCS_DIR)/docker-compose.yml
ENV_FILE      := $(SRCS_DIR)/.env

# Extract DATA_PATH from .env (e.g., /home/tbui-quo/data)
DATA_PATH := $(shell grep '^DATA_PATH=' $(ENV_FILE) | head -n 1 | cut -d '=' -f 2)

# Docker Compose Command
# -p sets the project name, --env-file ensures variables are loaded
COMPOSE       := docker compose -p $(NAME) -f $(CONF_FILE) --env-file $(ENV_FILE)

all: up

up:
	@echo "▶ Creating data directories in $(DATA_PATH)..."
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@chmod 777 $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
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
	$(COMPOSE) down -v --rmi all

fclean:
	@echo "▶ Stopping containers and clearing volumes..."
	@$(COMPOSE) down -v --rmi all
	@echo "▶ Checking if data exists in $(DATA_PATH)..."
	@if [ -d "$(DATA_PATH)" ]; then \
		echo "▶ Removing data folders with sudo..."; \
		sudo rm -rf $(DATA_PATH); \
		echo "▶ Data folders deleted."; \
	else \
		echo "▶ Data path not found or already clean."; \
	fi

re: fclean all

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f


