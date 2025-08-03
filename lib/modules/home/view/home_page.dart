import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/color/app_colors.dart';
import 'package:recetasperuanas/core/config/config.dart' show AppStyles;
import 'package:recetasperuanas/core/database/database_helper.dart';
import 'package:recetasperuanas/core/network/network.dart';
import 'package:recetasperuanas/modules/home/controller/home_controller.dart';
import 'package:recetasperuanas/modules/home/view/home_view.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/repository/task_repository.dart';
import 'package:recetasperuanas/shared/utils/util.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  factory HomePage.routeBuilder(_, _) {
    return const HomePage(key: Key('home_page'));
  }
  Future<bool?> show(BuildContext context) async {
    return showAdaptiveDialog<bool>(context: context, builder: (context) => this);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (BuildContext context) {
        return HomeController(
          userRepository: context.read<UserRepository>(),
          taskRepository: TaskRepository(DatabaseHelper.instance, apiService: ApiService()),
        ); //..allRecipes();
      },
      child: Consumer<HomeController>(
        builder: (_, HomeController con, _) {
          final ValueNotifier<bool> isListening = ValueNotifier(false);
          return AppScaffold(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: isListening,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return Column(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.color.background,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10),
                                topRight: const Radius.circular(10),
                                bottomLeft: Radius.circular(value ? 0 : 10),
                                bottomRight: Radius.circular(value ? 0 : 10),
                              ),
                              border: Border.all(color: context.color.border, width: 0.3),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppHorizontalSpace.xs,
                                Expanded(
                                  child: VoiceTextField(
                                    hintText: context.loc.searchRecipe,
                                    controller: searchController,
                                    onSaved: (value) {
                                      print('onSaved: $value');
                                    },
                                    onChanged: (value) {
                                      print('onChanged: $value');
                                    },
                                    maxLines: 1,
                                    onListeningChanged: (value) {
                                      print('onListeningChanged: $value');
                                      isListening.value = value;
                                    },
                                  ),
                                ),
                                AppHorizontalSpace.sm,
                                AppHorizontalSpace.sl,
                                GestureDetector(
                                  onTap: () {},
                                  child: context.svgIcon(
                                    SvgIcons.image,
                                    color: context.color.textSecondary,
                                  ),
                                ),
                                AppHorizontalSpace.sm,
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: ColoredBox(
                              color: context.color.secondaryInvert,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: AnimatedContainer(
                                  height: value ? 30 : 0,
                                  width: double.infinity,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                  child: Center(
                                    child: Text(
                                      context.loc.listeningSpeakNow,
                                      style: AppStyles.bodyText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AppShimmer.progress(
                            child: Divider(
                              indent: 10,
                              endIndent: 10,
                              color: context.color.buttonPrimary,
                              thickness: 2,
                              height: 1,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Column(children: [Expanded(child: HomeView(con: con))]),
            onPressed: () async {
              onPressedSave(context, con);
            },
            showMenu: true,
          );
        },
      ),
    );
  }

  Future<void> onPressedSave(BuildContext context, HomeController con) async {
    GlobalKey<FormState> formKeyNote = GlobalKey<FormState>();
    con.titleController.clear();
    con.bodyController.clear();
    final result = await AppDialog(
      titleColor: AppColorScheme.of(context).text,
      title: context.loc.addNote,
      body: Form(
        key: formKeyNote,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.title),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: AppColorScheme.of(context).textSecondary,
                child: AppTextField(
                  hintText: context.loc.insertTitle,
                  textEditingController: con.titleController,
                  validator: (p0) => con.validateEmpty(p0, context),
                ),
              ),
            ),
            AppVerticalSpace.sl,
            Text(context.loc.body),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: AppColorScheme.of(context).textSecondary,
                child: AppTextField(
                  hintText: context.loc.writeNote,
                  textEditingController: con.bodyController,
                  validator: (p0) => con.validateEmpty(p0, context),
                ),
              ),
            ),
          ],
        ),
      ),
      buttons: [
        AppButton(
          isCancel: true,
          text: context.loc.back,
          showIcon: false,
          onPressed: () {
            context.pop(false);
          },
        ),
        AppButton(
          text: context.loc.save,
          showIcon: false,
          onPressed: () {
            if (!formKeyNote.currentState!.validate()) return;
            con.insertTask();
            context.pop(true);
          },
        ),
      ],
    ).show(context);

    if (result ?? false) {
      if (!context.mounted) return;
      showCustomSnackBar(
        context: context,
        message: context.loc.messageAddNote,
        backgroundColor: AppColorScheme.of(context).success,
        foregroundColor: AppColors.white,
      );
    }
  }
}
