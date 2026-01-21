#!/bin/bash

# Script para generar código de Pigeon
# Uso: ./scripts/generate_pigeon.sh

set -e

echo "🕊️  Generando código de Pigeon..."

# Verificar que pigeon está instalado
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart no está instalado"
    exit 1
fi

# Generar código
dart run pigeon --input pigeon/api.dart

echo "✅ Código de Pigeon generado exitosamente"
echo ""
echo "📁 Archivos generados:"
echo "   - lib/core/services/pigeon/generated_api.dart"
echo "   - android/app/src/main/kotlin/com/example/goncook/PigeonApi.kt"
echo "   - ios/Runner/PigeonApi.swift"
echo ""
echo "⚠️  Recuerda implementar las interfaces en código nativo:"
echo "   - Android: MainActivity.kt"
echo "   - iOS: AppDelegate.swift"
