import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/core/config/config.dart' show AppStyles;
import 'package:recetasperuanas/core/database/database_helper.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/modules/home/bloc/home_bloc.dart';
import 'package:recetasperuanas/modules/home/view/home_view.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/repository/task_repository.dart';
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
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) {
        final userRepository = context.read<IUserRepository>();
        final apiService = context.read<ApiService>();
        final taskRepository = TaskRepository(DatabaseHelper.instance, apiService: apiService);

        return HomeBloc(userRepository: userRepository, taskRepository: taskRepository);
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final ValueNotifier<bool> isListening = ValueNotifier(false);
          return AppScaffold(
            toolbarHeight: kToolbarHeight,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
                                topLeft: const Radius.circular(AppSpacing.sm),
                                topRight: const Radius.circular(AppSpacing.sm),
                                bottomLeft: Radius.circular(value ? 0 : AppSpacing.sm),
                                bottomRight: Radius.circular(value ? 0 : AppSpacing.sm),
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
                                      // Usar el BLoC para buscar
                                      context.read<HomeBloc>().add(HomeSearchTask(value));
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
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            body: const HomeView(),
            showMenu: true,
          );
        },
      ),
    );
  }
}
