import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_repository.dart';
import 'package:goncook/features/home/bloc/home_bloc.dart';
import 'package:goncook/features/home/view/home_view.dart';
import 'package:logging/logging.dart';

/// Pantalla principal del inicio de la aplicación.
///
/// Usa BLoC para la lógica de búsqueda y muestra un `AppScaffold` con
/// barra de búsqueda por voz. Esta vista no debe contener lógica de
/// negocio; delega en `HomeBloc`.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  /// Creador de ruta para sistemas de navegación declarativa.
  factory HomePage.routeBuilder(_, _) {
    return const HomePage(key: Key('home_page'));
  }

  /// Muestra la vista como un diálogo adaptativo y retorna el resultado.
  Future<bool?> show(BuildContext context) async {
    return showAdaptiveDialog<bool>(context: context, builder: (context) => this);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final Logger _logger = Logger('HomePage');
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) {
        final userRepository = context.read<IUserRepository>();

        return HomeBloc(userRepository: userRepository);
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
                                      _logger.info('onSaved: $value');
                                    },
                                    onChanged: (value) {
                                      _logger.fine('onChanged: $value');
                                      // Usar el BLoC para buscar
                                      context.read<HomeBloc>().add(HomeSearchTask(value));
                                    },
                                    maxLines: 1,
                                    onListeningChanged: (value) {
                                      _logger.fine('onListeningChanged: $value');
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
                                      style: TextStyle(fontSize: 16, color: context.color.text),
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
