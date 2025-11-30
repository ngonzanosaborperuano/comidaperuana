import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/features/core/bloc/theme_bloc.dart';

class ThemeConfig {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.light),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }

  static Widget buildWithTheme({required Widget child, required BuildContext context}) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state is ThemeLoaded) {
          return MaterialApp(
            theme: getLightTheme(),
            darkTheme: getDarkTheme(),
            themeMode: state.themeMode,
            home: child,
          );
        }
        return MaterialApp(theme: getLightTheme(), home: child);
      },
    );
  }
}
