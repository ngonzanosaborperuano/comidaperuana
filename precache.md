# Comandos recomendados tras cambiar de SDK con FVM

## IOS

```bash
# 1. Descarga los artefactos necesarios para iOS
fvm flutter precache --ios

# 2. Limpia el proyecto Flutter (opcional pero recomendado)
fvm flutter clean

# 3. Ve a la carpeta ios y limpia los pods
cd ios
pod deintegrate
pod install
cd ..

# 4. Corre tu app normalmente
fvm flutter run
```

## Android

# 1. Descarga los artefactos necesarios para Android

fvm flutter precache --android

# 2. Limpia el proyecto Flutter (opcional pero recomendado)

fvm flutter clean

# 3. Elimina la carpeta build de Android (opcional, pero ayuda a evitar conflictos)

rm -rf android/build

# 4. Corre tu app normalmente

fvm flutter run
