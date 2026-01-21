# Guía Completa de Pigeon - Instalación, Implementación y Mejores Prácticas

## 📖 Índice

1. [¿Qué es Pigeon?](#qué-es-pigeon)
2. [Instalación Paso a Paso](#instalación-paso-a-paso)
3. [Proceso de Implementación Completo](#proceso-de-implementación-completo)
4. [Configuración en Xcode (iOS)](#configuración-en-xcode-ios)
5. [Configuración en Android](#configuración-en-android)
6. [Uso en Flutter con Clean Architecture](#uso-en-flutter-con-clean-architecture)
7. [Mejores Prácticas](#mejores-prácticas)
8. [Troubleshooting](#troubleshooting)
9. [Ejemplos del Proyecto](#ejemplos-del-proyecto)

---

## ¿Qué es Pigeon?

**Pigeon** es una herramienta de Flutter que genera código tipo-safe para comunicación entre Flutter y código nativo (Android/iOS). Es una alternativa mejorada a `MethodChannel` porque:

### ✅ Ventajas sobre MethodChannel

- **Tipo-safe**: Detecta errores en tiempo de compilación, no en runtime
- **Sin strings mágicos**: No necesitas recordar nombres de métodos o canales
- **Auto-completado**: IDE sugiere métodos disponibles automáticamente
- **Documentación automática**: Genera código documentado
- **Bidireccional**: Soporta comunicación Flutter → Nativo y Nativo → Flutter
- **Validación de tipos**: Verifica tipos de parámetros y retornos
- **Mantenible**: Cambios en la API se reflejan automáticamente en todas las plataformas

### ❌ Desventajas de MethodChannel (lo que Pigeon resuelve)

```dart
// ❌ MethodChannel - Propenso a errores
const platform = MethodChannel('com.example/app');
final result = await platform.invokeMethod('getDeviceModel'); // String mágico
// ¿Qué pasa si escribo mal el nombre? Error en runtime
// ¿Qué tipo retorna? No lo sé hasta ejecutar
```

```dart
// ✅ Pigeon - Tipo-safe y claro
final api = DeviceInfoApi();
final model = await api.getDeviceModel(); // Autocompletado y tipo-safe
// El IDE sabe exactamente qué retorna y qué parámetros necesita
```

---

## Instalación Paso a Paso

### Paso 1: Agregar Dependencia

Edita `pubspec.yaml` y agrega Pigeon en `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.5.3
  pigeon: ^24.0.0  # ← Agregar esta línea
```

### Paso 2: Instalar Dependencias

```bash
flutter pub get
```

### Paso 3: Verificar Instalación

```bash
flutter pub run pigeon --version
```

Deberías ver la versión de Pigeon instalada.

---

## Proceso de Implementación Completo

### Paso 1: Crear Archivo de Definición de API

El archivo de definición está en `pigeon/api.dart`. Contiene la configuración y las APIs definidas:

```dart
/// Archivo de definición de API para Pigeon
/// 
/// Este archivo define la interfaz de comunicación tipo-safe entre Flutter
/// y código nativo (Android/iOS). Pigeon genera automáticamente el código
/// necesario para ambas plataformas.
/// 
/// Para generar el código, ejecutar:
/// ```bash
/// dart run pigeon --input pigeon/api.dart
/// ```

import 'package:pigeon/pigeon.dart';

/// Configuración para generar código Flutter
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/services/pigeon/generated_api.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/ngonzano/goncook/PigeonApi.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.ngonzano.goncook',
    ),
    swiftOut: 'ios/Runner/PigeonApi.swift',
    swiftOptions: SwiftOptions(),
  ),
)

/// Ejemplo: API para obtener información del dispositivo
/// 
/// Este es un ejemplo básico. Puedes agregar más APIs según tus necesidades.
@HostApi()
abstract class DeviceInfoApi {
  /// Obtiene el modelo del dispositivo
  String getDeviceModel();

  /// Obtiene la versión del sistema operativo
  String getOsVersion();

  /// Obtiene el ID único del dispositivo
  String getDeviceId();
}
```

**Nota**: El archivo `pigeon/api.dart` contiene ejemplos de otras APIs que no están implementadas en el proyecto. Solo `DeviceInfoApi` está implementada y funcionando.

### Paso 2: Generar Código

Ejecuta el comando de generación:

```bash
flutter pub run pigeon --input pigeon/api.dart
```

**O usa el script incluido:**

```bash
./scripts/generate_pigeon.sh
```

Este comando genera tres archivos:

1. **`lib/core/services/pigeon/generated_api.dart`** - Código Flutter
2. **`android/app/src/main/kotlin/com/ngonzano/goncook/PigeonApi.kt`** - Código Android (Kotlin)
3. **`ios/Runner/PigeonApi.swift`** - Código iOS (Swift)

### Paso 3: Verificar Archivos Generados

Asegúrate de que los archivos se generaron correctamente:

```bash
# Verificar Flutter
ls -la lib/core/services/pigeon/generated_api.dart

# Verificar Android
ls -la android/app/src/main/kotlin/com/ngonzano/goncook/PigeonApi.kt

# Verificar iOS
ls -la ios/Runner/PigeonApi.swift
```

---

## Configuración en Xcode (iOS)

### ⚠️ Paso Crítico: Agregar Archivo al Target

**Este es el paso más común donde falla la implementación.** El archivo `PigeonApi.swift` debe estar agregado al target "Runner" en Xcode.

### Opción 1: Script Automático (Recomendado)

```bash
# Instalar dependencia Ruby (solo una vez)
gem install xcodeproj

# Ejecutar script automático
ruby scripts/add_pigeon_to_xcode.rb
```

El script:
- Verifica que el archivo existe
- Lo agrega al proyecto de Xcode
- Lo agrega al target "Runner"
- Guarda los cambios

### Opción 2: Manual en Xcode

1. **Abrir el proyecto en Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```
   **⚠️ CRÍTICO**: Usa `.xcworkspace`, NO `.xcodeproj`

2. **Agregar PigeonApi.swift al Target**:
   - En el navegador de archivos de Xcode (panel izquierdo), busca `Runner/PigeonApi.swift`
   - **Si NO aparece**:
     - Abre Finder y navega a `ios/Runner/PigeonApi.swift`
     - Arrástralo a la carpeta `Runner` en Xcode
     - En el diálogo que aparece, marca "Copy items if needed" y selecciona "Runner" en "Add to targets"
   - **Si ya aparece**:
     - Selecciona el archivo `PigeonApi.swift`
     - Abre el **File Inspector** (⌥⌘1 o View → Inspectors → File)
     - En la sección **"Target Membership"**, marca la casilla **"Runner"**

3. **Verificar**:
   ```
   Runner/
   ├── AppDelegate.swift
   ├── PigeonApi.swift  ← Debe tener checkmark en Target Membership
   └── ...
   ```

### Paso 4: Implementar en AppDelegate.swift

Edita `ios/Runner/AppDelegate.swift`:

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // Registrar implementación de la API de Pigeon
    let deviceInfoApi = DeviceInfoApiImpl()
    DeviceInfoApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: deviceInfoApi)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// Implementar la interfaz generada por Pigeon
class DeviceInfoApiImpl: DeviceInfoApi {
    func getDeviceModel() throws -> String {
        return UIDevice.current.model
    }
    
    func getOsVersion() throws -> String {
        return UIDevice.current.systemVersion
    }
    
    func getDeviceId() throws -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    }
}
```

**Nota**: Los métodos tienen `throws` porque Pigeon genera la interfaz con manejo de errores.

### Paso 5: Limpiar y Reconstruir

1. En Xcode: **Product → Clean Build Folder** (⇧⌘K)
2. Reconstruye: **Product → Build** (⌘B)
3. Ejecuta la app

---

## Configuración en Android

### Paso 1: Verificar Package Name

El package name en `pigeon/api.dart` debe coincidir con el de tu aplicación:

```dart
kotlinOptions: KotlinOptions(
  package: 'com.ngonzano.goncook',
),
```

Verifica que coincida en `android/app/build.gradle.kts`:

```kotlin
android {
    namespace = "com.ngonzano.goncook"
    defaultConfig {
        applicationId = "com.ngonzano.goncook"
    }
}
```

### Paso 2: Implementar en MainActivity.kt

Edita `android/app/src/main/kotlin/com/ngonzano/goncook/MainActivity.kt`:

```kotlin
package com.ngonzano.goncook

import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.ngonzano.goncook.PigeonApi
import com.ngonzano.goncook.DeviceInfoApi

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Registrar implementación de la API de Pigeon
        PigeonApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger, 
            DeviceInfoApiImpl(this)
        )
    }
}

// Implementar la interfaz generada por Pigeon
class DeviceInfoApiImpl(private val context: android.content.Context) : DeviceInfoApi {
    override fun getDeviceModel(): String {
        return Build.MODEL
    }
    
    override fun getOsVersion(): String {
        return Build.VERSION.RELEASE
    }
    
    override fun getDeviceId(): String {
        return Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ANDROID_ID
        ) ?: "unknown"
    }
}
```

**Nota**: Pasamos `this` (MainActivity) como contexto a `DeviceInfoApiImpl` para que pueda acceder a `contentResolver` necesario para obtener el Android ID.

### Paso 3: Verificar Permisos (si es necesario)

Si necesitas permisos especiales, agrégalos en `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <!-- Otros permisos según necesites -->
</manifest>
```

---

## Uso en Flutter con Clean Architecture

### Estructura Recomendada

Siguiendo Clean Architecture, crea un servicio que encapsule la comunicación con Pigeon:

```
lib/core/services/
└── device/
    └── device_info_service.dart
```

### Implementación del Servicio

El servicio está implementado en `lib/core/services/device/device_info_service.dart`:

```dart
/// Servicio para obtener información del dispositivo usando Pigeon
/// 
/// Este servicio encapsula la comunicación con código nativo a través
/// de la API generada por Pigeon, siguiendo Clean Architecture.
import 'package:fpdart/fpdart.dart';
import 'package:goncook/core/errors/failures.dart';
import 'package:goncook/core/services/pigeon/generated_api.dart';
import 'package:logging/logging.dart';

/// Servicio para obtener información del dispositivo
/// 
/// Utiliza Pigeon para comunicación tipo-safe con código nativo.
/// Sigue Clean Architecture usando Either<Failure, T> para manejo de errores.
class DeviceInfoService {
  final _logger = Logger('DeviceInfoService');
  final DeviceInfoApi _api;

  DeviceInfoService({DeviceInfoApi? api}) : _api = api ?? DeviceInfoApi();

  /// Obtiene el modelo del dispositivo
  /// 
  /// Retorna Either<Failure, String> con el modelo o un error
  Future<Either<Failure, String>> getDeviceModel() async {
    try {
      _logger.fine('Getting device model');
      final model = await _api.getDeviceModel();
      _logger.info('Device model retrieved: $model');
      return Right(model);
    } catch (e, stackTrace) {
      _logger.severe('Error getting device model', e, stackTrace);
      return Left(PlatformFailure('Failed to get device model: $e'));
    }
  }

  /// Obtiene la versión del sistema operativo
  /// 
  /// Retorna Either<Failure, String> con la versión o un error
  Future<Either<Failure, String>> getOsVersion() async {
    try {
      _logger.fine('Getting OS version');
      final version = await _api.getOsVersion();
      _logger.info('OS version retrieved: $version');
      return Right(version);
    } catch (e, stackTrace) {
      _logger.severe('Error getting OS version', e, stackTrace);
      return Left(PlatformFailure('Failed to get OS version: $e'));
    }
  }

  /// Obtiene el ID único del dispositivo
  /// 
  /// Retorna Either<Failure, String> con el ID o un error
  Future<Either<Failure, String>> getDeviceId() async {
    try {
      _logger.fine('Getting device ID');
      final deviceId = await _api.getDeviceId();
      _logger.info('Device ID retrieved');
      return Right(deviceId);
    } catch (e, stackTrace) {
      _logger.severe('Error getting device ID', e, stackTrace);
      return Left(PlatformFailure('Failed to get device ID: $e'));
    }
  }

  /// Obtiene información completa del dispositivo
  /// 
  /// Retorna Either<Failure, DeviceInfo> con toda la información o un error
  Future<Either<Failure, DeviceInfo>> getDeviceInfo() async {
    try {
      _logger.fine('Getting complete device info');
      
      final modelResult = await getDeviceModel();
      final osVersionResult = await getOsVersion();
      final deviceIdResult = await getDeviceId();

      return modelResult.flatMap((model) =>
        osVersionResult.flatMap((osVersion) =>
          deviceIdResult.map((deviceId) => DeviceInfo(
            model: model,
            osVersion: osVersion,
            deviceId: deviceId,
          ))
        )
      );
    } catch (e, stackTrace) {
      _logger.severe('Error getting device info', e, stackTrace);
      return Left(UnknownFailure('Failed to get device info: $e'));
    }
  }
}
```

### Uso en UI - Ejemplo Real del Proyecto

El proyecto incluye un ejemplo de uso en `lib/features/auth/presentation/screnns/login_view.dart`:

```dart
/// Botón para probar la funcionalidad de Pigeon
class _TestDeviceInfoButton extends StatelessWidget {
  const _TestDeviceInfoButton();

  Future<void> _showDeviceInfo(BuildContext context) async {
    final deviceService = DeviceInfoService();
    
    // Mostrar loading
    context.showLoading();
    
    try {
      final result = await deviceService.getDeviceInfo();
      
      if (!context.mounted) return;
      context.hideLoading();
      
      result.fold(
        (failure) {
          // Mostrar error
          context.showBottomSheet(
            title: 'Error al obtener información',
            onClose: context.pop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              children: [
                AppText(
                  text: failure.message,
                  fontSize: AppSpacing.md,
                  color: context.color.error,
                ),
                AppButton(
                  text: 'Cerrar',
                  onPressed: context.pop,
                ),
              ],
            ),
          );
        },
        (deviceInfo) {
          // Mostrar información exitosa
          context.showBottomSheet(
            title: 'Información del Dispositivo',
            onClose: context.pop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              children: [
                AppText(
                  text: 'Modelo: ${deviceInfo.model}',
                  fontSize: AppSpacing.md,
                ),
                AppText(
                  text: 'OS: ${deviceInfo.osVersion}',
                  fontSize: AppSpacing.md,
                ),
                AppText(
                  text: 'ID: ${deviceInfo.deviceId}',
                  fontSize: AppSpacing.sm,
                ),
                if (deviceInfo.brand != null)
                  AppText(
                    text: 'Marca: ${deviceInfo.brand}',
                    fontSize: AppSpacing.md,
                  ),
                AppButton(
                  text: 'Cerrar',
                  onPressed: context.pop,
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      context.hideLoading();
      context.showBottomSheet(
        title: 'Error',
        onClose: context.pop,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: [
            AppText(
              text: 'Error inesperado: $e',
              fontSize: AppSpacing.md,
              color: context.color.error,
            ),
            AppButton(
              text: 'Cerrar',
              onPressed: context.pop,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: '🔍 Info Dispositivo',
      onPressed: () => _showDeviceInfo(context),
    );
  }
}
```

---

## Mejores Prácticas

### ✅ CORRECTO

#### 1. Usar Either para Manejo de Errores

El proyecto usa `Either<Failure, T>` de fpdart en `DeviceInfoService`. Ejemplo real:

```dart
Future<Either<Failure, String>> getDeviceModel() async {
  try {
    _logger.fine('Getting device model');
    final model = await _api.getDeviceModel();
    _logger.info('Device model retrieved: $model');
    return Right(model);
  } catch (e, stackTrace) {
    _logger.severe('Error getting device model', e, stackTrace);
    return Left(PlatformFailure('Failed to get device model: $e'));
  }
}
```

#### 2. Documentar APIs

En `pigeon/api.dart`, las APIs están documentadas:

```dart
/// Obtiene el modelo del dispositivo
String getDeviceModel();

/// Obtiene la versión del sistema operativo
String getOsVersion();

/// Obtiene el ID único del dispositivo
String getDeviceId();
```

#### 3. Usar Clases de Datos para Estructuras Complejas

El proyecto usa la clase `DeviceInfo` generada por Pigeon (definida en `pigeon/api.dart` y generada en `generated_api.dart`). Esta clase se usa en `DeviceInfoService.getDeviceInfo()`.

#### 4. Logging Apropiado

El proyecto usa `Logger` de `package:logging/logging.dart` en `DeviceInfoService`:

```dart
final _logger = Logger('DeviceInfoService');

Future<Either<Failure, String>> getDeviceModel() async {
  try {
    _logger.fine('Getting device model');
    final model = await _api.getDeviceModel();
    _logger.info('Device model retrieved: $model');
    return Right(model);
  } catch (e, stackTrace) {
    _logger.severe('Error getting device model', e, stackTrace);
    return Left(PlatformFailure('Failed to get device model: $e'));
  }
}
```

#### 5. Regenerar Código Después de Cambios

Siempre regenera el código después de modificar `pigeon/api.dart`:

```bash
flutter pub run pigeon --input pigeon/api.dart
```

#### 6. Agrupar APIs Relacionadas

En el proyecto, `DeviceInfoApi` agrupa métodos relacionados con información del dispositivo:
- `getDeviceModel()`
- `getOsVersion()`
- `getDeviceId()`

Todos estos métodos están relacionados y pertenecen a la misma responsabilidad.

### ❌ INCORRECTO

#### 1. No Manejar Errores

El proyecto siempre maneja errores usando `Either<Failure, T>`. No retorna directamente valores que pueden fallar sin control.

#### 2. Usar Tipos Primitivos para Datos Complejos

El proyecto usa la clase `DeviceInfo` (generada por Pigeon) en lugar de retornar strings individuales, lo que permite agrupar información relacionada.

#### 3. No Regenerar Código

```dart
// ❌ Siempre regenerar después de modificar pigeon/api.dart
// Si no regeneras, el código nativo no tendrá los cambios
```

#### 4. Mezclar Responsabilidades

En el proyecto, `DeviceInfoApi` tiene una responsabilidad clara: obtener información del dispositivo. No mezcla con otras funcionalidades como sensores o archivos.

#### 5. No Documentar

En el proyecto, todas las APIs en `pigeon/api.dart` están documentadas con comentarios que explican su propósito.

---

## Troubleshooting

### Error: "Cannot find type 'DeviceInfoApi' in scope" (iOS)

**Causa**: El archivo `PigeonApi.swift` no está agregado al target "Runner".

**Solución**:
1. Abre Xcode: `open ios/Runner.xcworkspace`
2. Selecciona `PigeonApi.swift`
3. File Inspector (⌥⌘1) → Target Membership → Marca "Runner"
4. O usa el script: `ruby scripts/add_pigeon_to_xcode.rb`

### Error: "Unable to establish connection on channel"

**Causa**: La API no está registrada en código nativo.

**Solución**:
1. Verifica que el código en `AppDelegate.swift` (iOS) o `MainActivity.kt` (Android) esté descomentado
2. Verifica que estás llamando a `setUp()` antes de usar la API
3. Asegúrate de que el archivo generado esté en el target correcto

### Error: "No such module 'Flutter'" (iOS)

**Causa**: Estás usando `.xcodeproj` en lugar de `.xcworkspace`.

**Solución**:
```bash
open ios/Runner.xcworkspace  # ✅ Correcto
# NO uses: open ios/Runner.xcodeproj  # ❌ Incorrecto
```

### Error: "Type mismatch"

**Causa**: El código generado está desactualizado.

**Solución**:
```bash
flutter pub run pigeon --input pigeon/api.dart
```

### Error: "Multiple commands produce..."

**Solución**:
1. Limpia el build folder (⇧⌘K en Xcode)
2. Elimina DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Reconstruye el proyecto

### El archivo sigue sin reconocerse

**Solución**:
1. Cierra Xcode completamente
2. Elimina Pods y reinstala:
   ```bash
   cd ios
   rm -rf Podfile.lock Pods/
   pod install
   ```
3. Abre Xcode nuevamente

---

## Ejemplos del Proyecto

### Archivos del Proyecto

El proyecto incluye una implementación completa de Pigeon:

- **Definición de API**: `pigeon/api.dart`
- **Servicio Flutter**: `lib/core/services/device/device_info_service.dart`
- **Implementación Android**: `android/app/src/main/kotlin/com/ngonzano/goncook/MainActivity.kt`
- **Implementación iOS**: `ios/Runner/AppDelegate.swift`
- **Ejemplo de uso en UI**: `lib/features/auth/presentation/screnns/login_view.dart` (widget `_TestDeviceInfoButton`)

### Cómo Probar

1. Ejecuta la app: `flutter run`
2. Navega a la pantalla de login
3. Presiona el botón "🔍 Info Dispositivo"
4. Deberías ver un bottom sheet con la información del dispositivo:
   - Modelo del dispositivo
   - Versión del sistema operativo
   - ID único del dispositivo

Si aparece un error, verifica que:
- `PigeonApi.swift` esté agregado al target "Runner" en Xcode (iOS)
- El código en `MainActivity.kt` y `AppDelegate.swift` esté descomentado
- El código haya sido regenerado después de cambios en `pigeon/api.dart`

---

## Checklist de Implementación

### Instalación
- [ ] Pigeon agregado en `dev_dependencies`
- [ ] `flutter pub get` ejecutado
- [ ] Pigeon instalado correctamente

### Definición de API
- [ ] Archivo `pigeon/api.dart` creado
- [ ] APIs definidas con `@HostApi()` o `@FlutterApi()`
- [ ] Configuración de `@ConfigurePigeon` correcta

### Generación de Código
- [ ] Código generado con `flutter pub run pigeon --input pigeon/api.dart`
- [ ] Archivo Flutter generado: `lib/core/services/pigeon/generated_api.dart`
- [ ] Archivo Android generado: `android/app/src/main/kotlin/com/ngonzano/goncook/PigeonApi.kt`
- [ ] Archivo iOS generado: `ios/Runner/PigeonApi.swift`

### Configuración iOS
- [ ] `PigeonApi.swift` agregado al target "Runner" en Xcode
- [ ] Código implementado en `AppDelegate.swift`
- [ ] `DeviceInfoApiSetup.setUp()` llamado correctamente
- [ ] Proyecto compila sin errores

### Configuración Android
- [ ] Package name correcto en `pigeon/api.dart`
- [ ] Código implementado en `MainActivity.kt`
- [ ] `PigeonApi.setUp()` llamado correctamente
- [ ] Proyecto compila sin errores

### Implementación Flutter
- [ ] Servicio creado siguiendo Clean Architecture
- [ ] Manejo de errores con `Either<Failure, T>`
- [ ] Logging implementado
- [ ] UI usando `FutureBuilder` o similar

### Testing
- [ ] Funciona en iOS
- [ ] Funciona en Android
- [ ] Manejo de errores probado
- [ ] Logs verificados

---

## Recursos Adicionales

- [Documentación oficial de Pigeon](https://pub.dev/packages/pigeon)
- [Ejemplos de Pigeon](https://github.com/flutter/packages/tree/main/packages/pigeon/example)
- [Guía de Platform Channels](https://docs.flutter.dev/platform-integration/platform-channels)
- [Clean Architecture en Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

---

## Scripts Útiles

### Generar Código

```bash
./scripts/generate_pigeon.sh
```

### Agregar a Xcode (iOS)

```bash
ruby scripts/add_pigeon_to_xcode.rb
```

### Verificar Instalación

```bash
flutter pub run pigeon --version
```

---

**Última actualización**: Guía completa unificada de Pigeon con ejemplos del proyecto
