import 'package:flutter/material.dart';
import 'package:goncook/src/infrastructure/shared/services/gemini_ai_service.dart';
import 'package:goncook/src/infrastructure/shared/services/remote_config_service.dart';

class AppGeminiTextToTextButton extends StatelessWidget {
  const AppGeminiTextToTextButton({super.key, required this.prompt, this.onResult});
  final String prompt;
  final void Function(String text)? onResult;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final configService = RemoteConfigService();
        await configService.initialize();

        final aiService = GeminiAIService(configService);
        final result = await aiService.generateTextToText(prompt: prompt);
        onResult!(result);
      },
      child: const Text('gemini-2.0-flash - json'),
    );
  }
}
