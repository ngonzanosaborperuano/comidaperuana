import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3600),
        minimumFetchInterval: const Duration(seconds: 3600),
      ),
    );

    _remoteConfig.setDefaults(const {
      "model_name": "gemini-2.0-flash",
      "system_instructions":
          "¡Eres un asistente útil que sabe todo lo que hay que saber sobre recetas de comida!",
      "prompt": "",
      "vertex_location": "us-central1", // Región para Vertex AI (requiere facturación)
      "use_vertex_ai": "false", // Cambiar a "true" cuando se habilite facturación
    });

    await _remoteConfig.fetchAndActivate();

    _remoteConfig.onConfigUpdated.listen((event) async {
      await _remoteConfig.activate();
    });
  }

  String getString(String key) => _remoteConfig.getString(key);
}
