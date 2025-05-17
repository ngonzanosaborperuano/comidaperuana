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
ejecutar en powershell
============================================
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

         SHA1: 5F:B0:1E:C5:AF:12:02:D7:FC:93:2D:D1:72:B2:EE:11:11:FD:1D:97
         SHA256: D9:24:85:FA:28:AC:7C:E9:0B:52:CC:F4:BB:FB:19:DC:4C:E8:55:61:4F:5D:FB:3F:AE:26:BD:4A:DD:6A:E1:94
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
