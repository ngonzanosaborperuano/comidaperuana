#!/bin/bash

# Script para ejecutar Flutter Flavors fácilmente (Android + Dart)
# Uso: ./run_flavors.sh [dev|staging|prod]

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}Flutter Flavors Runner - Comida Peruana${NC}"
    echo ""
    echo "Uso: $0 [dev|staging|prod]"
    echo ""
    echo "Opciones:"
    echo "  dev      - Ejecutar en modo desarrollo"
    echo "  staging  - Ejecutar en modo staging"
    echo "  prod     - Ejecutar en modo producción"
    echo "  help     - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 dev"
    echo "  $0 staging"
    echo "  $0 prod"
    echo ""
}

# Función para ejecutar el flavor
run_flavor() {
    local flavor=$1
    local target_file=""
    local flavor_param=""
    
    case $flavor in
        "dev")
            target_file="lib/flavors/main.dart"
            flavor_param="dev"
            echo -e "${GREEN}🚀 Ejecutando en modo DESARROLLO${NC}"
            ;;
        "staging")
            target_file="lib/flavors/main.dart"
            flavor_param="staging"
            echo -e "${YELLOW}🚀 Ejecutando en modo STAGING${NC}"
            ;;
        "prod")
            target_file="lib/flavors/main.dart"
            flavor_param="prod"
            echo -e "${BLUE}🚀 Ejecutando en modo PRODUCCIÓN${NC}"
            ;;
        *)
            echo -e "${RED}❌ Flavor '$flavor' no válido${NC}"
            show_help
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}📱 Target: $target_file${NC}"
    echo -e "${GREEN}🏷️  Flavor: $flavor_param${NC}"
    echo ""
    
    # Verificar que el archivo existe
    if [ ! -f "$target_file" ]; then
        echo -e "${RED}❌ Error: El archivo $target_file no existe${NC}"
        exit 1
    fi
    
    # Ejecutar Flutter
    echo -e "${GREEN}▶️  Ejecutando: flutter run -t $target_file --flavor $flavor_param${NC}"
    echo ""
    
    flutter run -t "$target_file" --flavor "$flavor_param"
}

# Función para construir APK
build_apk() {
    local flavor=$1
    local target_file=""
    local flavor_param=""
    
    case $flavor in
        "dev")
            target_file="lib/flavors/main_dev.dart"
            flavor_param="dev"
            echo -e "${GREEN}📦 Construyendo APK para DESARROLLO${NC}"
            ;;
        "staging")
            target_file="lib/flavors/main_staging.dart"
            flavor_param="staging"
            echo -e "${YELLOW}📦 Construyendo APK para STAGING${NC}"
            ;;
        "prod")
            target_file="lib/flavors/main_prod.dart"
            flavor_param="prod"
            echo -e "${BLUE}📦 Construyendo APK para PRODUCCIÓN${NC}"
            ;;
        *)
            echo -e "${RED}❌ Flavor '$flavor' no válido${NC}"
            show_help
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}📱 Target: $target_file${NC}"
    echo -e "${GREEN}🏷️  Flavor: $flavor_param${NC}"
    echo ""
    
    # Verificar que el archivo existe
    if [ ! -f "$target_file" ]; then
        echo -e "${RED}❌ Error: El archivo $target_file no existe${NC}"
        exit 1
    fi
    
    # Construir APK
    echo -e "${GREEN}▶️  Construyendo: flutter build apk -t $target_file --flavor $flavor_param${NC}"
    echo ""
    
    flutter build apk -t "$target_file" --flavor "$flavor_param"
}

# Función para limpiar
clean_project() {
    echo -e "${YELLOW}🧹 Limpiando proyecto...${NC}"
    flutter clean
    echo -e "${GREEN}✅ Proyecto limpiado${NC}"
}

# Función para obtener dependencias
get_dependencies() {
    echo -e "${YELLOW}📥 Obteniendo dependencias...${NC}"
    flutter pub get
    echo -e "${GREEN}✅ Dependencias obtenidas${NC}"
}

# Función principal
main() {
    case $1 in
        "dev"|"staging"|"prod")
            run_flavor $1
            ;;
        "build-dev"|"build-staging"|"build-prod")
            local flavor=${1#build-}
            build_apk $flavor
            ;;
        "clean")
            clean_project
            ;;
        "deps"|"get")
            get_dependencies
            ;;
        "help"|"-h"|"--help"|"")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Opción '$1' no válida${NC}"
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
