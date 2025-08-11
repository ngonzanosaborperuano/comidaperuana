import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/bloc/locale_bloc.dart';
import 'package:recetasperuanas/core/bloc/theme_bloc.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';
import 'package:recetasperuanas/core/constants/routes.dart' show Routes;
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/modules/setting/bloc/setting_bloc.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/models/user_model.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingBloc, SettingState>(
      listener: (context, state) async {
        if (state is SettingLogoutSuccess) {
          context.go(Routes.splash.description);
        } else if (state is SettingLogoutFailure) {
          if (!context.mounted) return;
          await showAdaptiveDialog(
            context: context,
            builder:
                (context) => AppModalAlert(
                  text: state.message,
                  title: context.loc.error,
                  maxHeight: 200,
                  icon: Icons.error,
                  labelButton: context.loc.accept,
                  onPressed: context.pop,
                ),
          );
        } else if (state is SettingError) {
          if (!context.mounted) return;
          await showAdaptiveDialog(
            context: context,
            builder:
                (context) => AppModalAlert(
                  text: state.message,
                  title: context.loc.error,
                  maxHeight: 200,
                  icon: Icons.error,
                  labelButton: context.loc.accept,
                  onPressed: context.pop,
                ),
          );
        }
      },
      builder: (context, state) {
        final loading =
            state is SettingLoading || state is SettingInitial || state is SettingLogoutInProgress;
        final user = state is SettingLoaded ? state.user : UserModel.empty;
        return Column(
          children: [
            MiPerfil(loading: loading, user: user),
            AppVerticalSpace.sm,
            const Divider(height: 20, endIndent: 20, indent: 20),
            const Language(),
            AppVerticalSpace.sm,
            const DarkMode(),
            AppVerticalSpace.sm,
            const AutoRotation(),
            AppVerticalSpace.sm,
            const LogOutButton(),
          ],
        );
      },
    );
  }
}

class DarkMode extends StatelessWidget {
  const DarkMode({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: context.loc.darkMode),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (_, state) {
              final themeMode = state is ThemeLoaded ? state.themeMode : ThemeMode.system;
              return AppSwitch(
                value: themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  context.read<ThemeBloc>().add(ThemeToggleRequested(value));
                  SharedPreferencesHelper.instance.setBool(CacheConstants.darkMode, value: value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class Language extends StatelessWidget {
  const Language({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: context.loc.changeLanguage),
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (_, state) {
              final currentLocale = state is LocaleLoaded ? state.locale : const Locale('es');
              return AppSwitch(
                value: currentLocale.languageCode == 'es',
                onChanged: (bool value) {
                  final newLocale = value ? const Locale('es') : const Locale('en');
                  context.read<LocaleBloc>().add(LocaleChanged(newLocale));
                  SharedPreferencesHelper.instance.setBool(CacheConstants.spanish, value: !value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AppButton(
        isCancel: true,
        text: context.loc.logOut,
        showIcon: false,
        onPressed: () async {
          context.read<SettingBloc>().add(SettingLogoutRequested());
        },
      ),
    );
  }
}

class AutoRotation extends StatelessWidget {
  const AutoRotation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: context.loc.autoRotation),
              AppText(
                text: context.loc.autoRotationDescription,
                fontSize: 12,
                color: context.color.textSecondary,
              ),
            ],
          ),
          BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              final isEnabled = state is SettingLoaded ? state.isAutoRotationEnabled : false;
              return AppSwitch(
                value: isEnabled,
                onChanged: (bool value) async {
                  context.read<SettingBloc>().add(SettingAutoRotationToggled(value));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class MiPerfil extends StatelessWidget {
  const MiPerfil({super.key, required this.loading, required this.user});

  final bool loading;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(context.loc.setting, style: AppStyles.headingPrimary),
          AppVerticalSpace.xmd,
          AppShimmer.light(
            enabled: loading,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColorScheme.of(context).success, width: 3),
              ),
              child: ClipOval(
                child:
                    user.avatar.isEmpty
                        ? Image.asset(
                          'assets/img/avatar.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                        : Image.network(user.avatar, width: 80, height: 80, fit: BoxFit.cover),
              ),
            ),
          ),
          AppVerticalSpace.lg,
          AppItemRow(
            title: context.loc.user,
            subTitle:
                '${user.firstName} ${user.lastName}'.trim().isEmpty
                    ? 'No disponible'
                    : '${user.firstName} ${user.lastName}',
            icon: Icons.person,
            maxWidth: 100,
          ),
          AppItemRow(
            title: context.loc.email,
            subTitle: user.email,
            icon: Icons.email,
            maxWidth: 100,
          ),
        ],
      ),
    );
  }
}
