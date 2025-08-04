import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/provider/app_state_provider.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/auth/value_objects/user_id.dart' show UserId;

/// Test helpers for Provider-based testing
class ProviderTestHelpers {
  /// Create a test app with providers
  static Widget createTestApp({
    required Widget child,
    List<ChangeNotifierProvider> additionalProviders = const [],
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ...additionalProviders,
      ],
      child: MaterialApp(home: child),
    );
  }

  /// Create a test app with specific providers
  static Widget createTestAppWithProviders({
    required Widget child,
    required List<ChangeNotifierProvider> providers,
  }) {
    return MultiProvider(providers: providers, child: MaterialApp(home: child));
  }

  /// Pump widget with duration
  static Future<void> pumpWidget(WidgetTester tester, Widget widget, {Duration? duration}) async {
    await tester.pumpWidget(widget);
    if (duration != null) {
      await tester.pump(duration);
    }
  }

  /// Wait for async operations
  static Future<void> waitForAsync(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Find widget by key
  static Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  /// Find widget by text
  static Finder findByText(String text) {
    return find.text(text);
  }

  /// Find widget by type
  static Finder findByType<T extends Widget>() {
    return find.byType(T);
  }

  /// Tap widget
  static Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Enter text
  static Future<void> enterText(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Scroll to widget
  static Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 500.0);
    await tester.pump();
  }

  /// Get provider from context
  static T getProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  /// Listen to provider changes
  static T listenProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: true);
  }
}

/// Test data factories
class ProviderTestData {
  /// Create test user
  static User createTestUser({
    String id = 'test-id',
    String name = 'Test User',
    String email = 'test@example.com',
  }) {
    return User(id: UserId(id), name: name, email: Email(email));
  }

  /// Create mock app state provider
  static AppStateProvider createMockAppStateProvider({
    User? user,
    bool isLoading = false,
    String? error,
    String theme = 'light',
    String locale = 'es',
  }) {
    final provider = AppStateProvider();
    if (user != null) provider.updateUser(user);
    if (isLoading) provider.setLoading(true);
    if (error != null) provider.setError(error);
    provider.setTheme(theme);
    provider.setLocale(locale);
    return provider;
  }

  /// Create mock locale provider
  static LocaleProvider createMockLocaleProvider({String locale = 'es'}) {
    final provider = LocaleProvider();
    // Set locale if needed
    return provider;
  }

  /// Create mock theme provider
  static ThemeProvider createMockThemeProvider({String theme = 'light'}) {
    final provider = ThemeProvider();
    // Set theme if needed
    return provider;
  }
}

/// Test matchers
class ProviderTestMatchers {
  /// Matcher for provider state
  static Matcher isProviderState<T>(T expectedState) {
    return isA<T>().having((state) => state, 'state', expectedState);
  }

  /// Matcher for loading state
  static Matcher isLoadingState() {
    return isA<AppStateProvider>().having((provider) => provider.isLoading, 'isLoading', true);
  }

  /// Matcher for error state
  static Matcher hasError(String errorMessage) {
    return isA<AppStateProvider>().having((provider) => provider.error, 'error', errorMessage);
  }

  /// Matcher for authenticated state
  static Matcher isAuthenticated() {
    return isA<AppStateProvider>().having(
      (provider) => provider.isAuthenticated,
      'isAuthenticated',
      true,
    );
  }
}

/// Test extensions
extension ProviderTestExtensions on WidgetTester {
  /// Pump with duration
  Future<void> pumpWithDuration(Duration duration) async {
    await pump(duration);
  }

  /// Pump and settle
  Future<void> pumpAndSettle() async {
    await pumpAndSettle();
  }

  /// Find by key
  Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  /// Find by text
  Finder findByText(String text) {
    return find.text(text);
  }

  /// Find by type
  Finder findByType<T extends Widget>() {
    return find.byType(T);
  }

  /// Get provider from context
  T getProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  /// Listen to provider changes
  T listenProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: true);
  }
}
