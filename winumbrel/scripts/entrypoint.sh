#!/bin/bash

CONFIG_FILE="/app/config/windows-config.json"

# Verifica se o arquivo de configuração existe
if [ -f "$CONFIG_FILE" ]; then
    echo "🔧 Carregando configurações do $CONFIG_FILE"
    WIN_VERSION=$(jq -r '.WIN_VERSION' "$CONFIG_FILE")
    RAM_SIZE=$(jq -r '.RAM_SIZE' "$CONFIG_FILE")
    CPU_CORES=$(jq -r '.CPU_CORES' "$CONFIG_FILE")
    DISK_SIZE=$(jq -r '.DISK_SIZE' "$CONFIG_FILE")

    echo "Versão: $WIN_VERSION"
    echo "RAM: $RAM_SIZE MB"
    echo "CPU Cores: $CPU_CORES"
    echo "Disco: $DISK_SIZE GB"

    # Exporta as variáveis para serem usadas no docker-compose
    export WIN_VERSION
    export RAM_SIZE
    export CPU_CORES
    export DISK_SIZE
else
    echo "⚠️ Arquivo de configuração não encontrado: $CONFIG_FILE"
    echo "Usando valores padrão..."
    export WIN_VERSION="10"
    export RAM_SIZE="2048"
    export CPU_CORES="2"
    export DISK_SIZE="20"
fi

# Executa o comando padrão (mantém o contêiner ativo)
exec "$@"
