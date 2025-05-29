import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';

class AppGeminiChat extends StatefulWidget {
  const AppGeminiChat({super.key});

  @override
  State<AppGeminiChat> createState() => _AppGeminiChatState();
}

class _AppGeminiChatState extends State<AppGeminiChat> {
  late GenerativeModel model;
  @override
  void initState() {
    super.initState();
    model = init();
  }

  GenerativeModel init() {
    return FirebaseAI.googleAI(
      appCheck: FirebaseAppCheck.instance,
    ).generativeModel(model: 'gemini-2.0-flash');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final chat = model.startChat();
        final prompt = Content.text('escribe un cuento de caperucita roja.');

        final response = chat.sendMessageStream(prompt);
        await for (final chunk in response) {
          log(chunk.text!);
        }
      },
      child: const Text('gemini-2.0-flash - chat'),
    );
  }
}
