import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:recetasperuanas/core/services/remote_config_service.dart';

class GeminiAIService {
  GeminiAIService(this._configService);
  final safetySettings = [
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high, null),
  ];
  final imagenSafetySettings = ImagenSafetySettings(
    ImagenSafetyFilterLevel.blockLowAndAbove,
    ImagenPersonFilterLevel.allowAdult,
  );
  final RemoteConfigService _configService;
  final jsonSchema = Schema.object(
    description: 'Schema para una receta de cocina detallada.',
    properties: {
      'NombrePlato': Schema.string(description: 'Nombre del plato de comida.'),
      'IngredientesUtilizados': Schema.string(
        description: 'Lista de ingredientes necesarios, idealmente con cantidades.',
      ),
      'AlternativasIngredientes': Schema.string(
        description: 'Sugerencias para reemplazar ingredientes si alguno no está disponible.',
      ),
      'Preparacion': Schema.object(
        description: 'Detalles sobre la preparación del plato.',
        properties: {
          'TiempoEstimado': Schema.string(
            description:
                'Tiempo total estimado para la preparación y cocción (ej. "45 minutos") concidera que se cocina de casa.',
          ),
          'Pasos': Schema.string(
            description:
                'Pasos detallados de la preparación, preferiblemente numerados o en una lista clara.',
          ),
        },
      ),
      'Recomendaciones': Schema.string(
        description:
            'Consejos, trucos o tips adicionales para mejorar la receta o la presentación.',
      ),
      'Origen': Schema.string(
        description: 'Breve descripción del origen geográfico o cultural del plato.',
      ),
      'Error': Schema.string(
        description:
            'Mensaje de error si la solicitud no se puede procesar como una receta o si falta información crucial.',
      ),
    },
    propertyOrdering: [
      'NombrePlato',
      'IngredientesUtilizados',
      'Preparacion',
      'AlternativasIngredientes',
      'Recomendaciones',
      'Origen',
    ],
    optionalProperties: ['Error'],
  );

  Stream<String> generateAudioTextStream({required InlineDataPart audioPart}) async* {
    final modelName = _configService.getString("model_name");
    final systemInstructions = _configService.getString("system_instructions");
    final promptText = _configService.getString("prompt_audio_text");

    if (modelName.isEmpty || systemInstructions.isEmpty) {
      log("❌ Faltan valores en Remote Config.");
      yield "";
      return;
    }

    final ai = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance);
    final model = ai.generativeModel(
      model: modelName,
      systemInstruction: Content.system(systemInstructions),
      generationConfig: GenerationConfig(
        // maxOutputTokens: 256,
        temperature: 0.5,
        topP: 0.9,
        topK: 40,
      ),
    );

    final stream = model.generateContentStream([
      Content.multi([TextPart(promptText), audioPart]),
    ]);

    await for (final chunk in stream) {
      final text = chunk.text;
      if (text != null && text.trim().isNotEmpty) {
        yield text;
      }
    }
  }

  Future<String> generateAudioText({required InlineDataPart audioPart}) async {
    final modelName = _configService.getString("model_name");
    final systemInstructions = _configService.getString("system_instructions");
    final promptText = _configService.getString("prompt_audio_text");

    if (modelName.isEmpty || systemInstructions.isEmpty) {
      log("❌ Faltan valores en Remote Config.");

      return "";
    }

    final ai = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance);
    final model = ai.generativeModel(
      model: modelName,
      systemInstruction: Content.system(systemInstructions),
      safetySettings: safetySettings,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: jsonSchema,
        temperature: 0.5,
        topP: 0.9,
        topK: 40,
      ),
    );

    final response = await model.generateContent([
      Content.multi([TextPart(promptText), audioPart]),
    ]);

    return response.text ?? "";
  }

  Stream<String> generateImageTextStream({required InlineDataPart imagePart}) async* {
    final modelName = _configService.getString("model_name");
    final systemInstructions = _configService.getString("system_instructions");
    final promptText = _configService.getString("prompt_image_text");

    if (modelName.isEmpty || systemInstructions.isEmpty) {
      log("❌ Faltan valores en Remote Config.");
      yield "";
      return;
    }

    final ai = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance);
    final model = ai.generativeModel(
      model: modelName,
      safetySettings: safetySettings,
      systemInstruction: Content.system(systemInstructions),
      generationConfig: GenerationConfig(
        responseMimeType: 'text/plain',
        temperature: 0.5,
        topP: 0.9,
        topK: 40,
      ),
    );

    final stream = model.generateContentStream([
      Content.multi([TextPart(promptText), imagePart]),
    ]);

    await for (final chunk in stream) {
      final text = chunk.text;
      if (text != null && text.trim().isNotEmpty) {
        yield text;
      }
    }
  }

  Future<String> generateImageText({required InlineDataPart imagePart}) async {
    final modelName = _configService.getString("model_name");
    final systemInstructions = _configService.getString("system_instructions");
    final promptText = _configService.getString("prompt_image_text");

    if (modelName.isEmpty || systemInstructions.isEmpty) {
      log("❌ Faltan valores en Remote Config.");
      return "";
    }

    final model = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance).generativeModel(
      model: modelName,
      systemInstruction: Content.system(systemInstructions),
      safetySettings: safetySettings,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: jsonSchema,
        temperature: 0.5,
        topP: 0.9,
        topK: 40,
      ),
    );
    final response = await model.generateContent([
      Content.multi([TextPart(promptText), imagePart]),
    ]);

    return response.text ?? "";
  }

  Future<String> generateTextToText({required String prompt}) async {
    final modelName = _configService.getString("model_name");
    final systemInstructions = _configService.getString("system_instructions");
    final promptText = _configService.getString("prompt_text_to_text");

    final model = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance).generativeModel(
      model: modelName,
      systemInstruction: Content.system(systemInstructions),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: jsonSchema,
      ),
    );
    final response = await model.generateContent([Content.text(prompt + promptText)]);
    return response.text ?? "";
  }

  Future<Uint8List?> generateTextToImage({required String prompt}) async {
    final modelName = _configService.getString("model_name_image");
    final promptText = _configService.getString("prompt_text_image");

    final model = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance).imagenModel(
      model: modelName,
      safetySettings: imagenSafetySettings,
      generationConfig: ImagenGenerationConfig(
        numberOfImages: 1,
        aspectRatio: ImagenAspectRatio.landscape16x9,
        negativePrompt: 'baja calidad, borroso, marca de agua, texto',
      ),
    );
    final response = await model.generateImages(prompt + promptText);
    if (response.images.isNotEmpty) {
      final image = response.images[0];
      return image.bytesBase64Encoded;
    } else {
      log('Error: No images were generated.');
      return null;
    }
  }

  Future<List<Uint8List?>> generateTextToMoreImage({required String prompt}) async {
    final modelName = _configService.getString("model_name_image");
    final promptText = _configService.getString("prompt_text_image");

    final model = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance).imagenModel(
      model: modelName,
      safetySettings: imagenSafetySettings,
      generationConfig: ImagenGenerationConfig(
        numberOfImages: 4,
        aspectRatio: ImagenAspectRatio.landscape16x9,
        negativePrompt: 'baja calidad, borroso, marca de agua, texto',
      ),
    );
    final response = await model.generateImages(prompt + promptText);
    if (response.filteredReason != null) {
      log(response.filteredReason!);
    }

    if (response.images.isNotEmpty) {
      final images = response.images;
      log('images creadas. ${images.length}');
      return images.map((e) => e.bytesBase64Encoded).toList();
    } else {
      // Handle the case where no images were generated
      log('Error: No images were generated.');
      return [];
    }
  }

  Future<void> generateImage({required String prompt}) async {
    final modelName = _configService.getString("model_name_image");
    final systemInstructions = _configService.getString("system_instructions");

    if (modelName.isEmpty || systemInstructions.isEmpty) {
      log("❌ Faltan valores en Remote Config.");
      return;
    }

    final ai = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance);
    final model = ai.generativeModel(
      model: modelName,
      systemInstruction: Content.system(systemInstructions),
    );

    final response = await model.generateContent([Content.text(prompt)]);
    log("✅ Respuesta del modelo:\n${response.text}");
  }
}
