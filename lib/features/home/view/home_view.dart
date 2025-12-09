import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/features/home/bloc/home_bloc.dart';
import 'package:goncook/features/home/widget/app_gemini_text_to_text_button.dart';
import 'package:goncook/features/home/widget/app_gemini_voice_to_text_button.dart'
    show AppGeminiVoiceToTextButton;
import 'package:goncook/features/home/widget/subscription_plans_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! HomeLoaded) {
          return const SizedBox.shrink();
        }
        final listTask = [];
        return Center(
          child: !listTask.isNotEmpty
              ? SizedBox(
                  width: 500,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xmd),
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
                              } catch (e, stackTrace) {
                                debugPrint('Error: $e');
                                debugPrint('StackTrace: $stackTrace');
                              }
                            },
                            child: Text(context.loc.payuSafe),
                          ),
                          AppGeminiVoiceToTextButton(
                            onResult: (text) {
                              log(text);
                            },
                          ),
                          AppVerticalSpace.md,

                          AppButton(
                            text: context.loc.premiumPlans,
                            onPressed: () {
                              showSubscriptionModal(
                                context,
                                onSelected: () {
                                  if (mounted) {
                                    context.showSuccessToast(context.loc.payuSuccess);
                                  }
                                },
                              );
                            },
                          ),

                          AppVerticalSpace.sm,

                          // Descripción del botón PayU
                          Text(
                            context.loc.payuDescription,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),

                          AppGeminiTextToTextButton(
                            prompt: 'tamales, para 1 persona',
                            onResult: (text) {
                              log(text);
                            },
                          ),

                          AppVerticalSpace.xmd,
                          Center(child: context.facil),
                          AppVerticalSpace.sm,
                          Center(child: context.media),
                          AppVerticalSpace.sm,
                          Center(child: context.dificil),
                          AppVerticalSpace.sm,
                          Center(
                            child: context.etiqueta(
                              'Etiqueta',
                              icon: context.svgIconSemantic.label(size: 20),
                            ),
                          ),
                          AppVerticalSpace.sm,
                          // Ejemplos adicionales del sistema SVG usando nombres semánticos
                          context.svgIconSemantic.sparkle(size: 24, color: Colors.amber),
                          context.svgIconSemantic.gridAll(size: 24, color: Colors.blue),
                          context.svgIconSemantic.coffeeBreakfast(size: 24, color: Colors.brown),

                          AppVerticalSpace.sm,
                          // Ejemplo con AppSvg para imágenes más grandes usando nombre semántico
                          Center(
                            child: context.svgImage(
                              SvgIcons.sparkles,
                              width: 60,
                              height: 60,
                              color: Colors.purple,
                            ),
                          ),

                          AppVerticalSpace.xmd,

                          // Ejemplos del sistema de gestión de imágenes
                          const Text(
                            'Sistema de Imágenes:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          AppVerticalSpace.sm,

                          // Ejemplos usando nombres semánticos
                          context.image.avatar(size: 40),
                          AppHorizontalSpace.sm,
                          context.image.logo(size: 60),
                          AppHorizontalSpace.sm,
                          context.image.google(size: 30),

                          AppVerticalSpace.xmd,

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
                                Icon(Icons.image_not_supported, size: image['size'] as double),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: listTask.length,
                  itemBuilder: (context, index) {
                    final itemTask = listTask[index];

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
                      child: Text(itemTask.name),
                    );
                  },
                ),
        );
      },
    );
  }
}
