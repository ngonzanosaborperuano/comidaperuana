import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/modules/setting/controller/setting_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/models/user_model.dart';
import 'package:recetasperuanas/shared/widget/spacing/app_spacer.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingController>(
      builder: (_, SettingController con, _) {
        final loading = con.userModel == UserModel.empty;
        return Column(
          children: [
            MiPerfil(loading: loading, con: con),
            AppVerticalSpace.sm,
            const Divider(height: 20, endIndent: 20, indent: 20),
            Language(con: con),
            DarkMode(con: con),
            AppVerticalSpace.slg,
            LogOutButton(con: con),
          ],
        );
      },
    );
  }
}

class DarkMode extends StatelessWidget {
  const DarkMode({super.key, required this.con});
  final SettingController con;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: context.loc.darkMode),
          ValueListenableBuilder(
            valueListenable: con.isDark,
            builder: (_, bool isDark, _) {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              con.isDark.value = themeProvider.themeMode == ThemeMode.dark;
              return AppSwitch(
                value: isDark,
                onChanged: (bool value) {
                  con.isDark.value = value;
                  context.read<ThemeProvider>().toggleTheme(value);
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
  const Language({super.key, required this.con});
  final SettingController con;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: context.loc.changeLanguage),
          ValueListenableBuilder(
            valueListenable: con.isSpanish,
            builder: (_, bool isSpanish, _) {
              final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
              con.isSpanish.value = localeProvider.locale.languageCode == 'es';
              return Material(
                color: context.color.textSecondary,
                child: AppSwitch(
                  value: isSpanish,
                  onChanged: (bool value) {
                    con.isSpanish.value = value;
                    if (value) {
                      context.read<LocaleProvider>().setLocale(const Locale('es'));
                    } else {
                      context.read<LocaleProvider>().setLocale(const Locale('en'));
                    }
                    SharedPreferencesHelper.instance.setBool(CacheConstants.spanish, value: !value);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key, required this.con});
  final SettingController con;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AppButton(
        isCancel: true,
        text: context.loc.logOut,
        showIcon: false,
        onPressed: () async {
          await con.logout();
          if (!context.mounted) return;
          context.go(Routes.splash.description);
        },
      ),
    );
  }
}

class MiPerfil extends StatelessWidget {
  const MiPerfil({super.key, required this.loading, required this.con});

  final bool loading;
  final SettingController con;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          AppVerticalSpace.sl,
          Text(context.loc.setting, style: AppStyles.headingPrimary),
          AppVerticalSpace.xslg,
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
                    con.userModel.foto == null || con.userModel.foto!.isEmpty
                        ? Image.asset(
                          'assets/img/avatar.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                        : Image.network(
                          con.userModel.foto!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
          ),
          AppVerticalSpace.lg,
          AppItemRow(title: context.loc.lastName, subTitle: con.userModel.nombreCompleto!),
          AppItemRow(title: context.loc.email, subTitle: con.userModel.email),
        ],
      ),
    );
  }
}
