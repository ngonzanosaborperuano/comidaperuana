import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:goncook/services/remote_config_service.dart';

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

  /// Obtiene el cliente de AI (Vertex AI o Google AI) según la configuración.
  ///
  /// Vertex AI requiere:
  /// 1. Facturación habilitada en Google Cloud
  /// 2. API de Vertex AI habilitada
  /// 3. Configuración de location (ej: "us-central1")
  ///
  /// Google AI es gratuito pero tiene limitaciones.
  FirebaseAI _getAIClient() {
    final useVertexAI = _configService.getString("use_vertex_ai").toLowerCase() == "true";

    if (useVertexAI) {
      final location = _configService.getString("vertex_location");
      if (location.isEmpty) {
        log(
          "⚠️ Vertex AI configurado pero vertex_location está vacío. Usando us-central1 por defecto.",
        );
        return FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance, location: "us-central1");
      }
      log("✅ Usando Vertex AI con location: $location");
      return FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance, location: location);
    } else {
      log("ℹ️ Usando Google AI (gratis, sin facturación)");
      return FirebaseAI.googleAI(appCheck: FirebaseAppCheck.instance);
    }
  }

  final jsonSchema = Schema.object(
    description: 'Respuesta estructurada para una receta de cocina enriquecida.',
    properties: {
      'isValidRecipe': Schema.boolean(
        description: 'Indica si la entrada fue válida y se generó una receta.',
      ),
      'errorMessage': Schema.string(
        description:
            'Mensaje de error si no se puede generar una receta válida (por ejemplo, si no es una receta o si solicita más de una a la vez).',
      ),
      'result': Schema.object(
        description: 'Contiene los datos completos de la receta, solo si la solicitud fue válida.',
        properties: {
          'title': Schema.string(description: 'Nombre del plato.'),
          'summary': Schema.string(description: 'Resumen breve del plato.'),
          'isVegetarian': Schema.boolean(description: '¿Es vegetariano?'),
          'mealType': Schema.string(description: 'Tipo de comida.'),
          'difficulty': Schema.string(description: 'Nivel de dificultad.'),
          'isAllergenic': Schema.boolean(description: '¿Contiene alérgenos comunes?'),

          'allergens': Schema.array(
            description: 'Lista de alérgenos presentes.',
            items: Schema.object(
              properties: {'name': Schema.string(description: 'Nombre del alérgeno.')},
            ),
          ),

          'ingredients': Schema.array(
            description: 'Ingredientes usados.',
            items: Schema.object(
              properties: {
                'name': Schema.string(description: 'Nombre del ingrediente.'),
                'amount': Schema.string(description: 'Cantidad.'),
              },
            ),
          ),

          'AlternativasIngredientes': Schema.array(
            description: 'Sugerencias para reemplazar ingredientes.',
            items: Schema.object(
              properties: {
                'original': Schema.string(description: 'Ingrediente original.'),
                'alternativas': Schema.array(
                  items: Schema.object(
                    properties: {'name': Schema.string(description: 'Ingrediente alternativo.')},
                  ),
                ),
              },
            ),
          ),

          'instructions': Schema.array(
            description: 'Pasos detallados para la preparación.',
            items: Schema.object(
              properties: {
                'step': Schema.number(description: 'Número de paso en orden secuencial.'),
                'text': Schema.string(description: 'Texto descriptivo del paso.'),
              },
            ),
          ),

          'nutrition_info': Schema.object(
            properties: {
              'calories': Schema.integer(description: 'Calorías.'),
              'protein': Schema.integer(description: 'Proteína en gramos.'),
              'carbs': Schema.integer(description: 'Carbohidratos en gramos.'),
              'fats': Schema.integer(description: 'Grasas en gramos.'),
              'fiber': Schema.integer(description: 'Fibra en gramos.'),
              'sugar': Schema.integer(description: 'Azúcar en gramos.'),
              'sodium': Schema.integer(description: 'Sodio en miligramos.'),
              'cholesterol': Schema.integer(description: 'Colesterol en miligramos.'),
              'vitamin_c': Schema.integer(description: 'Vitamina C en miligramos.'),
              'iron': Schema.integer(description: 'Hierro en miligramos.'),
            },
          ),

          'macros': Schema.object(
            properties: {
              'protein_g': Schema.number(),
              'carbs_g': Schema.number(),
              'fats_g': Schema.number(),
              'fiber_g': Schema.number(),
              'sugar_g': Schema.number(),
              'sodium_mg': Schema.number(),
              'cholesterol_mg': Schema.number(),
              'iron_mg': Schema.number(),
              'vitamin_c_mg': Schema.number(),
            },
          ),

          'glycemic_index': Schema.number(),

          'diets': Schema.array(
            description: 'Dietas compatibles.',
            items: Schema.object(
              properties: {'name': Schema.string(description: 'Nombre de la dieta.')},
            ),
          ),

          'recommended_servings': Schema.object(
            properties: {
              'adult': Schema.string(),
              'child': Schema.string(),
              'athlete': Schema.string(),
              'senior': Schema.string(),
            },
          ),

          'satiety_level': Schema.string(),
          'digestion_time_minutes': Schema.number(),

          'medical_restrictions': Schema.array(
            description: 'Condiciones médicas incompatibles.',
            items: Schema.object(
              properties: {'name': Schema.string(description: 'Condición médica.')},
            ),
          ),

          'processing_level': Schema.number(),
          'environmental_impact': Schema.string(),

          'similar_dishes': Schema.array(
            items: Schema.object(
              properties: {'name': Schema.string(description: 'Nombre del plato similar.')},
            ),
          ),

          'extra_info': Schema.object(
            properties: {
              'origin_country': Schema.string(),
              'ideal_season': Schema.string(),
              'cooking_method': Schema.string(),
              'spicy_level': Schema.string(),
            },
          ),

          'recommended_pairings': Schema.object(
            properties: {
              'drinks': Schema.array(
                items: Schema.object(
                  properties: {'name': Schema.string(description: 'Bebida recomendada.')},
                ),
              ),
              'sides': Schema.array(
                items: Schema.object(
                  properties: {'name': Schema.string(description: 'Guarnición sugerida.')},
                ),
              ),
              'desserts': Schema.array(
                items: Schema.object(
                  properties: {'name': Schema.string(description: 'Postre sugerido.')},
                ),
              ),
            },
          ),

          'health_warnings': Schema.array(
            items: Schema.object(
              properties: {'text': Schema.string(description: 'Advertencia médica.')},
            ),
          ),
          'plating_instructions': Schema.array(
            description: 'Instrucciones detalladas sobre cómo servir o emplatar el plato.',
            items: Schema.object(
              properties: {
                'step': Schema.number(description: 'Número de paso.'),
                'description': Schema.string(description: 'Descripción del paso de emplatado.'),
              },
            ),
          ),
        },
      ),
      'cacheTime': Schema.string(
        description:
            'Timestamp de caché (UNIX timestamp en segundos o milisegundos, sin decimales).',
      ),
      'time': Schema.string(
        description:
            'Timestamp de generación (UNIX timestamp en segundos o milisegundos, sin decimales).',
      ),
    },
    propertyOrdering: ['isValidRecipe', 'errorMessage', 'result', 'cacheTime', 'time'],
    optionalProperties: ['errorMessage', 'result'], //, 'cacheTime', 'time'
  );

  final safetySettingsImage = [
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high, null),
  ];

  Stream<String> generateAudioTextStream({required InlineDataPart audioPart}) async* {
    final modelName = _configService.getString("model_name");
    final systemInstructions = _configService.getString("system_instructions");
    final promptText = _configService.getString("prompt_audio_text");

    if (modelName.isEmpty || systemInstructions.isEmpty) {
      log("❌ Faltan valores en Remote Config.");
      yield "";
      return;
    }

    final ai = _getAIClient();
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

    final ai = _getAIClient();
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

    final ai = _getAIClient();
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

    final ai = _getAIClient();
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
      Content.multi([TextPart(promptText), imagePart]),
    ]);

    return response.text ?? "";
  }

  Future<String> generateTextToText({required String prompt}) async {
    final modelName = _configService.getString("model_name");
    final systemInstructions = _configService.getString("system_instructions");
    final promptText = _configService.getString("prompt_text_to_text");

    final ai = _getAIClient();
    final model = ai.generativeModel(
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

  /// Genera una imagen a partir de texto usando Vertex AI Imagen.
  ///
  /// ⚠️ NOTA: Esta función requiere Vertex AI (facturación habilitada).
  /// imagenModel solo está disponible en Vertex AI, no en Google AI.
  ///
  /// Para habilitar:
  /// 1. Habilitar facturación en Google Cloud Console
  /// 2. Habilitar API de Vertex AI
  /// 3. Configurar "use_vertex_ai": "true" en Remote Config
  Future<Uint8List?> generateTextToImage({required String prompt}) async {
    final modelName = _configService.getString("model_name_image");
    final promptText = _configService.getString("prompt_text_image");

    // imagenModel solo está disponible en Vertex AI
    final location = _configService.getString("vertex_location");
    final vertexLocation = location.isEmpty ? "us-central1" : location;

    final model = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance, location: vertexLocation)
        .imagenModel(
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

  /// Genera múltiples imágenes a partir de texto usando Vertex AI Imagen.
  ///
  /// ⚠️ NOTA: Esta función requiere Vertex AI (facturación habilitada).
  /// imagenModel solo está disponible en Vertex AI, no en Google AI.
  Future<List<Uint8List?>> generateTextToMoreImage({required String prompt}) async {
    final modelName = _configService.getString("model_name_image");
    final promptText = _configService.getString("prompt_text_image");

    // imagenModel solo está disponible en Vertex AI
    final location = _configService.getString("vertex_location");
    final vertexLocation = location.isEmpty ? "us-central1" : location;

    final model = FirebaseAI.vertexAI(appCheck: FirebaseAppCheck.instance, location: vertexLocation)
        .imagenModel(
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

    final ai = _getAIClient();
    final model = ai.generativeModel(
      model: modelName,
      systemInstruction: Content.system(systemInstructions),
    );

    final response = await model.generateContent([Content.text(prompt)]);
    log("✅ Respuesta del modelo:\n${response.text}");
  }
}
