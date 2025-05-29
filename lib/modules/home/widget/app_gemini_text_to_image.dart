import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/services/gemini_ai_service.dart';
import 'package:recetasperuanas/core/services/remote_config_service.dart';

class AppGeminiTextToImage extends StatelessWidget {
  const AppGeminiTextToImage({super.key, this.onResult, required this.namePlato});

  final void Function(Uint8List img)? onResult;

  final String namePlato;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final configService = RemoteConfigService();
        await configService.initialize();

        final aiService = GeminiAIService(configService);

        final image = await aiService.generateTextToImage(prompt: namePlato);

        if (image != null) {
          onResult!(image);
        } else {
          log('Error: No images were generated.');
        }
      },
      child: const Text('gemini-2.0-flash - text a imagen'),
    );
  }
}

class AppGeminiTextToMoreImage extends StatelessWidget {
  const AppGeminiTextToMoreImage({super.key, required this.namePlato, this.onResultList});

  final void Function(List<Uint8List?> img)? onResultList;
  final String namePlato;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final configService = RemoteConfigService();
        await configService.initialize();

        final aiService = GeminiAIService(configService);

        final images = await aiService.generateTextToMoreImage(prompt: namePlato);

        onResultList!(images);
      },
      child: const Text('gemini-2.0-flash - text a imagenes'),
    );
  }
}
