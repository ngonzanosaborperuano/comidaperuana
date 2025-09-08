import 'dart:async';
import 'dart:io' show InternetAddress;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConnectionObserver {
  static final ConnectionObserver instance = ConnectionObserver._();
  final _controller = StreamController<bool>.broadcast();

  ConnectionObserver._() {
    _checkLoop();
  }

  Stream<bool> get onConnectionChanged => _controller.stream;

  Future<void> _checkLoop() async {
    while (true) {
      final isOnline = await _hasConnection();
      _controller.add(isOnline);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<bool> _hasConnection() async {
    try {
      final url = dotenv.env['JSONPLACEHOLDER_URL_DOMINIO'];
      final result = await InternetAddress.lookup(url!);
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get currentConnection async => await _hasConnection();
}
