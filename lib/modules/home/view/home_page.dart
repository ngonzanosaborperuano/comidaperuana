import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/color/app_colors.dart';
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
  factory HomePage.routeBuilder(_, __) {
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
          return AppScaffold(
            title: AppTextFieldSearch(
              placeholder: context.loc.searchRecipe,
              textController: searchController,
              onPressed: () {
                searchController.clear();
                con.allRecipes();
              },
              onChanged: (value) {
                con.searchTask(value);
              },
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
