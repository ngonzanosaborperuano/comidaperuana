# 📋 Guía Paso a Paso: Configurar Flavors en iOS con Firebase

## 🎯 Objetivo
Configurar múltiples ambientes (dev / staging / prod) en iOS usando flavors con Firebase, incluyendo la gestión automática de archivos `GoogleService-Info.plist` mediante scripts de build.

---

## 📁 Parte A: Configuración de Archivos Firebase

### 📝 Paso 1: Estructura de Carpetas Firebase

Primero, asegúrate de tener la siguiente estructura de carpetas en tu proyecto iOS:

```
ios/
└── Runner/
    └── Firebase/
        ├── dev/
        │   └── GoogleService-Info-dev.plist
        ├── staging/
        │   └── GoogleService-Info-staging.plist
        └── prod/
            └── GoogleService-Info.plist
```

**Estructura completa:**
```
Runner/
 ├── Firebase/
 │    ├── dev/GoogleService-Info-dev.plist
 │    ├── prod/GoogleService-Info.plist
 │    └── staging/GoogleService-Info-staging.plist
```

---

### ⚠️ Paso 2: Configurar Target Membership (CRÍTICO)

❗ **IMPORTANTE**: NINGÚN plist debe estar en Target Membership (Runner).

Xcode NO debe copiar directamente los plist. El script que añadiremos lo hará automáticamente.

**Para cada archivo plist:**

1. **GoogleService-Info-dev.plist**
2. **GoogleService-Info-staging.plist**
3. **GoogleService-Info.plist** (prod)

**Pasos para desactivar Target Membership:**

1. Selecciona cada archivo `.plist` en el navegador de proyectos de Xcode
2. Abre el **File Inspector** (panel derecho, icono de documento)
3. En la sección **"Target Membership"**, **desmarca "Runner"**
4. Repite este proceso para los 3 archivos plist

✅ **Resultado esperado**: Ningún plist debe tener "Runner" marcado en Target Membership.

---

### 📝 Paso 3: Crear Build Configurations

Antes de agregar el script, necesitas tener las Build Configurations creadas:

1. En Xcode, selecciona el proyecto **"Runner"** (icono azul)
2. Ve a la pestaña **"Info"**
3. En la sección **"Configurations"**, verifica que existan:
   - **Debug-dev**
   - **Debug-staging**
   - **Debug-prod**
   - **Release-dev**
   - **Release-staging**
   - **Release-prod**

Si no existen, créalas duplicando las configuraciones base (Debug/Release) y renombrándolas.

---

### 📝 Paso 4: Crear Schemes por Ambiente

1. En la barra superior de Xcode, haz clic en el esquema actual (junto al botón de Play)
2. Selecciona **"Manage Schemes..."**
3. Crea o verifica que existan los siguientes schemes:
   - **dev** (usando Debug-dev / Release-dev)
   - **staging** (usando Debug-staging / Release-staging)
   - **prod** (usando Debug-prod / Release-prod)

---

### 📝 Paso 5: Agregar Script de Copia de Firebase Config

Este script copiará automáticamente el archivo plist correcto según la configuración de build.

1. En Xcode, selecciona el proyecto **"Runner"**
2. Selecciona el target **"Runner"**
3. Ve a la pestaña **"Build Phases"**
4. Haz clic en el botón **"+"** en la parte superior izquierda
5. Selecciona **"New Run Script Phase"**
6. Arrastra el nuevo script para que esté **ANTES** de "Copy Bundle Resources"
7. Expande el script y renómbralo a: **"Copy Firebase Config"**

8. En el campo de script, pega el siguiente código:

```bash
# Paths
SRC_DIR="${PROJECT_DIR}/Runner/Firebase"
DEST_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"

echo "Configuration: ${CONFIGURATION}"

if [[ "${CONFIGURATION}" == *"dev"* ]]; then
    cp "${SRC_DIR}/dev/GoogleService-Info-dev.plist" "${DEST_DIR}/GoogleService-Info.plist"
    echo "Using DEV GoogleService-Info"
elif [[ "${CONFIGURATION}" == *"staging"* ]]; then
    cp "${SRC_DIR}/staging/GoogleService-Info-staging.plist" "${DEST_DIR}/GoogleService-Info.plist"
    echo "Using STAGING GoogleService-Info"
else
    cp "${SRC_DIR}/prod/GoogleService-Info.plist" "${DEST_DIR}/GoogleService-Info.plist"
    echo "Using PROD GoogleService-Info"
fi
```

9. **Guarda el proyecto**: `Cmd + S`

---

### 📝 Paso 6: Configurar Podfile (OBLIGATORIO)

Esta configuración es **necesaria** para que CocoaPods reconozca y maneje correctamente las Build Configurations personalizadas.

**¿Por qué es necesaria?**

1. CocoaPods necesita saber cómo tratar cada Build Configuration personalizada
2. Sin esto, CocoaPods podría no generar correctamente los archivos `.xcconfig` para cada flavor
3. Es especialmente importante para pods que tienen configuraciones diferentes entre debug y release (como Firebase)

**Configuración requerida:**

Abre el archivo `ios/Podfile` y asegúrate de tener esta configuración:

```ruby
project 'Runner', {
  'Debug-dev' => :debug,
  'Debug-staging' => :debug,
  'Debug-prod' => :debug,
  'Release-dev' => :release,
  'Release-staging' => :release,
  'Release-prod' => :release,
}
```

**Pasos:**

1. Abre `ios/Podfile` en tu editor
2. Verifica que la sección `project 'Runner'` tenga el mapeo de configuraciones como se muestra arriba
3. Si no está presente, agrégalo después de la línea `platform :ios, '15.0'`
4. Guarda el archivo
5. Ejecuta en Terminal:
   ```bash
   cd ios
   pod install
   ```

**Verificación:**

Después de ejecutar `pod install`, verifica que CocoaPods haya generado los archivos `.xcconfig` para cada configuración. Deberías ver en `ios/Pods/Target Support Files/Pods-Runner/`:

- `Pods-Runner.debug-dev.xcconfig`
- `Pods-Runner.debug-staging.xcconfig`
- `Pods-Runner.debug-prod.xcconfig`
- `Pods-Runner.release-dev.xcconfig`
- `Pods-Runner.release-staging.xcconfig`
- `Pods-Runner.release-prod.xcconfig`

⚠️ **Importante**: Sin esta configuración, los flavors podrían no funcionar correctamente con dependencias nativas de CocoaPods.

---

## 📁 Parte B: Configuración de Build Settings (Variables)

### 📝 Paso 7: Abrir el Proyecto en Xcode

1. Abre **Terminal** y navega a tu proyecto:
   ```bash
   cd /Users/niltongonzano/RicoPE/comidaperuana
   ```

2. Abre el workspace de Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
   
   ⚠️ **IMPORTANTE**: Abre el `.xcworkspace`, NO el `.xcodeproj`

---

### 📝 Paso 8: Seleccionar el Target

1. En el **navegador de proyectos** (panel izquierdo), haz clic en el proyecto **"Runner"** (el icono azul en la parte superior)

2. En el panel central, verás **"TARGETS"** → selecciona **"Runner"** (NO "RunnerTests")

3. Verás varias pestañas: **General**, **Signing & Capabilities**, **Resource Tags**, **Info**, **Build Settings**, **Build Phases**, **Build Rules**

4. Haz clic en la pestaña **"Build Settings"**

---

### 📝 Paso 9: Mostrar User-Defined Settings

1. En la parte superior de Build Settings, verás una barra de búsqueda

2. Escribe: **"User-Defined"** o busca el botón **"+"** en la parte superior izquierda

3. Si ya hay User-Defined Settings, verás una sección expandible con ese nombre

4. Si no hay ninguna, haz clic en el botón **"+"** → **"Add User-Defined Setting"**

---

### 📝 Paso 10: Agregar Variable GOOGLE_CLIENT_ID

### 4.1 Crear la Variable

1. Haz clic en el botón **"+"** (arriba a la izquierda de Build Settings)
2. Selecciona **"Add User-Defined Setting"**
3. En el campo que aparece, escribe: **`GOOGLE_CLIENT_ID`**
4. Presiona **Enter**

### 4.2 Configurar Valores por Flavor

Ahora verás una fila con `GOOGLE_CLIENT_ID` y varias columnas para cada configuración.

**Para cada configuración, haz doble clic en la celda y agrega el valor:**

#### Debug-dev:
- Haz doble clic en la celda debajo de **"Debug-dev"**
- Pega este valor:
  ```
  86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc.apps.googleusercontent.com
  ```
- Presiona **Enter**

#### Debug-staging:
- Haz doble clic en la celda debajo de **"Debug-staging"**
- Pega este valor:
  ```
  86173141894-93kpb6i3nes2o4nra6dst948356sq8s1.apps.googleusercontent.com
  ```
- Presiona **Enter**

#### Debug-prod:
- Haz doble clic en la celda debajo de **"Debug-prod"**
- Pega este valor:
  ```
  86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru.apps.googleusercontent.com
  ```
- Presiona **Enter**

#### Release-dev:
- Haz doble clic en la celda debajo de **"Release-dev"**
- Pega el mismo valor que Debug-dev:
  ```
  86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc.apps.googleusercontent.com
  ```
- Presiona **Enter**

#### Release-staging:
- Haz doble clic en la celda debajo de **"Release-staging"**
- Pega el mismo valor que Debug-staging:
  ```
  86173141894-93kpb6i3nes2o4nra6dst948356sq8s1.apps.googleusercontent.com
  ```
- Presiona **Enter**

#### Release-prod:
- Haz doble clic en la celda debajo de **"Release-prod"**
- Pega el mismo valor que Debug-prod:
  ```
  86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru.apps.googleusercontent.com
  ```
- Presiona **Enter**

---

### 📝 Paso 11: Agregar Variable GOOGLE_REVERSED_CLIENT_ID

### 5.1 Crear la Variable

1. Haz clic en el botón **"+"** nuevamente
2. Selecciona **"Add User-Defined Setting"**
3. Escribe: **`GOOGLE_REVERSED_CLIENT_ID`**
4. Presiona **Enter**

### 5.2 Configurar Valores por Flavor

**Para cada configuración, haz doble clic en la celda y agrega el valor:**

#### Debug-dev:
```
com.googleusercontent.apps.86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc
```

#### Debug-staging:
```
com.googleusercontent.apps.86173141894-93kpb6i3nes2o4nra6dst948356sq8s1
```

#### Debug-prod:
```
com.googleusercontent.apps.86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru
```

#### Release-dev:
```
com.googleusercontent.apps.86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc
```

#### Release-staging:
```
com.googleusercontent.apps.86173141894-93kpb6i3nes2o4nra6dst948356sq8s1
```

#### Release-prod:
```
com.googleusercontent.apps.86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru
```

---

### 📝 Paso 12: Verificar la Configuración

1. Deberías ver algo así en Build Settings:

```
User-Defined Settings:
├── GOOGLE_CLIENT_ID
│   ├── Debug-dev: 86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc.apps.googleusercontent.com
│   ├── Debug-staging: 86173141894-93kpb6i3nes2o4nra6dst948356sq8s1.apps.googleusercontent.com
│   ├── Debug-prod: 86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru.apps.googleusercontent.com
│   ├── Release-dev: 86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc.apps.googleusercontent.com
│   ├── Release-staging: 86173141894-93kpb6i3nes2o4nra6dst948356sq8s1.apps.googleusercontent.com
│   └── Release-prod: 86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru.apps.googleusercontent.com
│
└── GOOGLE_REVERSED_CLIENT_ID
    ├── Debug-dev: com.googleusercontent.apps.86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc
    ├── Debug-staging: com.googleusercontent.apps.86173141894-93kpb6i3nes2o4nra6dst948356sq8s1
    ├── Debug-prod: com.googleusercontent.apps.86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru
    ├── Release-dev: com.googleusercontent.apps.86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc
    ├── Release-staging: com.googleusercontent.apps.86173141894-93kpb6i3nes2o4nra6dst948356sq8s1
    └── Release-prod: com.googleusercontent.apps.86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru
```

2. **Guarda el proyecto**: `Cmd + S` o `File > Save`

3. **Verifica que el script "Copy Firebase Config" esté activo**:
   - Ve a la pestaña **"Build Phases"**
   - Verifica que **"Copy Firebase Config"** esté marcado (casilla activada)
   - El script debe estar **ANTES** de "Copy Bundle Resources"

---

## ✅ Paso 13: Probar la Configuración

1. **Limpia el build**: `Product > Clean Build Folder` (⇧⌘K)

2. **Selecciona un flavor** en el esquema (ej: "Debug-dev")

3. **Compila**: `Product > Build` (⌘B)

4. **Verifica que no hay errores** relacionados con `GOOGLE_CLIENT_ID` o `GOOGLE_REVERSED_CLIENT_ID`

5. **Prueba Google Sign In** en la app

---

## 🐛 Troubleshooting

### ❌ No veo las configuraciones Debug-dev, Debug-staging, etc.

**Solución:**
1. En la parte superior de Build Settings, verás un menú desplegable que dice algo como "Any iOS SDK"
2. Haz clic en él y selecciona **"All"** o **"Combined"**
3. Ahora deberías ver todas las configuraciones

### ❌ Las variables no se resuelven en Info.plist

**Solución:**
1. Verifica que escribiste exactamente: `GOOGLE_CLIENT_ID` y `GOOGLE_REVERSED_CLIENT_ID` (sin espacios, mayúsculas correctas)
2. Verifica que el Info.plist tiene: `$(GOOGLE_CLIENT_ID)` y `$(GOOGLE_REVERSED_CLIENT_ID)`
3. Limpia el build: `Product > Clean Build Folder`
4. Recompila

### ❌ No encuentro "User-Defined Settings"

**Solución:**
1. En Build Settings, haz clic en el botón **"+"** en la parte superior izquierda
2. Selecciona **"Add User-Defined Setting"**
3. Esto creará la sección automáticamente

### ❌ El archivo GoogleService-Info.plist no se copia correctamente

**Solución:**
1. Verifica que los archivos plist **NO** tengan Target Membership activado:
   - Selecciona cada plist en el navegador de proyectos
   - Abre File Inspector (panel derecho)
   - Desmarca "Runner" en Target Membership
2. Verifica que el script "Copy Firebase Config" esté activo en Build Phases
3. Verifica que el script esté **ANTES** de "Copy Bundle Resources"
4. Verifica que la estructura de carpetas sea correcta:
   ```
   Runner/Firebase/dev/GoogleService-Info-dev.plist
   Runner/Firebase/staging/GoogleService-Info-staging.plist
   Runner/Firebase/prod/GoogleService-Info.plist
   ```
5. Limpia el build: `Product > Clean Build Folder` (⇧⌘K)
6. Recompila y verifica los logs del script en la consola de Xcode

### ❌ Error: "GoogleService-Info.plist not found"

**Solución:**
1. Verifica que el script "Copy Firebase Config" esté ejecutándose antes de "Copy Bundle Resources"
2. Verifica que los paths en el script sean correctos:
   - `SRC_DIR` debe apuntar a `Runner/Firebase`
   - Los nombres de archivo deben coincidir exactamente
3. Verifica que las Build Configurations tengan los nombres correctos (dev, staging, prod)

---

## 📋 Resumen de Valores

### Dev (Debug-dev y Release-dev)
- **GOOGLE_CLIENT_ID**: `86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc.apps.googleusercontent.com`
- **GOOGLE_REVERSED_CLIENT_ID**: `com.googleusercontent.apps.86173141894-0rlohjc2q0d49dha0b2p9q0rbjlkd3fc`

### Staging (Debug-staging y Release-staging)
- **GOOGLE_CLIENT_ID**: `86173141894-93kpb6i3nes2o4nra6dst948356sq8s1.apps.googleusercontent.com`
- **GOOGLE_REVERSED_CLIENT_ID**: `com.googleusercontent.apps.86173141894-93kpb6i3nes2o4nra6dst948356sq8s1`

### Prod (Debug-prod y Release-prod)
- **GOOGLE_CLIENT_ID**: `86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru.apps.googleusercontent.com`
- **GOOGLE_REVERSED_CLIENT_ID**: `com.googleusercontent.apps.86173141894-mbloi0319dgj0pscqetnukgab9tvc4ru`

---

## ✅ Listo!

Una vez configurado:

1. **El script "Copy Firebase Config"** copiará automáticamente el archivo `GoogleService-Info.plist` correcto según la configuración de build (dev/staging/prod)
2. **Xcode resolverá automáticamente** las variables `$(GOOGLE_CLIENT_ID)` y `$(GOOGLE_REVERSED_CLIENT_ID)` en el Info.plist según el flavor que estés compilando

### 📋 Checklist Final

- [ ] Estructura de carpetas Firebase creada correctamente
- [ ] Todos los archivos plist **SIN** Target Membership activado
- [ ] Build Configurations creadas (Debug-dev, Debug-staging, Debug-prod, Release-dev, Release-staging, Release-prod)
- [ ] Schemes creados por ambiente (dev, staging, prod)
- [ ] Script "Copy Firebase Config" agregado y activo en Build Phases
- [ ] **Podfile configurado** con mapeo de Build Configurations (Paso 6)
- [ ] `pod install` ejecutado y archivos `.xcconfig` generados correctamente
- [ ] Variables `GOOGLE_CLIENT_ID` y `GOOGLE_REVERSED_CLIENT_ID` configuradas en Build Settings
- [ ] Build limpio y compilación exitosa

🎉 **¡Ya está todo configurado!**

