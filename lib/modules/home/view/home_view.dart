import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:recetasperuanas/modules/home/controller/home_controller.dart';
import 'package:recetasperuanas/modules/home/widget/widget.dart'
    show AppGeminiTextToTextButton, CardTask;
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
    return Center(
      child:
          widget.con.listTask.isEmpty
              ? SizedBox(
                width: 500,
                height: 500,
                child: Card(
                  shadowColor: context.color.text,
                  color: context.color.textSecondary,
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
                          AppGeminiTextToTextButton(
                            prompt: 'tamales, para 2 personas',
                            onResult: (text) {
                              log(text);
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
