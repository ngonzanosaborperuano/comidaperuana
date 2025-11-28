# 📋 Guía Paso a Paso: Configurar Flavors en Info.plist

## 🎯 Objetivo
Configurar las variables `GOOGLE_CLIENT_ID` y `GOOGLE_REVERSED_CLIENT_ID` en Build Settings para que Xcode las resuelva automáticamente según el flavor.

---

## 📝 Paso 1: Abrir el Proyecto en Xcode

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

## 📝 Paso 2: Seleccionar el Target

1. En el **navegador de proyectos** (panel izquierdo), haz clic en el proyecto **"Runner"** (el icono azul en la parte superior)

2. En el panel central, verás **"TARGETS"** → selecciona **"Runner"** (NO "RunnerTests")

3. Verás varias pestañas: **General**, **Signing & Capabilities**, **Resource Tags**, **Info**, **Build Settings**, **Build Phases**, **Build Rules**

4. Haz clic en la pestaña **"Build Settings"**

---

## 📝 Paso 3: Mostrar User-Defined Settings

1. En la parte superior de Build Settings, verás una barra de búsqueda

2. Escribe: **"User-Defined"** o busca el botón **"+"** en la parte superior izquierda

3. Si ya hay User-Defined Settings, verás una sección expandible con ese nombre

4. Si no hay ninguna, haz clic en el botón **"+"** → **"Add User-Defined Setting"**

---

## 📝 Paso 4: Agregar Variable GOOGLE_CLIENT_ID

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

## 📝 Paso 5: Agregar Variable GOOGLE_REVERSED_CLIENT_ID

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

## 📝 Paso 6: Verificar la Configuración

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

---

## 📝 Paso 7: (Opcional) Desactivar el Script

Si ya configuraste Build Settings, puedes desactivar el script `copy_firebase_config.sh`:

1. Ve a la pestaña **"Build Phases"**
2. Busca **"Copy Firebase Config"** en la lista
3. **Desmarca la casilla** a la izquierda del nombre (esto lo desactiva sin eliminarlo)

O si prefieres eliminarlo completamente:
1. Selecciona **"Copy Firebase Config"**
2. Presiona **Delete** o haz clic derecho → **Delete**

---

## ✅ Paso 8: Probar la Configuración

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

Una vez configurado, Xcode resolverá automáticamente las variables `$(GOOGLE_CLIENT_ID)` y `$(GOOGLE_REVERSED_CLIENT_ID)` en el Info.plist según el flavor que estés compilando.

🎉 **¡Ya está todo configurado!**

