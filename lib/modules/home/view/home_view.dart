import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/modules/home/controller/home_controller.dart';
import 'package:recetasperuanas/modules/home/widget/widget.dart' show CardTask;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/text_widget.dart';
import 'package:lottie/lottie.dart';

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
