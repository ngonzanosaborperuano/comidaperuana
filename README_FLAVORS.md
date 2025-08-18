# Flutter Flavors - Comida Peruana (Android + Dart)

Este proyecto está configurado con Flutter Flavors para manejar diferentes entornos de desarrollo, staging y producción. **Solo configurado para Android y código Dart.**

## 🏗️ Estructura de Flavors

```
lib/flavors/
├── flavor_config.dart      # Configuración global de flavors
├── main_common.dart        # Lógica común para todos los flavors
├── main_dev.dart          # Punto de entrada para desarrollo
├── main_staging.dart      # Punto de entrada para staging
├── main_prod.dart         # Punto de entrada para producción
```

## 🚀 Comandos de Ejecución

### Android

#### Ejecutar en dispositivo/emulador:
```bash
# Desarrollo
flutter run -t lib/flavors/main_dev.dart --flavor dev

# Staging
flutter run -t lib/flavors/main_staging.dart --flavor staging

# Producción
flutter run -t lib/flavors/main_prod.dart --flavor prod
```

#### Construir APK:
```bash
# Desarrollo
flutter build apk -t lib/flavors/main_dev.dart --flavor dev

# Staging
flutter build apk -t lib/flavors/main_staging.dart --flavor staging

# Producción
flutter build apk -t lib/flavors/main_prod.dart --flavor prod
```

## ⚙️ Configuración por Entorno

### Desarrollo (Dev)
- **App Name**: Cocinando IA Dev
- **Bundle ID**: com.ngonzano.comidaperuana.dev
- **API URL**: https://dev-api.comidaperuana.com
- **Logging**: Habilitado
- **Suffix**: .dev

### Staging
- **App Name**: CocinandoIA Staging
- **Bundle ID**: com.ngonzano.comidaperuana.staging
- **API URL**: https://staging-api.comidaperuana.com
- **Logging**: Habilitado
- **Suffix**: .staging

### Producción (Prod)
- **App Name**: CocinandoIA
- **Bundle ID**: com.ngonzano.comidaperuana
- **API URL**: https://api.comidaperuana.com
- **Logging**: Deshabilitado
- **Suffix**: Sin suffix

## 🔧 Uso en el Código

### Acceder a la configuración del flavor:
```dart
import 'package:comidaperuana/flavors/flavor_config.dart';

// Obtener la configuración actual
final config = FlavorConfig.instance;

// Verificar el entorno
if (FlavorConfig.isDevelopment()) {
  print('Ejecutando en desarrollo');
}

// Usar valores específicos del flavor
final apiUrl = config.apiBaseUrl;
final appName = config.appName;
```

### Ejemplo de uso en servicios:
```dart
class ApiService {
  final String baseUrl = FlavorConfig.instance.apiBaseUrl;
  
  Future<void> makeRequest() async {
    if (FlavorConfig.isDevelopment()) {
      print('Haciendo request a: $baseUrl');
    }
    // ... lógica de la API
  }
}
```

## 📱 Configuración de Android

El archivo `android/app/build.gradle.kts` está configurado con:

- **Product Flavors**: dev, staging, prod
- **Application ID Suffix**: .dev, .staging, (sin suffix para prod)
- **Version Name Suffix**: -dev, -staging, (sin suffix para prod)
- **App Names**: Diferentes nombres para cada flavor

### Archivos de recursos:
- `android/app/src/main/res/values/strings.xml` - Nombre para producción
- `android/app/src/dev/res/values/strings.xml` - Nombre para desarrollo
- `android/app/src/staging/res/values/strings.xml` - Nombre para staging

## 🚨 Notas Importantes

1. **Nunca** subir código de desarrollo a producción
2. **Siempre** verificar el flavor antes de hacer builds de release
3. **Usar** `FlavorConfig.isProduction()` para lógica crítica
4. **Configurar** diferentes Firebase projects para cada entorno
5. **Verificar** que las API keys sean diferentes por entorno

## 🔍 Troubleshooting

### Error: "FlavorConfig no ha sido inicializado"
- Asegúrate de que estés ejecutando desde el archivo main correcto
- Verifica que la importación sea correcta

### Error: "Flavor not found"
- Verifica que el flavor esté definido en `flavor_config.dart`
- Asegúrate de que el comando flutter run incluya el parámetro `--flavor`

### Build falla en Android
- Ejecuta `flutter clean`
- Verifica que el flavor esté definido en `build.gradle.kts`
- Asegúrate de que no haya conflictos de nombres

## 📝 Nota sobre iOS

**La configuración de iOS no está incluida en esta implementación.** Si necesitas configurar iOS en el futuro, necesitarás:

1. Configurar schemes en Xcode
2. Crear archivos .xcconfig
3. Configurar targets específicos
4. Configurar bundle identifiers por flavor
5. Guia: https://www.youtube.com/watch?v=EyQfuKvVUGY

## 🛠️ Script de Ejecución

Usa el script `scripts/run_flavors.sh` para facilitar la ejecución:

```bash
# Ejecutar flavors
./scripts/run_flavors.sh dev
./scripts/run_flavors.sh staging
./scripts/run_flavors.sh prod

# Construir APKs
./scripts/run_flavors.sh build-dev
./scripts/run_flavors.sh build-staging
./scripts/run_flavors.sh build-prod
```
