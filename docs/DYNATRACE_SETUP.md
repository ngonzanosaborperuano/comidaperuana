# 📊 Guía Paso a Paso: Configuración de Dynatrace

Esta guía te ayudará a configurar Dynatrace en tu aplicación Flutter desde cero.

---

## 📋 Tabla de Contenidos

1. [Prerequisitos](#prerequisitos)
2. [Paso 1: Crear Cuenta y Aplicación en Dynatrace](#paso-1-crear-cuenta-y-aplicación-en-dynatrace)
3. [Paso 2: Obtener Credenciales](#paso-2-obtener-credenciales)
4. [Paso 3: Configurar el Plugin de Flutter](#paso-3-configurar-el-plugin-de-flutter)
5. [Paso 4: Configurar Android](#paso-4-configurar-android)
6. [Paso 5: Configurar iOS](#paso-5-configurar-ios)
7. [Paso 6: Configurar Variables de Entorno](#paso-6-configurar-variables-de-entorno)
8. [Paso 7: Configurar por Entornos](#paso-7-configurar-por-entornos)
9. [Paso 8: Verificar la Configuración](#paso-8-verificar-la-configuración)
10. [Paso 9: Usar el Servicio de Monitoreo](#paso-9-usar-el-servicio-de-monitoreo)
11. [Troubleshooting](#troubleshooting)

---

## Prerequisitos

- ✅ Cuenta de Dynatrace activa
- ✅ Flutter SDK instalado (versión estable)
- ✅ Android Studio / Xcode configurado
- ✅ Proyecto Flutter con flavors configurados (dev, staging, prod)

---

## 🚀 Inicio Rápido: Dónde Encontrar las Opciones en Dynatrace

Si no encuentras las opciones en la interfaz de Dynatrace, sigue estos pasos:

1. **Accede a tu entorno de Dynatrace**: `https://[tu-entorno].dynatrace.com`
2. **Busca en el menú lateral**: 
   - **"Deploy"** o **"Deploy Dynatrace"** → **"Mobile"**
   - O **"Platform"** → **"Mobile"**
3. **Crea una aplicación móvil** (si no tienes una)
4. **Abre la aplicación** y busca **"Flutter configuration"** o **"Settings"**
5. **Descarga el archivo** `dynatrace.config.yaml`

**Si aún no encuentras las opciones**, ve directamente a la sección [Troubleshooting: No encuentro "Mobile app settings"](#-no-encuentro-mobile-app-settings-o-flutter-configuration-en-dynatrace) más abajo.

---

## Paso 1: Crear Cuenta y Aplicación en Dynatrace

### 1.1 Acceder a Dynatrace

1. Ve a [https://www.dynatrace.com/](https://www.dynatrace.com/)
2. Inicia sesión o crea una cuenta
3. Accede a tu entorno de Dynatrace (tu URL será algo como `https://[tu-entorno].dynatrace.com`)

### 1.2 Navegar a Mobile App Settings

Según la [documentación oficial del plugin](https://pub.dev/packages/dynatrace_flutter_plugin#platform-independent-reporting), hay dos formas de acceder:

#### Opción A: Desde el Menú Principal

1. En el menú lateral izquierdo de Dynatrace, busca la sección **"Deploy Dynatrace"** o **"Deploy"**
2. Haz clic en **"Mobile"** o **"Mobile app monitoring"**
3. Si es tu primera vez, verás un botón **"Set up mobile app monitoring"** o **"Create mobile app"**
4. Haz clic para crear una nueva aplicación

#### Opción B: Desde Settings (Configuración)

1. Haz clic en el icono de **⚙️ Settings** (Configuración) en la parte superior derecha
2. En el menú desplegable, busca **"Mobile"** o **"Mobile app settings"**
3. Si ya tienes aplicaciones, verás una lista. Si no, verás un botón para crear una nueva

### 1.3 Crear una Nueva Aplicación Mobile

1. Haz clic en **"Create mobile app"** o **"Add mobile app"**
2. Completa el formulario:
   - **App name**: `GonCook` (o el nombre que prefieras)
   - **Platform**: Selecciona:
     - ✅ **Android** (si vas a monitorear Android)
     - ✅ **iOS** (si vas a monitorear iOS)
     - ✅ **Ambos** (recomendado para Flutter)
   - **App type**: Selecciona **"Hybrid"** (Flutter es una aplicación híbrida)
3. Haz clic en **"Create"** o **"Save"**

### 1.4 Acceder a Flutter Configuration

Después de crear la aplicación:

1. En la lista de aplicaciones móviles, haz clic en la aplicación que acabas de crear
2. Se abrirá la página de configuración de la aplicación
3. Busca la pestaña o sección **"Flutter configuration"** o **"Configuration"**
4. Si no ves esta opción, busca en el menú lateral de la página de la aplicación:
   - **"Settings"** → **"Flutter"**
   - O **"Configuration"** → **"Flutter"**

---

## Paso 2: Obtener Credenciales

Según la [documentación oficial](https://pub.dev/packages/dynatrace_flutter_plugin#platform-independent-reporting), la forma más fácil de obtener las credenciales es descargando el archivo de configuración.

### 2.1 Descargar dynatrace.config.yaml (Método Recomendado)

1. En la página de configuración de tu aplicación móvil, busca la sección **"Flutter configuration"**
2. Verás un botón o enlace que dice **"Download configuration"** o **"Download dynatrace.config.yaml"**
3. Haz clic para descargar el archivo `dynatrace.config.yaml`
4. Este archivo contiene todas las credenciales necesarias

### 2.2 Extraer Credenciales del archivo descargado

Abre el archivo `dynatrace.config.yaml` que descargaste. Verás algo como esto:

```yaml
android:
  config: "
    dynatrace {
      configurations {
        defaultConfig {
          autoStart{
            applicationId 'TU_APPLICATION_ID_AQUI'
            beaconUrl 'TU_BEACON_URL_AQUI'
          }
        }
      }
    }
  "

ios:
  config: "
    <key>DTXApplicationID</key>
    <string>TU_APPLICATION_ID_AQUI</string>
    <key>DTXBeaconURL</key>
    <string>TU_BEACON_URL_AQUI</string>
  "
```

### 2.3 Application ID (App ID)

- **Ubicación en el archivo**: Busca `applicationId` (Android) o `DTXApplicationID` (iOS)
- Es un UUID único para tu aplicación
- Ejemplo: `c83c5ac6-902b-4f26-94e7-4a3fc2746f5d`
- **⚠️ IMPORTANTE**: No compartas este ID públicamente

### 2.4 Beacon URL

- **Ubicación en el archivo**: Busca `beaconUrl` (Android) o `DTXBeaconURL` (iOS)
- URL del servidor de Dynatrace para enviar datos
- Ejemplo: `https://bf87797vgl.bf.dynatrace.com/mbeacon`
- Formato: `https://[environment-id].bf.dynatrace.com/mbeacon`

### 2.5 Método Alternativo: Ver Credenciales en la Web UI

Si no puedes descargar el archivo, puedes ver las credenciales directamente:

1. En la página de tu aplicación móvil, busca la sección **"Configuration"** o **"Settings"**
2. Busca las siguientes claves:
   - **Application ID** o **App ID**
   - **Beacon URL** o **Beacon endpoint**
3. Copia estos valores

**💡 Tip**: Crea aplicaciones separadas para cada entorno (dev, staging, prod) para mantener los datos separados. Cada aplicación tendrá su propio Application ID y Beacon URL.

---

## Paso 3: Configurar el Plugin de Flutter

### 3.1 Verificar Instalación del Plugin

El plugin ya está instalado en tu `pubspec.yaml`:

```yaml
dependencies:
  dynatrace_flutter_plugin: ^3.327.1
```

Si necesitas actualizarlo:

```bash
flutter pub get
```

### 3.2 Configurar dynatrace.config.yaml

Según la [documentación oficial](https://pub.dev/packages/dynatrace_flutter_plugin#platform-independent-reporting), el proceso recomendado es:

1. **Coloca el archivo descargado** en la raíz de tu proyecto Flutter (mismo nivel que `pubspec.yaml`)
2. El archivo debe llamarse exactamente: `dynatrace.config.yaml`

Si no descargaste el archivo, puedes crearlo manualmente usando el formato del Paso 2.

### 3.3 Ejecutar el Configurador de Dynatrace

Una vez que tengas el archivo `dynatrace.config.yaml` en la raíz del proyecto:

```bash
# Desde la raíz de tu proyecto Flutter
dart run dynatrace_flutter_plugin
```

Este comando:
- ✅ Lee el archivo `dynatrace.config.yaml`
- ✅ Configura automáticamente Android (`android/build.gradle.kts`)
- ✅ Configura automáticamente iOS (`ios/Runner/Info.plist`)
- ✅ Aplica todas las configuraciones necesarias

**⚠️ Nota**: 
- Este comando puede sobrescribir configuraciones existentes
- Debes ejecutar este comando cada vez que cambies algo en `dynatrace.config.yaml`
- Si prefieres configurar manualmente, puedes saltarte este paso y seguir los Pasos 4 y 5

---

## Paso 4: Configurar Android

### 4.1 Configurar build.gradle.kts

Edita `android/build.gradle.kts`:

```kotlin
plugins {
    id("com.dynatrace.instrumentation") version "8.325.1.1007"
}

extra["dynatrace.instrumentationFlavor"] = "flutter"

dynatrace {
    configurations {
        create("defaultConfig") {
            autoStart {
                // ⚠️ NO hardcodear estos valores en producción
                // Usar variables de entorno o archivos de configuración
                applicationId("TU_APPLICATION_ID_AQUI")
                beaconUrl("TU_BEACON_URL_AQUI")
            }
            userOptIn(true)
            agentBehavior.startupLoadBalancing(true)
            agentBehavior.startupWithGrailEnabled(true)
        }
    }
}
```

### 4.2 Configurar dynatrace.config.yaml (Opcional)

El archivo `dynatrace.config.yaml` en la raíz del proyecto puede usarse para configuración adicional:

```yaml
android:
  config:
    "dynatrace {
      configurations {
        defaultConfig {
          autoStart{
            applicationId 'TU_APPLICATION_ID'
            beaconUrl 'TU_BEACON_URL'
          }
          userOptIn true
          agentBehavior.startupLoadBalancing true
          agentBehavior.startupWithGrailEnabled true
        }
      }
    }"
```

### 4.3 Configuración Segura con Variables de Entorno

**⚠️ IMPORTANTE**: No hardcodees los IDs en el código. Usa variables de entorno.

Para Android, puedes usar variables de Gradle:

1. Crea `android/local.properties` (si no existe):

```properties
# Dynatrace Configuration
DYNATRACE_APP_ID=tu-application-id-aqui
DYNATRACE_BEACON_URL=tu-beacon-url-aqui
```

2. Actualiza `android/build.gradle.kts`:

```kotlin
dynatrace {
    configurations {
        create("defaultConfig") {
            autoStart {
                val appId = project.findProperty("DYNATRACE_APP_ID") as String? 
                    ?: System.getenv("DYNATRACE_APP_ID") 
                    ?: "default-dev-id"
                val beaconUrl = project.findProperty("DYNATRACE_BEACON_URL") as String? 
                    ?: System.getenv("DYNATRACE_BEACON_URL") 
                    ?: "https://default-beacon.dynatrace.com/mbeacon"
                
                applicationId(appId)
                beaconUrl(beaconUrl)
            }
            userOptIn(true)
            agentBehavior.startupLoadBalancing(true)
            agentBehavior.startupWithGrailEnabled(true)
        }
    }
}
```

---

## Paso 5: Configurar iOS

### 5.1 Configurar Info.plist

Edita `ios/Runner/Info.plist` y agrega:

```xml
<key>DTXApplicationID</key>
<string>TU_APPLICATION_ID_AQUI</string>
<key>DTXBeaconURL</key>
<string>TU_BEACON_URL_AQUI</string>
<key>DTXUserOptIn</key>
<true/>
<key>DTXStartupLoadBalancing</key>
<true/>
<key>DTXStartupWithGrailEnabled</key>
<true/>
```

### 5.2 Configuración Segura con Variables de Entorno

Para iOS, puedes usar variables de build:

1. En Xcode, ve a **Build Settings** → **User-Defined Settings**
2. Agrega:
   - `DYNATRACE_APP_ID` = `tu-application-id`
   - `DYNATRACE_BEACON_URL` = `tu-beacon-url`

3. Actualiza `Info.plist`:

```xml
<key>DTXApplicationID</key>
<string>$(DYNATRACE_APP_ID)</string>
<key>DTXBeaconURL</key>
<string>$(DYNATRACE_BEACON_URL)</string>
```

### 5.3 Configurar dynatrace.config.yaml (Opcional)

```yaml
ios:
  config:
    "<key>DTXApplicationID</key>
    <string>TU_APPLICATION_ID</string>
    <key>DTXBeaconURL</key>
    <string>TU_BEACON_URL</string>
    <key>DTXUserOptIn</key>
    <true/>
    <key>DTXStartupLoadBalancing</key>
    <true/>
    <key>DTXStartupWithGrailEnabled</key>
    <true/>"
```

---

## Paso 6: Configurar Variables de Entorno

### 6.1 Crear Archivos .env

Crea archivos `.env` para cada entorno:

**`.env.dev`**:
```bash
DYNATRACE_APP_ID=dev-application-id
DYNATRACE_BEACON_URL=https://dev-beacon.dynatrace.com/mbeacon
```

**`.env.staging`**:
```bash
DYNATRACE_APP_ID=staging-application-id
DYNATRACE_BEACON_URL=https://staging-beacon.dynatrace.com/mbeacon
```

**`.env.prod`**:
```bash
DYNATRACE_APP_ID=prod-application-id
DYNATRACE_BEACON_URL=https://prod-beacon.dynatrace.com/mbeacon
```

### 6.2 Agregar a .gitignore

Asegúrate de que los archivos `.env` estén en `.gitignore`:

```gitignore
# Variables de entorno
.env
.env.*
!.env.example
```

### 6.3 Crear .env.example

Crea un archivo de ejemplo (sin valores reales):

```bash
# .env.example
DYNATRACE_APP_ID=your-application-id-here
DYNATRACE_BEACON_URL=https://your-beacon-url.dynatrace.com/mbeacon
```

---

## Paso 7: Configurar por Entornos

### 7.1 Verificar Configuración Actual

Tu proyecto ya tiene configuración por entornos en:

```12:14:lib/src/infrastructure/shared/services/monitoring/dynatrace_config.dart
  static DynatraceEnvironmentConfig get currentConfig {
    if (FlavorsConfig.isDev) {
      return DynatraceEnvironmentConfig.dev();
```

### 7.2 Actualizar Configuración

Edita `lib/src/infrastructure/shared/services/monitoring/dynatrace_config.dart`:

```dart
factory DynatraceEnvironmentConfig.staging() {
  return DynatraceEnvironmentConfig(
    applicationId: const String.fromEnvironment(
      'DYNATRACE_APP_ID',
      defaultValue: 'staging-app-id-placeholder',
    ),
    beaconUrl: const String.fromEnvironment(
      'DYNATRACE_BEACON_URL',
      defaultValue: 'https://staging-beacon.dynatrace.com/mbeacon',
    ),
    userOptIn: true,
    startupLoadBalancing: true,
    startupWithGrailEnabled: true,
    environment: 'staging',
  );
}

factory DynatraceEnvironmentConfig.prod() {
  return DynatraceEnvironmentConfig(
    applicationId: const String.fromEnvironment(
      'DYNATRACE_APP_ID',
      defaultValue: 'prod-app-id-placeholder',
    ),
    beaconUrl: const String.fromEnvironment(
      'DYNATRACE_BEACON_URL',
      defaultValue: 'https://prod-beacon.dynatrace.com/mbeacon',
    ),
    userOptIn: true,
    startupLoadBalancing: true,
    startupWithGrailEnabled: true,
    environment: 'production',
  );
}
```

### 7.3 Ejecutar con Variables de Entorno

**Para Staging**:
```bash
flutter run --dart-define=DYNATRACE_APP_ID=tu-staging-id \
           --dart-define=DYNATRACE_BEACON_URL=https://staging-beacon.dynatrace.com/mbeacon \
           --flavor staging \
           -t lib/main_staging.dart
```

**Para Producción**:
```bash
flutter run --dart-define=DYNATRACE_APP_ID=tu-prod-id \
           --dart-define=DYNATRACE_BEACON_URL=https://prod-beacon.dynatrace.com/mbeacon \
           --flavor prod \
           -t lib/main_prod.dart
```

---

## Paso 8: Verificar la Configuración

### 8.1 Verificar Inicialización

El servicio de monitoreo se inicializa automáticamente en el bootstrap:

```37:50:lib/src/shared/core/bootstrap/bootstrap.dart
Future<void> _initializeMonitoring() async {
  try {
    final monitoringService = MonitoringServiceFactory.create();
    await monitoringService.initialize();
  } catch (e) {
    log('❌ Error al inicializar servicio de monitoreo: $e');
    // En desarrollo, podemos continuar sin monitoreo
    if (kDebugMode) {
      log('ℹ️ Continuando sin monitoreo en modo debug');
    } else {
      rethrow; // En producción, es crítico
    }
  }
}
```

### 8.2 Verificar en Logs

Al ejecutar la app, deberías ver en los logs:

```
✅ Dynatrace inicializado correctamente
```

O en caso de error:

```
❌ Error al inicializar servicio de monitoreo: [error]
```

### 8.3 Verificar en Dynatrace Dashboard

1. Ve a tu dashboard de Dynatrace
2. Navega a **"Mobile"** → **"Your App"**
3. Deberías ver:
   - Sesiones activas
   - Eventos en tiempo real
   - Errores reportados

**⏱️ Nota**: Puede tomar algunos minutos para que los datos aparezcan.

---

## Paso 9: Usar el Servicio de Monitoreo

### 9.1 Registrar Eventos

```dart
import 'package:goncook/src/infrastructure/shared/services/monitoring/monitoring_service_factory.dart';

// Obtener el servicio
final monitoringService = MonitoringServiceFactory.create();

// Registrar un evento
monitoringService.logEvent('user_login', parameters: {
  'method': 'email',
  'timestamp': DateTime.now().toIso8601String(),
});
```

### 9.2 Registrar Errores

```dart
try {
  // Tu código aquí
} catch (e, stackTrace) {
  // Registrar error en Dynatrace
  monitoringService.logError(
    'Error al cargar receta: $e',
    stackTrace: stackTrace,
  );
  
  // También logear localmente
  logger.e('Error al cargar receta', error: e, stackTrace: stackTrace);
}
```

### 9.3 Identificar Usuarios

```dart
// Cuando el usuario inicia sesión
monitoringService.setUserInfo(
  userId,
  attributes: {
    'email': user.email,
    'plan': user.subscriptionPlan,
  },
);
```

### 9.4 Ejemplo Completo

```dart
import 'package:goncook/src/infrastructure/shared/services/monitoring/monitoring_service_factory.dart';

class RecipeService {
  final _monitoring = MonitoringServiceFactory.create();
  
  Future<void> loadRecipe(String recipeId) async {
    try {
      _monitoring.logEvent('recipe_load_started', parameters: {
        'recipe_id': recipeId,
      });
      
      // Cargar receta...
      final recipe = await _fetchRecipe(recipeId);
      
      _monitoring.logEvent('recipe_load_success', parameters: {
        'recipe_id': recipeId,
        'duration_ms': duration,
      });
    } catch (e, stackTrace) {
      _monitoring.logError(
        'Error al cargar receta $recipeId: $e',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
```

---

## Troubleshooting

### ❌ No encuentro "Mobile app settings" o "Flutter configuration" en Dynatrace

**Problema**: No puedes encontrar dónde crear la aplicación móvil o descargar la configuración.

**Soluciones**:

#### Solución 1: Verificar Permisos de Usuario

1. Asegúrate de tener permisos de **Administrador** o **Mobile app monitoring** en tu cuenta de Dynatrace
2. Contacta al administrador de tu cuenta si no tienes estos permisos

#### Solución 2: Buscar en el Menú de Navegación

La ubicación puede variar según la versión de Dynatrace:

1. **Menú lateral izquierdo**:
   - Busca **"Deploy"** o **"Deploy Dynatrace"**
   - Dentro, busca **"Mobile"** o **"Mobile app monitoring"**
   
2. **Menú superior**:
   - Haz clic en el icono de **menú (☰)** en la esquina superior izquierda
   - Busca **"Platform"** → **"Mobile"**
   
3. **Búsqueda global**:
   - Usa la barra de búsqueda en la parte superior
   - Busca: `mobile app`, `mobile monitoring`, o `flutter`

#### Solución 3: Acceso Directo por URL

Intenta acceder directamente (reemplaza `[tu-entorno]` con tu entorno):

```
https://[tu-entorno].dynatrace.com/#mobileappmonitoring
```

O:

```
https://[tu-entorno].dynatrace.com/ui/mobileappmonitoring
```

#### Solución 4: Crear Aplicación Manualmente

Si no encuentras la interfaz, puedes crear la configuración manualmente:

1. **Obtén el Application ID y Beacon URL de tu administrador de Dynatrace**
2. O contacta al soporte de Dynatrace para que te proporcionen estas credenciales
3. Usa los valores en el archivo `dynatrace.config.yaml` (ver Paso 3)

#### Solución 5: Usar la API de Dynatrace

Si tienes acceso a la API de Dynatrace, puedes crear la aplicación mediante API:

```bash
# Ejemplo de llamada a la API (requiere token de API)
curl -X POST "https://[tu-entorno].dynatrace.com/api/config/v1/mobileApplications" \
  -H "Authorization: Api-Token [tu-token]" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "GonCook",
    "applicationType": "HYBRID",
    "platforms": ["ANDROID", "IOS"]
  }'
```

**💡 Tip**: Si estás usando una versión antigua de Dynatrace, la interfaz puede ser diferente. Considera actualizar o contactar al soporte.

### ❌ Error: "Dynatrace not initialized"

**Causa**: El servicio no se inicializó correctamente.

**Solución**:
1. Verifica que `_initializeMonitoring()` se ejecute en el bootstrap
2. Revisa los logs para ver el error específico
3. Asegúrate de que las credenciales sean correctas

### ❌ Error: "Invalid Application ID"

**Causa**: El Application ID no es válido o no coincide con tu cuenta.

**Solución**:
1. Verifica el Application ID en tu dashboard de Dynatrace
2. Asegúrate de usar el ID correcto para el entorno correcto
3. Verifica que no haya espacios o caracteres especiales

### ❌ Error: "Beacon URL not reachable"

**Causa**: La URL del beacon no es accesible o es incorrecta.

**Solución**:
1. Verifica la URL en tu dashboard de Dynatrace
2. Asegúrate de que la URL tenga el formato correcto: `https://[id].bf.dynatrace.com/mbeacon`
3. Verifica tu conexión a internet

### ❌ No aparecen datos en Dynatrace

**Causa**: Varias posibles causas.

**Solución**:
1. **Espera unos minutos**: Los datos pueden tardar en aparecer
2. **Verifica el entorno**: Asegúrate de estar viendo el entorno correcto en Dynatrace
3. **Verifica los logs**: Busca errores en los logs de la app
4. **Verifica la inicialización**: Asegúrate de que Dynatrace se inicialice correctamente
5. **Verifica userOptIn**: Si está en `true`, el usuario debe aceptar el tracking

### ❌ Error en Android: "Plugin not found"

**Causa**: El plugin de Gradle no está configurado correctamente.

**Solución**:
1. Verifica que el plugin esté en `android/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.dynatrace.instrumentation") version "8.325.1.1007"
   }
   ```
2. Ejecuta `flutter clean` y `flutter pub get`
3. Reconstruye el proyecto

### ❌ Error en iOS: "DTXApplicationID not found"

**Causa**: Las claves no están en `Info.plist`.

**Solución**:
1. Verifica que `DTXApplicationID` y `DTXBeaconURL` estén en `ios/Runner/Info.plist`
2. Asegúrate de que los valores sean correctos
3. Limpia y reconstruye el proyecto iOS

---

## 📚 Recursos Adicionales

- [Documentación Oficial de Dynatrace Flutter](https://www.dynatrace.com/support/help/shortlink/mobile-app-monitoring-flutter)
- [Dynatrace Flutter Plugin en pub.dev - Documentación Completa](https://pub.dev/packages/dynatrace_flutter_plugin#platform-independent-reporting) - **Incluye toda la información sobre configuración y uso del plugin**
- [Guía de Seguridad de Dynatrace](./SECURITY_DYNATRACE.md)
- [Documentación de OneAgent para Android](https://www.dynatrace.com/support/help/setup-and-configuration/oneagent/android/)
- [Documentación de OneAgent para iOS](https://www.dynatrace.com/support/help/setup-and-configuration/oneagent/ios/)

---

## ✅ Checklist Final

Antes de considerar la configuración completa:

- [ ] Application ID y Beacon URL obtenidos de Dynatrace
- [ ] Plugin de Flutter instalado y actualizado
- [ ] Android configurado en `build.gradle.kts`
- [ ] iOS configurado en `Info.plist`
- [ ] Variables de entorno configuradas para cada flavor
- [ ] Archivos `.env` creados (y en `.gitignore`)
- [ ] Servicio de monitoreo inicializado correctamente
- [ ] Eventos de prueba registrados en Dynatrace
- [ ] Errores de prueba visibles en el dashboard
- [ ] Documentación de seguridad revisada

---

**🎉 ¡Configuración Completada!**

Tu aplicación ahora está configurada para enviar métricas, eventos y errores a Dynatrace.

**Próximos pasos**:
1. Configurar alertas en Dynatrace
2. Crear dashboards personalizados
3. Configurar análisis de rendimiento
4. Implementar tracking de usuarios

---

**Última actualización**: Configuración inicial de Dynatrace
