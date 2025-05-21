import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:lottie/lottie.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/modules/home/controller/home_controller.dart';
import 'package:recetasperuanas/modules/home/widget/widget.dart' show CardTask;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/text_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.con});
  final HomeController con;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child:
          con.listTask.isEmpty
              ? SizedBox(
                width: 500,
                height: 500,
                child: Card(
                  shadowColor: AppColorScheme.of(context).textPrimary,
                  color: AppColorScheme.of(context).textSecundary,
                  elevation: 5,
                  margin: const EdgeInsets.all(20.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        LottieBuilder.asset(
                          'assets/json/note.json',
                          width: size.width,
                          height: size.height * 0.3,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final theme = Theme.of(context);
                            final uri =
                                'https://sandbox.mercadopago.com.pe/checkout/v1/redirect?pref_id=1258945087-382ec2c2-f085-4f54-9ab7-dc60a86e9126';
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
                                safariVCOptions: SafariViewControllerOptions(
                                  preferredBarTintColor: Colors.amber,
                                  preferredControlTintColor: Colors.white,
                                  barCollapsingEnabled: false,
                                  dismissButtonStyle: SafariViewControllerDismissButtonStyle.cancel,
                                ),
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                          child: Text('data'),
                        ),
                        ElevatedButton(onPressed: () {}, child: Text('data')),
                        const SizedBox(height: 20),
                        Center(child: AppText(text: context.loc.noNote)),
                      ],
                    ),
                  ),
                ),
              )
              : ListView.builder(
                itemCount: con.listTask.length,
                itemBuilder: (context, index) {
                  final itemTask = con.listTask[index];

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
                    child: CardTask(itemTask: itemTask, con: con),
                  );
                },
              ),
    );
  }
}
