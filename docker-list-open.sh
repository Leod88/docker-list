#!/bin/bash

# Récupère l'adresse IP locale de la machine
local_ip=$(hostname -I | awk '{print $1}')

# Récupère les informations des conteneurs en cours d'exécution avec la commande "docker ps"
container_info=$(docker ps --format "{{.Names}}|{{.Ports}}")

# Initialise la variable qui va contenir tous les URLs
urls=""

# Parcourt chaque ligne de l'output et extrait le port pour chaque conteneur
while read -r line; do
  container_name=$(echo "$line" | cut -d "|" -f 1)
  container_port=$(echo "$line" | cut -d ":" -f 2 | cut -d "-" -f 1)

  # Ajoute l'URL au format "open http://<IP>:<port>" à la variable "urls" si le port est différent de 0
  if [ "$container_port" -ne 0 ]; then
    urls+=" http://$local_ip:$container_port "
    echo "$container_name | http://$local_ip:$container_port"
  fi  
done <<< "$container_info"

# Affiche tous les URLs concaténés
echo "open $urls"
