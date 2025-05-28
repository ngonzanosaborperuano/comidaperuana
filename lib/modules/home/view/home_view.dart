import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recetasperuanas/modules/home/controller/home_controller.dart';
import 'package:recetasperuanas/modules/home/widget/widget.dart' show CardTask, VoiceToTextButton;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/text_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.con});
  final HomeController con;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ValueNotifier<Uint8List?> img = ValueNotifier<Uint8List?>(null);
  ValueNotifier<List<Uint8List?>> imgList = ValueNotifier<List<Uint8List?>>([]);
  ScrollController scrollController = ScrollController();
  // modelo gemini-2.0-flash
  final safetySettings = [
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high, null),
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high, null),
  ];

  // modelo imagen-3.0-generate-002
  final imagenSafetySettings = ImagenSafetySettings(
    ImagenSafetyFilterLevel.blockLowAndAbove,
    ImagenPersonFilterLevel.allowAdult,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child:
          widget.con.listTask.isEmpty
              ? SizedBox(
                width: 500,
                height: 500,
                child: Card(
                  shadowColor: context.color.textPrimary,
                  color: context.color.textSecundary,
                  elevation: 5,
                  margin: const EdgeInsets.all(20.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          VoiceToTextButton(
                            onResult: (textoGenerado) {
                              // Aquí recibes la respuesta del modelo
                              log(textoGenerado);
                              // Puedes mostrarlo en pantalla o guardarlo
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(source: ImageSource.camera);

                              if (pickedFile == null) return;

                              final file = File(pickedFile.path);
                              final bytes = await file.readAsBytes();

                              final model = FirebaseAI.googleAI(
                                appCheck: FirebaseAppCheck.instance,
                              ).generativeModel(
                                model: 'gemini-2.0-flash',
                                safetySettings: safetySettings,
                                generationConfig: GenerationConfig(
                                  responseMimeType: 'text/plain',
                                  responseSchema: Schema.string(
                                    description: 'Describe la imagen en español',
                                  ),
                                  maxOutputTokens: 100, //max128
                                  temperature: 0.5,
                                  topP: 0.9,
                                  topK: 40,
                                ),
                              );

                              final prompt = TextPart(
                                "¿Qué hay en la imagen? responde en español.",
                              );
                              final imagePart = InlineDataPart('image/jpeg', bytes);

                              final response = await model.generateContent([
                                Content.multi([prompt, imagePart]),
                              ]);
                              log(response.text!);
                            },
                            child: const Text('gemini-2.0-flash - image a text'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final model = FirebaseAI.googleAI(
                                appCheck: FirebaseAppCheck.instance,
                              ).generativeModel(model: 'gemini-2.0-flash');
                              // Provide a prompt that contains text
                              final prompt = [Content.text('ecribe una receta peruana.')];
                              final response = await model.generateContent(prompt);
                              print(response.text);
                            },
                            child: const Text('gemini-2.0-flash - text'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final model = FirebaseAI.googleAI(
                                appCheck: FirebaseAppCheck.instance,
                              ).generativeModel(model: 'gemini-2.0-flash');

                              final chat = model.startChat();
                              // Provide a prompt that contains text
                              final prompt = Content.text('escribe un cuento de caperucita roja.');

                              // final response = await chat.sendMessage(prompt);
                              // log(response.text!);
                              final response = chat.sendMessageStream(prompt);
                              await for (final chunk in response) {
                                log(chunk.text!);
                              }
                            },
                            child: const Text('gemini-2.0-flash - chat'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              //identifica el tipo de película en base a su descripción y devuelve un valor de enumeración.
                              final enumSchema = Schema.enumString(
                                enumValues: ['drama', 'comedia', 'documental'],
                              );

                              final model = FirebaseAI.googleAI(
                                appCheck: FirebaseAppCheck.instance,
                              ).generativeModel(
                                model: 'gemini-2.0-flash',
                                generationConfig: GenerationConfig(
                                  responseMimeType: 'text/x.enum',
                                  responseSchema: enumSchema,
                                ),
                              );

                              const prompt = """
                            La película busca educar e informar al público sobre temas, eventos o personas de la vida real. 
                            Ofrece un registro factual de un tema específico mediante la combinación de entrevistas, material histórico y narración. 
                            El propósito principal de una película es presentar información y brindar perspectivas sobre diversos aspectos de la realidad.
                            """;
                              final response = await model.generateContent([Content.text(prompt)]);
                              print(response.text);
                            },
                            child: const Text('gemini-2.0-flash - respuesta mediante esquemas'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final model = FirebaseAI.googleAI(
                                appCheck: FirebaseAppCheck.instance,
                              ).generativeModel(model: 'gemini-2.0-flash');
                              // Provide a prompt that contains text
                              final prompt = [Content.text('ecribe una receta peruana.')];
                              final response = await model.generateContent(prompt);
                              print(response.text);
                            },
                            child: const Text('gemini-2.0-flash - text'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final theme = Theme.of(context);
                              const uri =
                                  'https://www.mercadopago.com.pe/checkout/v1/redirect?pref_id=1258945087-a3355970-ed09-4d06-9504-64b28417a931';
                              try {
                                await launchUrl(
                                  Uri.parse(uri),
                                  prefersDeepLink: true,
                                  customTabsOptions: CustomTabsOptions(
                                    colorSchemes: CustomTabsColorSchemes.defaults(
                                      toolbarColor: theme.colorScheme.surface,
                                    ),
                                    urlBarHidingEnabled: true,
                                    showTitle: false,
                                    closeButton: CustomTabsCloseButton(
                                      icon: CustomTabsCloseButtonIcons.back,
                                    ),
                                    shareState: CustomTabsShareState.browserDefault,
                                  ),
                                  safariVCOptions: const SafariViewControllerOptions(
                                    preferredBarTintColor: Colors.amber,
                                    preferredControlTintColor: Colors.white,
                                    barCollapsingEnabled: false,
                                    dismissButtonStyle:
                                        SafariViewControllerDismissButtonStyle.cancel,
                                  ),
                                );
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: const Text('MercadoPago - Custom Tabs'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final model = FirebaseAI.googleAI(
                                appCheck: FirebaseAppCheck.instance,
                              ).imagenModel(
                                model: 'imagen-3.0-generate-002',
                                safetySettings: imagenSafetySettings,
                              );

                              // Provide an image generation prompt
                              const prompt =
                                  'crea una imagen de una fusion de ceviche peruano y tallarines verde, con un toque profesional y moderno, con un fondo elegante y minimalista.';

                              // To generate an image, call `generateImages` with the text prompt
                              final response = await model.generateImages(prompt);

                              if (response.images.isNotEmpty) {
                                final image = response.images[0];
                                img.value = image.bytesBase64Encoded;
                                log('Image URL: ${image.bytesBase64Encoded}\n ${image.mimeType}');

                                // Process the image
                              } else {
                                // Handle the case where no images were generated
                                log('Error: No images were generated.');
                              }
                            },
                            child: const Text('gemini-2.0-flash - text a imagen'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final model = FirebaseAI.googleAI(
                                appCheck: FirebaseAppCheck.instance,
                              ).imagenModel(
                                model: 'imagen-3.0-generate-002',
                                generationConfig: ImagenGenerationConfig(numberOfImages: 4),
                                safetySettings: imagenSafetySettings,
                              );

                              // Provide an image generation prompt
                              const prompt =
                                  'crea una imagen de una comida llamada pollada de peru, con un toque profesional y moderno, con un fondo elegante y minimalista.';

                              // To generate an image, call `generateImages` with the text prompt
                              final response = await model.generateImages(prompt);

                              if (response.filteredReason != null) {
                                log(response.filteredReason!);
                              }

                              if (response.images.isNotEmpty) {
                                final images = response.images;
                                log('images creadas. ${images.length}');
                                imgList.value = images.map((e) => e.bytesBase64Encoded).toList();

                                log('imgList.value creadas. ${imgList.value.length}');
                              } else {
                                // Handle the case where no images were generated
                                log('Error: No images were generated.');
                              }
                            },
                            child: const Text('gemini-2.0-flash - text a 4 imagenes'),
                          ),
                          ValueListenableBuilder(
                            valueListenable: img,
                            builder: (BuildContext context, value, Widget? child) {
                              log('img.value.length: ${img.value != null ? 1 : 0}');
                              return img.value != null
                                  ? Image.memory(img.value!, width: 300, height: 300)
                                  : const SizedBox.shrink();
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: imgList,
                            builder: (BuildContext context, List<Uint8List?> value, Widget? child) {
                              log('imgList.value.length: ${imgList.value.length}');
                              return ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: imgList.value.length,
                                itemBuilder: (context, index) {
                                  return Image.memory(
                                    imgList.value[index]!,
                                    width: 300,
                                    height: 300,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Center(child: AppText(text: context.loc.noNote)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              : ListView.builder(
                itemCount: widget.con.listTask.length,
                itemBuilder: (context, index) {
                  final itemTask = widget.con.listTask[index];

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 100 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: CardTask(itemTask: itemTask, con: widget.con),
                  );
                },
              ),
    );
  }
}
