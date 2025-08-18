#!/bin/bash

# Script para configurar Firebase para Flutter Flavors
# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Configuración de Firebase para Flutter Flavors${NC}"
echo "=================================================="

echo -e "\n${YELLOW}📋 Pasos para configurar Firebase:${NC}"
echo ""

echo -e "${GREEN}1. 🔥 Ir a Firebase Console:${NC}"
echo "   https://console.firebase.google.com/"
echo "   Seleccionar proyecto: recetas-6a516"
echo ""

echo -e "${GREEN}2. 📱 Agregar apps Android para cada flavor:${NC}"
echo ""

echo -e "${BLUE}   🔴 Development Flavor:${NC}"
echo "   - Package name: com.ngonzano.comidaperuana.dev"
echo "   - Nickname: CocinandoIA Dev"
echo "   - SHA-1: (usar el mismo de producción)"
echo ""

echo -e "${BLUE}   🟡 Staging Flavor:${NC}"
echo "   - Package name: com.ngonzano.comidaperuana.staging"
echo "   - Nickname: CocinandoIA Staging"
echo "   - SHA-1: (usar el mismo de producción)"
echo ""

echo -e "${BLUE}   🟢 Production Flavor:${NC}"
echo "   - Package name: com.ngonzano.comidaperuana (ya existe)"
echo "   - Nickname: CocinandoIA"
echo ""

echo -e "${GREEN}3. 📥 Descargar google-services.json actualizado:${NC}"
echo "   - Reemplazar el archivo en android/app/"
echo ""

echo -e "${GREEN}4. 🔧 Configurar App Check en Firebase Console:${NC}"
echo "   - Ir a App Check en el menú lateral"
echo "   - Habilitar para cada app"
echo "   - Configurar providers:"
echo "     * Debug: Para dev y staging"
echo "     * Play Integrity: Para producción"
echo ""

echo -e "${GREEN}5. 🧪 Probar los flavors:${NC}"
echo "   flutter run -t lib/flavors/main.dart --flavor dev"
echo "   flutter run -t lib/flavors/main.dart --flavor staging"
echo "   flutter run -t lib/flavors/main.dart --flavor prod"
echo ""

echo -e "${YELLOW}⚠️  Nota importante:${NC}"
echo "   - Los flavors dev y staging usarán el mismo SHA-1 que producción"
echo "   - Esto es seguro para desarrollo y testing"
echo "   - En producción real, cada flavor tendría su propio certificado"
echo ""

echo -e "${GREEN}✅ ¿Necesitas ayuda con algún paso específico?${NC}"
echo "   - Configurar Firebase Console"
echo "   - Obtener SHA-1 del certificado"
echo "   - Configurar App Check"
echo "   - Probar la configuración"
echo ""

echo -e "${BLUE}🎯 Comando para verificar SHA-1 actual:${NC}"
echo "   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android"
echo ""

echo "=================================================="
echo -e "${GREEN}🚀 ¡Configura Firebase y disfruta de tus flavors!${NC}"
