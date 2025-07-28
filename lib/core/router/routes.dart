import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

abstract class AppRoutes {
  String get path;
  String get endpoint;
  bool get shared;
}

extension AppRouteContext on BuildContext {
  void goTo(
    AppRoutes route, {
    Object? extra,
    Map<String, dynamic> queryParams = const {},
    Map<String, dynamic> pathParams = const {},
  }) {
    var path = route.path;
    if (pathParams.isNotEmpty) {
      for (final entry in pathParams.entries) {
        path = path.replaceAll(':${entry.key}', entry.value.toString());
      }
    }

    go(Uri(path: path, queryParameters: queryParams).toString(), extra: extra);
  }

  Future<T?> pushTo<T extends Object?>(
    AppRoutes route, {
    Object? extra,
    Map<String, dynamic> queryParams = const {},
    Map<String, dynamic> pathParams = const {},
    bool onTop = false,
  }) {
    String path;
    if (onTop) {
      final bottom = GoRouter.of(this).state.uri.path;

      path = '$bottom/${route.endpoint}';
      Logger('AppRouteContext').info('New route: $path');
    } else {
      path = route.path;

      if (pathParams.isNotEmpty) {
        for (final entry in pathParams.entries) {
          path = path.replaceAll(':${entry.key}', entry.value.toString());
        }
      }
    }

    return push<T>(Uri(path: path, queryParameters: queryParams).toString(), extra: extra);
  }
}
