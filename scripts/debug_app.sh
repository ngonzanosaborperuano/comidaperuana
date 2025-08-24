#!/bin/bash

# Script para debug de la aplicación CocinandoIA por entornos
# Uso: ./debug_app.sh [dev|staging|prod] [run|build|clean|install]

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}=== Script de Debug para CocinandoIA ===${NC}"
    echo ""
    echo "Uso: $0 [ENTORNO] [ACCIÓN]"
    echo ""
    echo "ENTORNOS:"
    echo "  dev      - Entorno de desarrollo"
    echo "  staging  - Entorno de pruebas"
    echo "  prod     - Entorno de producción"
    echo ""
    echo "ACCIONES:"
    echo "  run      - Ejecutar la aplicación (flutter run)"
    echo "  build    - Generar APK (flutter build apk)"
    echo "  clean    - Limpiar build (flutter clean)"
    echo "  install  - Instalar dependencias (flutter pub get)"
    echo "  doctor   - Verificar configuración (flutter doctor)"
    echo "  all      - Ejecutar clean + install + run"
    echo ""
    echo "EJEMPLOS:"
    echo "  $0 dev run      - Ejecutar en modo desarrollo"
    echo "  $0 prod build   - Generar APK de producción"
    echo "  $0 staging all  - Limpiar, instalar y ejecutar staging"
    echo ""
}

# Función para validar entorno
validate_environment() {
    local env=$1
    case $env in
        dev|staging|prod)
            return 0
            ;;
        *)
            echo -e "${RED}❌ Entorno inválido: $env${NC}"
            echo "Entornos válidos: dev, staging, prod"
            return 1
            ;;
    esac
}

# Función para validar acción
validate_action() {
    local action=$1
    case $action in
        run|build|clean|install|doctor|all)
            return 0
            ;;
        *)
            echo -e "${RED}❌ Acción inválida: $action${NC}"
            echo "Acciones válidas: run, build, clean, install, doctor, all"
            return 1
            ;;
    esac
}

# Función para obtener archivo main según entorno
get_main_file() {
    local env=$1
    case $env in
        dev)
            echo "lib/main_dev.dart"
            ;;
        staging)
            echo "lib/main_staging.dart"
            ;;
        prod)
            echo "lib/main_prod.dart"
            ;;
    esac
}

# Función para obtener nombre de la app según entorno
get_app_name() {
    local env=$1
    case $env in
        dev)
            echo "CookingIA Dev"
            ;;
        staging)
            echo "CookingIA Staging"
            ;;
        prod)
            echo "CookingIA"
            ;;
    esac
}

# Función para ejecutar flutter run
run_app() {
    local env=$1
    local main_file=$(get_main_file $env)
    local app_name=$(get_app_name $env)
    
    echo -e "${BLUE}🚀 Ejecutando $app_name...${NC}"
    echo -e "${YELLOW}Archivo: $main_file${NC}"
    echo -e "${YELLOW}Flavor: $env${NC}"
    echo ""
    
    fvm flutter run --flavor $env --target $main_file
}

# Función para generar APK
build_app() {
    local env=$1
    local main_file=$(get_main_file $env)
    local app_name=$(get_app_name $env)
    
    echo -e "${BLUE}🔨 Generando APK para $app_name...${NC}"
    echo -e "${YELLOW}Archivo: $main_file${NC}"
    echo -e "${YELLOW}Flavor: $env${NC}"
    echo ""
    
    fvm flutter build apk --flavor $env --debug --target $main_file
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ APK generado exitosamente!${NC}"
        echo -e "${YELLOW}Ubicación: build/app/outputs/flutter-apk/app-${env}-debug.apk${NC}"
    else
        echo -e "${RED}❌ Error al generar APK${NC}"
    fi
}

# Función para limpiar build
clean_app() {
    echo -e "${BLUE}🧹 Limpiando build...${NC}"
    fvm flutter clean
    echo -e "${GREEN}✅ Build limpiado${NC}"
}

# Función para instalar dependencias
install_dependencies() {
    echo -e "${BLUE}📦 Instalando dependencias...${NC}"
    fvm flutter pub get
    echo -e "${GREEN}✅ Dependencias instaladas${NC}"
}

# Función para verificar configuración
check_doctor() {
    echo -e "${BLUE}🏥 Verificando configuración de Flutter...${NC}"
    fvm flutter doctor
}

# Función para ejecutar todas las acciones
run_all() {
    local env=$1
    echo -e "${BLUE}🔄 Ejecutando secuencia completa para $env...${NC}"
    echo ""
    
    clean_app
    echo ""
    install_dependencies
    echo ""
    run_app $env
}

# Función principal
main() {
    # Verificar si se proporcionaron argumentos
    if [ $# -lt 2 ]; then
        show_help
        exit 1
    fi
    
    local environment=$1
    local action=$2
    
    # Validar argumentos
    if ! validate_environment $environment; then
        exit 1
    fi
    
    if ! validate_action $action; then
        exit 1
    fi
    
    echo -e "${GREEN}=== CocinandoIA Debug Script ===${NC}"
    echo -e "${YELLOW}Entorno: $environment${NC}"
    echo -e "${YELLOW}Acción: $action${NC}"
    echo ""
    
    # Ejecutar acción según el parámetro
    case $action in
        run)
            run_app $environment
            ;;
        build)
            build_app $environment
            ;;
        clean)
            clean_app
            ;;
        install)
            install_dependencies
            ;;
        doctor)
            check_doctor
            ;;
        all)
            run_all $environment
            ;;
    esac
}

# Ejecutar script principal
main "$@"
