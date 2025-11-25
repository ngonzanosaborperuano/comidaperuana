# Scripts de Debug para Goncook

Este directorio contiene scripts para facilitar el desarrollo y debug de la aplicación CocinandoIA en diferentes entornos.

## 📱 Scripts Disponibles

### 1. `debug_app.sh` - Script Completo
Script completo con múltiples funcionalidades para debug.

**Uso:**
```bash
./debug_app.sh [ENTORNO] [ACCIÓN]
```

**Entornos:**
- `dev` - Entorno de desarrollo
- `staging` - Entorno de pruebas  
- `prod` - Entorno de producción

**Acciones:**
- `run` - Ejecutar la aplicación
- `build` - Generar APK
- `clean` - Limpiar build
- `install` - Instalar dependencias
- `doctor` - Verificar configuración
- `all` - Ejecutar clean + install + run

**Ejemplos:**
```bash
# Ejecutar en desarrollo
./debug_app.sh dev run

# Generar APK de producción
./debug_app.sh prod build

# Secuencia completa para staging
./debug_app.sh staging all
```

### 2. `quick_debug.sh` - Script Rápido
Script simple para ejecutar rápidamente la aplicación.

**Uso:**
```bash
./quick_debug.sh [ENTORNO]
```

**Ejemplos:**
```bash
# Ejecutar en desarrollo
./quick_debug.sh dev

# Ejecutar en staging
./quick_debug.sh staging

# Ejecutar en producción
./quick_debug.sh prod
```

## 🚀 Uso Rápido

### Para Desarrollo:
```bash
./scripts/quick_debug.sh dev
```

### Para Staging:
```bash
./scripts/quick_debug.sh staging
```

### Para Producción:
```bash
./scripts/quick_debug.sh prod
```

## 🔧 Funcionalidades

- ✅ **Validación de entornos** - Solo acepta dev, staging, prod
- ✅ **Archivos main automáticos** - Detecta el archivo correcto según el entorno
- ✅ **Colores en terminal** - Output visual atractivo
- ✅ **Manejo de errores** - Validaciones y mensajes claros
- ✅ **Múltiples acciones** - run, build, clean, install, doctor
- ✅ **Secuencia completa** - clean + install + run en un comando

## 📁 Estructura de Archivos

```
lib/
├── main_dev.dart      # Entorno de desarrollo
├── main_staging.dart  # Entorno de staging
└── main_prod.dart     # Entorno de producción

android/app/src/
├── dev/
│   └── google-services.json
├── staging/
│   └── google-services.json
└── prod/
    └── google-services.json
```

## 🎯 Casos de Uso Comunes

### Desarrollo Diario:
```bash
./scripts/quick_debug.sh dev
```

### Generar APK para Testing:
```bash
./scripts/debug_app.sh staging build
```

### Limpiar y Reinstalar:
```bash
./scripts/debug_app.sh dev clean
./scripts/debug_app.sh dev install
```

### Verificar Configuración:
```bash
./scripts/debug_app.sh dev doctor
```

## ⚠️ Notas Importantes

1. **Asegúrate de tener un dispositivo conectado** o emulador ejecutándose
2. **Los scripts deben ejecutarse desde la raíz del proyecto**
3. **Verifica que FVM esté instalado y configurado**
4. **Para builds de release, usa `--release` en lugar de `--debug`**
5. **El proyecto usa FVM con Flutter 3.35.1**

## 🆘 Solución de Problemas

### Error de permisos:
```bash
chmod +x scripts/*.sh
```

### Error de archivo no encontrado:
Verifica que estés en la raíz del proyecto: `/Users/niltongonzano/RicoPE/comidaperuana`

### Error de Flutter:
```bash
fvm flutter doctor
./scripts/debug_app.sh dev doctor
```
