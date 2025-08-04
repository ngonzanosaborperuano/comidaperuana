import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:recetasperuanas/modules/home/controller/home_controller.dart';
import 'package:recetasperuanas/modules/home/widget/subscription_plans_page.dart';
import 'package:recetasperuanas/modules/home/widget/widget.dart'
    show AppGeminiTextToTextButton, CardTask;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_image.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

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

  final imagenSafetySettings = ImagenSafetySettings(
    ImagenSafetyFilterLevel.blockLowAndAbove,
    ImagenPersonFilterLevel.allowAdult,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          widget.con.listTask.isNotEmpty
              ? SizedBox(
                width: 500,
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
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
                                  shareState:
                                      CustomTabsShareState.browserDefault,
                                ),
                                safariVCOptions:
                                    const SafariViewControllerOptions(
                                      preferredBarTintColor: Colors.amber,
                                      preferredControlTintColor: Colors.white,
                                      barCollapsingEnabled: false,
                                      dismissButtonStyle:
                                          SafariViewControllerDismissButtonStyle
                                              .cancel,
                                    ),
                              );
                            } catch (e, stackTrace) {
                              debugPrint('Error: $e');
                              debugPrint('StackTrace: $stackTrace');
                            }
                          },
                          child: Text(context.loc.payuSafe),
                        ),

                        const SizedBox(height: 16),

                        AppButton(
                          text: context.loc.premiumPlans,
                          onPressed: () {
                            showSubscriptionModal(
                              context,
                              onSelected: () {
                                if (mounted) {
                                  context.showSuccessToast(
                                    context.loc.payuSuccess,
                                  );
                                }
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        // Descripción del botón PayU
                        Text(
                          context.loc.payuDescription,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        AppGeminiTextToTextButton(
                          prompt: 'tamales, para 2 personas',
                          onResult: (text) {
                            log(text);
                          },
                        ),

                        const SizedBox(height: 20),
                        Center(child: context.facil),
                        const SizedBox(height: 10),
                        Center(child: context.media),
                        const SizedBox(height: 10),
                        Center(child: context.dificil),
                        const SizedBox(height: 10),
                        Center(
                          child: context.etiqueta(
                            'Etiqueta',
                            icon: context.svgIconSemantic.label(size: 20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Ejemplos adicionales del sistema SVG usando nombres semánticos
                        context.svgIconSemantic.sparkle(
                          size: 24,
                          color: Colors.amber,
                        ),
                        context.svgIconSemantic.gridAll(
                          size: 24,
                          color: Colors.blue,
                        ),
                        context.svgIconSemantic.coffeeBreakfast(
                          size: 24,
                          color: Colors.brown,
                        ),

                        const SizedBox(height: 10),
                        // Ejemplo con AppSvg para imágenes más grandes usando nombre semántico
                        Center(
                          child: context.svgImage(
                            SvgIcons.sparkles,
                            width: 60,
                            height: 60,
                            color: Colors.purple,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Ejemplos del sistema de gestión de imágenes
                        const Text(
                          'Sistema de Imágenes:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Ejemplos usando nombres semánticos
                        context.image.avatar(size: 40),
                        const SizedBox(width: 10),
                        context.image.logo(size: 60),
                        const SizedBox(width: 10),
                        context.image.google(size: 30),

                        const SizedBox(height: 20),

                        // Ejemplo usando byName dinámicamente
                        ...([
                          {'name': 'avatar', 'size': 35.0},
                          {'name': 'logo', 'size': 50.0},
                          {'name': 'google', 'size': 25.0},
                        ]).map(
                          (image) =>
                              context.image.byName(
                                image['name'] as String,
                                size: image['size'] as double,
                              ) ??
                              Icon(
                                Icons.image_not_supported,
                                size: image['size'] as double,
                              ),
                        ),
                      ],
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
