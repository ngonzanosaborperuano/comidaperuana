#!/bin/bash

# Script rápido para debug de CocinandoIA
# Uso: ./quick_debug.sh [dev|staging|prod]

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar argumento
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Uso: $0 [dev|staging|prod]${NC}"
    echo ""
    echo "Ejemplos:"
    echo "  $0 dev      - Ejecutar en desarrollo"
    echo "  $0 staging  - Ejecutar en staging"
    echo "  $0 prod     - Ejecutar en producción"
    exit 1
fi

ENV=$1

# Validar entorno
case $ENV in
    dev|staging|prod)
        ;;
    *)
        echo -e "${YELLOW}❌ Entorno inválido: $ENV${NC}"
        echo "Entornos válidos: dev, staging, prod"
        exit 1
        ;;
esac

# Obtener archivo main
case $ENV in
    dev)
        MAIN_FILE="lib/main_dev.dart"
        APP_NAME="Goncook Dev"
        ;;
    staging)
        MAIN_FILE="lib/main_staging.dart"
        APP_NAME="Goncook Staging"
        ;;
    prod)
        MAIN_FILE="lib/main_prod.dart"
        APP_NAME="Goncook"
        ;;
esac

echo -e "${GREEN}🚀 Ejecutando $APP_NAME...${NC}"
echo -e "${BLUE}Entorno: $ENV${NC}"
echo -e "${BLUE}Archivo: $MAIN_FILE${NC}"
echo ""

# Ejecutar aplicación
fvm flutter run --flavor $ENV --target $MAIN_FILE
