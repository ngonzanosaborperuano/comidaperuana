import 'package:flutter_test/flutter_test.dart';
import 'package:recetasperuanas/core/provider/app_state_provider.dart';

import '../../helpers/provider_test_helpers.dart' show ProviderTestData;

void main() {
  group('AppStateProvider Tests', () {
    late AppStateProvider provider;

    setUp(() {
      provider = AppStateProvider();
    });

    test('should initialize with default values', () {
      expect(provider.currentUser, isNull);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.theme, equals('light'));
      expect(provider.locale, equals('es'));
      expect(provider.isAuthenticated, isFalse);
    });

    test('should update user correctly', () {
      // Arrange
      final user = ProviderTestData.createTestUser();

      // Act
      provider.updateUser(user);

      // Assert
      expect(provider.currentUser, equals(user));
      expect(provider.isAuthenticated, isTrue);
    });

    test('should set loading state', () {
      // Act
      provider.setLoading(true);

      // Assert
      expect(provider.isLoading, isTrue);

      // Act
      provider.setLoading(false);

      // Assert
      expect(provider.isLoading, isFalse);
    });

    test('should set and clear error', () {
      // Act
      provider.setError('Test error');

      // Assert
      expect(provider.error, equals('Test error'));

      // Act
      provider.clearError();

      // Assert
      expect(provider.error, isNull);
    });

    test('should toggle theme', () {
      // Initial state
      expect(provider.theme, equals('light'));

      // Act
      provider.toggleTheme();

      // Assert
      expect(provider.theme, equals('dark'));

      // Act
      provider.toggleTheme();

      // Assert
      expect(provider.theme, equals('light'));
    });

    test('should set theme', () {
      // Act
      provider.setTheme('dark');

      // Assert
      expect(provider.theme, equals('dark'));
    });

    test('should set locale', () {
      // Act
      provider.setLocale('en');

      // Assert
      expect(provider.locale, equals('en'));
    });

    test('should logout correctly', () {
      // Arrange
      final user = ProviderTestData.createTestUser();
      provider.updateUser(user);
      provider.setError('Some error');

      // Act
      provider.logout();

      // Assert
      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.error, isNull);
    });

    test('should reset state', () {
      // Arrange
      final user = ProviderTestData.createTestUser();
      provider.updateUser(user);
      provider.setLoading(true);
      provider.setError('Some error');
      provider.setTheme('dark');
      provider.setLocale('en');

      // Act
      provider.reset();

      // Assert
      expect(provider.currentUser, isNull);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.isAuthenticated, isFalse);
      // Theme and locale should remain unchanged as they are preferences
      expect(provider.theme, equals('dark'));
      expect(provider.locale, equals('en'));
    });
  });
}
