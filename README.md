============================================
cambios automaticos en el modelo
============================================
flutter pub run build_runner watch
//
============================================
generar internacionalizacion
============================================
flutter gen-l10n
//
============================================
Para SHA1
============================================
-- Windows
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

         SHA1: 5F:B0:1E:C5:AF:12:02:D7:FC:93:2D:D1:72:B2:EE:11:11:FD:1D:97
         SHA256: D9:24:85:FA:28:AC:7C:E9:0B:52:CC:F4:BB:FB:19:DC:4C:E8:55:61:4F:5D:FB:3F:AE:26:BD:4A:DD:6A:E1:94

-- Mac
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

SHA1: BA:7E:05:56:08:0E:54:B9:26:FB:5E:8A:AF:53:54:47:AB:58:88:92
SHA256: 87:33:FE:FD:B2:82:B2:96:B1:B4:48:B7:F4:2A:90:11:61:C6:AC:E0:E2:12:5C:36:AD:CA:42:F8:A2:77:4A:4B

-- Facebook

keytool -exportcert -alias androiddebugkey -keystore BA:7E:05:56:08:0E:54:B9:26:FB:5E:8A:AF:53:54:47:AB:58:88:92 | openssl sha1 -binary | openssl base64
//
============================================
iniciar firebase
============================================
npm install -g firebase-tools
firebase login

nota: si ya existe un usuario solo con
firebase logout
sales y vuelves a logear

instalar
dart pub global activate flutterfire_cli

actualizar si es que fuera necesario
dart pub global activate flutterfire_cli --overwrite

Agrega Firebase a tu proyecto
123654
flutterfire configure

# //

# DeepLink probar en un emulador
https://docs.flutter.dev/cookbook/navigation/set-up-app-links
sirve para cuando estas en un emulador y quieres abrir el app desde un deeplink

adb shell 'am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://cocinando.shop/home"' \
 com.ngonzano.comidaperuana

//

# Deeplink revisar

https://flutterexperts.com/flutter-deep-links-a-unique-way/

//

============================================
App Check
============================================
https://hasankarli.medium.com/flutter-firebase-app-check-21355c9ad349

token ios
https://firebase.google.com/docs/app-check/flutter/debug-provider?hl=es-419&authuser=0

============================================
Kafka
============================================

============================================
limpiar warning
============================================
agregar en analysis_options.yaml


include: package:flutter_lints/flutter.yaml

linter:
rules:
prefer_const_constructors: true
prefer_const_literals_to_create_immutables: true
prefer_const_declarations: true

luego: fvm dart fix --apply

//
============================================
DISEÑO de la app
============================================
https://gj4vf7-5173.csb.app/

============================================
GEMINI CLI

npm install -g @google/gemini-cli
gemini


============================================
DynaTrace
============================================
usuario: niltongr@outlook.com
pass: ArCV2GwDFdrFRgC
dart run dynatrace_flutter_plugin

============================================
Tus códigos de verificación alternativos - Google cuenta
============================================
7137 8803
0928 7881
7773 8139
7840 3480
7075 4901
8993 1174
8887 1549
6194 4393
5301 3514
1897 7839

Flavors
https://www.youtube.com/watch?v=EyQfuKvVUGY&t=661s