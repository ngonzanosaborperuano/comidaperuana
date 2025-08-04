#!/bin/bash

# Script para generar código automáticamente
echo "🚀 Generando código..."

# Limpiar generaciones anteriores
echo "🧹 Limpiando generaciones anteriores..."
flutter packages pub run build_runner clean

# Generar código
echo "⚙️ Generando código con build_runner..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Verificar si la generación fue exitosa
if [ $? -eq 0 ]; then
    echo "✅ Código generado exitosamente!"
    
    # Formatear código generado
    echo "🎨 Formateando código..."
    dart format lib/ test/
    
    # Analizar código
    echo "🔍 Analizando código..."
    flutter analyze
    
    echo "🎉 ¡Todo listo!"
else
    echo "❌ Error al generar código"
    exit 1
fi 