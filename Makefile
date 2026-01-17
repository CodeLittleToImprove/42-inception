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

up: check_path setup_dirs
	@echo "▶ Starting containers..."
	@$(COMPOSE) up --build -d

stop:
	@echo "▶ Stopping containers"
	@$(COMPOSE) stop

clean:
	@echo "▶ Stopping containers and removing networks..."
	@$(COMPOSE) down

fclean: clean
	@echo "▶ Removing volumes and images..."
	@$(COMPOSE) down -v --rmi all
	@$(MAKE) clean_dirs
	@echo "▶ System fully cleaned."

re: fclean up

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f

status:
	@echo "---------------- CONTAINER STATUS ----------------"
	@$(COMPOSE) ps
	@echo "\n----------------- NETWORK STATUS -----------------"
	@docker network ls --filter name=$(NAME)
	@echo "\n------------------ VOLUME STATUS -----------------"
	@docker volume ls --filter name=$(NAME)

check_path:
	@if [ -z "$(DATA_PATH)" ]; then \
		echo "✘ Error: DATA_PATH not found in $(ENV_FILE)"; \
		exit 1; \
	fi

clean_dirs: check_path
	@echo "▶ Removing data folders in $(DATA_PATH)..."
	@sudo rm -rf $(DATA_PATH)/mariadb
	@sudo rm -rf $(DATA_PATH)/wordpress
	@if [ -d "$(DATA_PATH)" ]; then \
		sudo rmdir $(DATA_PATH) 2>/dev/null || true; \
	fi
	@echo "✔ Host directories cleared."

setup_dirs:
	@echo "▶ Preparing directories in $(DATA_PATH)..."
	@sudo mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	@sudo chmod -R 777 $(DATA_PATH)