import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  final logger = Logger('permission');

  final statuses =
      await [
        Permission.microphone,
        Permission.speech,
        Permission.camera,
        Permission.photos,
      ].request();

  statuses.forEach((permission, status) {
    logger.warning('Permiso $permission: ${status.isGranted ? "Concedido" : "Denegado"}');
  });
}
