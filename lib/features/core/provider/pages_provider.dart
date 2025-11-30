import 'package:flutter/material.dart';

class PagesProvider extends ChangeNotifier {
  int _selectPage = 0;

  int get selectPage => _selectPage;

  void togglePage(int page) {
    _selectPage = page;
    notifyListeners();
  }
}
