import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class AppCheckInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? appCheckToken = await FirebaseAppCheck.instance.getToken();

    options.headers['X-Firebase-AppCheck'] = appCheckToken;

    return handler.next(options);
  }
}
