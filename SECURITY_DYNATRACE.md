# 🔒 Seguridad de Dynatrace

## ⚠️ **IMPORTANTE: No Exponer IDs en el Código**

Los IDs de Dynatrace **NUNCA** deben estar hardcodeados en el código fuente por razones de seguridad.

## 🛡️ **Mejores Prácticas de Seguridad**

### 1. **Usar Variables de Entorno**

```dart
// ❌ MALO - Hardcodeado
applicationId: 'c83c5ac6-902b-4f26-94e7-4a3fc2746f5d'

// ✅ BUENO - Variable de entorno
applicationId: const String.fromEnvironment('DYNATRACE_APP_ID')
```

### 2. **Configurar Variables de Entorno**

```bash
# Para staging
flutter run --dart-define=DYNATRACE_APP_ID=tu-staging-id --dart-define=DYNATRACE_BEACON_URL=https://staging-beacon.dynatrace.com/mbeacon

# Para producción
flutter run --dart-define=DYNATRACE_APP_ID=tu-prod-id --dart-define=DYNATRACE_BEACON_URL=https://prod-beacon.dynatrace.com/mbeacon
```

### 3. **Archivos de Configuración Seguros**

Crear archivos `.env` separados:

```bash
# .env.staging
DYNATRACE_APP_ID=tu-staging-app-id
DYNATRACE_BEACON_URL=https://staging-beacon.dynatrace.com/mbeacon

# .env.prod
DYNATRACE_APP_ID=tu-prod-app-id
DYNATRACE_BEACON_URL=https://prod-beacon.dynatrace.com/mbeacon
```

### 4. **Gitignore**

Asegúrate de que estos archivos estén en `.gitignore`:

```gitignore
# Variables de entorno
.env
.env.*
!.env.example

# IDs sensibles
**/dynatrace-ids.json
**/secrets.json
```

## 🚨 **Riesgos de Exponer IDs**

1. **Acceso no autorizado** a tu cuenta de Dynatrace
2. **Datos contaminados** en tus métricas
3. **Costos inesperados** por tráfico falso
4. **Violación de políticas** de Dynatrace

## 🔧 **Configuración Actual**

La configuración actual usa valores por defecto seguros que no funcionan en producción hasta que configures las variables de entorno reales.

## 📝 **Próximos Pasos**

1. Obtén los IDs reales de tu cuenta de Dynatrace
2. Configura las variables de entorno
3. Nunca commitees los IDs reales al repositorio
4. Usa diferentes IDs para staging y producción
