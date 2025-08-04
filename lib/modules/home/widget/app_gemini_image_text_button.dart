import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:recetasperuanas/core/services/gemini_ai_service.dart';
import 'package:recetasperuanas/core/services/remote_config_service.dart';

class AppGeminiImageTextButton extends StatefulWidget {
  const AppGeminiImageTextButton({
    super.key,
    this.onResult,
    required this.isCamera,
  });

  final void Function(String text)? onResult;
  final bool isCamera;

  @override
  State<AppGeminiImageTextButton> createState() =>
      _AppGeminiImageTextButtonState();
}

class _AppGeminiImageTextButtonState extends State<AppGeminiImageTextButton> {
  // ejemplo con strem
  // Stream<String> runFeatureFlagFlow({required InlineDataPart imagePart}) async* {
  //   final configService = RemoteConfigService();
  //   await configService.initialize();

  //   final aiService = GeminiAIService(configService);

  //   await for (final textChunk in aiService.generateImageTextStream(imagePart: imagePart)) {
  //     yield textChunk;
  //   }
  // }

  Future<String> runFeatureFlagFlow({required InlineDataPart imagePart}) async {
    final configService = RemoteConfigService();
    await configService.initialize();

    final aiService = GeminiAIService(configService);
    return await aiService.generateImageText(imagePart: imagePart);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: widget.isCamera ? ImageSource.camera : ImageSource.gallery,
        );

        if (pickedFile == null) return;

        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();

        final mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';

        final imagePart = InlineDataPart(mimeType, bytes);
        final response = await runFeatureFlagFlow(imagePart: imagePart);

        widget.onResult!(response);

        // final stream = runFeatureFlagFlow(imagePart: imagePart);
        // await for (final chunk in stream) {
        //   widget.onResult!(chunk);
        // }

        await file.delete();
      },
      child: const Text('gemini-2.0-flash - image a text'),
    );
  }
}
