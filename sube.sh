#!/bin/bash

clear

RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

# 👉 AGREGA AQUÍ TU TOKEN NUEVO
TOKEN="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"

echo -e "${CYAN}"
echo "  ██████╗ ██╗████████╗██╗  ██╗██████╗ ██████╗ "
echo " ██╔═══██╗██║╚══██╔══╝██║  ██║██╔══██╗██╔══██╗"
echo " ██║   ██║██║   ██║   ███████║██████╔╝██████╔╝"
echo " ██║▄▄ ██║██║   ██║   ██╔══██║██╔═══╝ ██╔═══╝ "
echo " ╚██████╔╝██║   ██║   ██║  ██║██║     ██║     "
echo "  ╚══▀▀═╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝     "
echo -e "${RESET}"

read -p "Ruta de la carpeta: " folder_path
read -p "URL completa del repositorio (https://github.com/usuario/repositorio.git): " repo_url

if [ ! -d "$folder_path" ]; then
  echo -e "${RED}Error: Carpeta no encontrada.${RESET}"
  exit 1
fi

cd "$folder_path" || exit

echo -e "${BLUE}Añadiendo directorio a la lista de directorios seguros...${RESET}"
git config --global --add safe.directory "$folder_path"

if [ ! -d ".git" ]; then
  echo -e "${BLUE}Inicializando repositorio...${RESET}"
  git init &>/dev/null
  echo -e "${GREEN}Repositorio inicializado.${RESET}"
fi

echo -e "${BLUE}Agregando archivos...${RESET}"
git add . &>/dev/null
echo -e "${GREEN}Archivos agregados.${RESET}"

read -p "Mensaje del commit: " commit_message
git commit -m "$commit_message" &>/dev/null
echo -e "${GREEN}Commit realizado: $commit_message${RESET}"

echo -e "${BLUE}Configurando rama main...${RESET}"
git branch -M main &>/dev/null
echo -e "${GREEN}Rama main configurada.${RESET}"

# 🟢 Reemplazar URL normal por URL con token
safe_url=$(echo "$repo_url" | sed "s|https://|https://$TOKEN@|")

git remote remove origin &>/dev/null
git remote add origin "$safe_url" &>/dev/null

echo -e "${BLUE}Subiendo archivos...${RESET}"
git push -u origin main &>/dev/null

if [ $? -ne 0 ]; then
  echo -e "${RED}Error al subir los archivos. Revise el token, la URL o permisos.${RESET}"
  exit 1
fi

echo -e "${CYAN}Archivos subidos exitosamente.${RESET}"
