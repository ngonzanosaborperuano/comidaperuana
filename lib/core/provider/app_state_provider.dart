import 'package:flutter/material.dart';
import 'package:recetasperuanas/domain/auth/entities/user.dart';

/// Global app state provider
class AppStateProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  String _theme = 'light';
  String _locale = 'es';
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get theme => _theme;
  String get locale => _locale;
  bool get isAuthenticated => _isAuthenticated;

  /// Update user
  void updateUser(User? user) {
    _currentUser = user;
    _isAuthenticated = user != null;
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Toggle theme
  void toggleTheme() {
    _theme = _theme == 'light' ? 'dark' : 'light';
    notifyListeners();
  }

  /// Set theme
  void setTheme(String theme) {
    _theme = theme;
    notifyListeners();
  }

  /// Set locale
  void setLocale(String locale) {
    _locale = locale;
    notifyListeners();
  }

  /// Logout
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _currentUser = null;
    _isLoading = false;
    _error = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
