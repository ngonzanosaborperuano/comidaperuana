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
123654flutterfire configure

//

============================================
adb shell 'am start -a android.intent.action.VIEW \
 -c android.intent.category.BROWSABLE \
 -d "https://ricope-e01a994cf2ab.herokuapp.com/home"' \
 com.ngonzano.comidaperuana

//

============================================
Error al levantar en un emulador de android
============================================
flutter clean
rm -rf ~/.dartServer/
rm -rf ~/.pub-cache
flutter pub get
