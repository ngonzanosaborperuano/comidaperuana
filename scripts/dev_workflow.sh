#!/bin/bash

# Script de flujo de desarrollo completo
echo "🚀 Flujo de desarrollo iniciado..."

# Función para mostrar ayuda
show_help() {
    echo "Uso: ./scripts/dev_workflow.sh [comando]"
    echo ""
    echo "Comandos disponibles:"
    echo "  build     - Generar código y analizar"
    echo "  test      - Ejecutar tests"
    echo "  format    - Formatear código"
    echo "  analyze   - Analizar código"
    echo "  clean     - Limpiar generaciones"
    echo "  all       - Ejecutar todo el flujo"
    echo "  help      - Mostrar esta ayuda"
}

# Función para generar código
generate_code() {
    echo "⚙️ Generando código..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    if [ $? -eq 0 ]; then
        echo "✅ Código generado exitosamente"
    else
        echo "❌ Error al generar código"
        return 1
    fi
}

# Función para formatear código
format_code() {
    echo "🎨 Formateando código..."
    dart format lib/ test/
    if [ $? -eq 0 ]; then
        echo "✅ Código formateado exitosamente"
    else
        echo "❌ Error al formatear código"
        return 1
    fi
}

# Función para analizar código
analyze_code() {
    echo "🔍 Analizando código..."
    flutter analyze
    if [ $? -eq 0 ]; then
        echo "✅ Análisis completado sin errores"
    else
        echo "⚠️ Análisis completado con advertencias"
    fi
}

# Función para ejecutar tests
run_tests() {
    echo "🧪 Ejecutando tests..."
    flutter test
    if [ $? -eq 0 ]; then
        echo "✅ Tests pasaron exitosamente"
    else
        echo "❌ Algunos tests fallaron"
        return 1
    fi
}

# Función para limpiar
clean_code() {
    echo "🧹 Limpiando generaciones..."
    flutter packages pub run build_runner clean
    echo "✅ Limpieza completada"
}

# Función para ejecutar todo
run_all() {
    echo "🔄 Ejecutando flujo completo..."
    
    clean_code
    generate_code
    format_code
    analyze_code
    run_tests
    
    echo "🎉 Flujo completo completado"
}

# Procesar argumentos
case "${1:-help}" in
    "build")
        generate_code
        analyze_code
        ;;
    "test")
        run_tests
        ;;
    "format")
        format_code
        ;;
    "analyze")
        analyze_code
        ;;
    "clean")
        clean_code
        ;;
    "all")
        run_all
        ;;
    "help"|*)
        show_help
        ;;
esac 