# Si besoin à remplacer le nom de l'utilisateur docker final
DOCKER_USER=jeromeklam

# Nom du container
NAME:=u18

# Chemin courant = real_path
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Id, ... de docker
RUNNING:=$(shell docker ps | grep $(NAME) | cut -f 1 -d ' ')
ALL:=$(shell docker ps -a | grep $(NAME) | cut -f 1 -d ' ')

# Options de la ligne de commande
DOCKER_RUN_COMMON=--name="$(NAME)" $(DOCKER_USER)/$(NAME)

# Par défaut le build
all: build

# Compilation de l'image
build: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	docker build -t="$(DOCKER_USER)/$(NAME)" .

# Démarrage du container
run: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	docker run -d $(DOCKER_RUN_COMMON)

# Arrêt du container
stop: clean

# Démarrage d'un bash sur le container
bash: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	docker run -t -i $(DOCKER_RUN_COMMON) /bin/bash

# Supprime les containers existants
clean:
ifneq ($(strip $(RUNNING)),)
	docker stop $(RUNNING)
endif
ifneq ($(strip $(ALL)),)
	docker rm $(ALL)
endif

# Nettoyage complet !!!
deepclean: clean
	rm -rf $(ROOT_DIR)/docker-logs
