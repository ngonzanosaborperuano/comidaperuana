import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recetasperuanas/l10n/app_localizations.dart';

// Mock de AppLocalizations
class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get validateEmpty => 'El campo no puede estar vacío';

  @override
  String get minEightCharacters =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get labelUpper => 'Debe contener al menos una letra mayúscula';

  @override
  String get labelLower => 'Debe contener al menos una letra minúscula';

  @override
  String get anyNumber => 'Debe contener al menos un número';

  @override
  String get specialCharacter => 'Debe contener al menos un carácter especial';

  @override
  String get invalidPassword => 'Contraseña no válida';

  @override
  String get validateEmail => 'Correo electrónico inválido';

  @override
  String get validateList => 'La lista no puede estar vacía';
}

// Mock de BuildContext
class MockBuildContext extends Mock implements BuildContext {
  AppLocalizations get loc => MockAppLocalizations();
}

void main() {
  group('BaseController Test', () {
    late BaseController controller;
    late BuildContext context;

    setUp(() {
      // Inicializar los mocks

      controller = BaseController();

      // Configuración de BuildContext para devolver AppLocalizations mockeado
      context = MockBuildContext();

      // Inicializar el controller con el contexto mockeado
      controller.init(context);
    });

    test('Validación de campo vacío', () {
      final result = controller.validateEmpty('', context);
      expect(result, 'El campo no puede estar vacío');
    });

    test('Validación de contraseña con error', () {
      final result = controller.validatePassword('1234', context);
      expect(
        result,
        'Contraseña no válida:\nLa contraseña debe tener al menos 8 caracteres.\nDebe contener al menos una letra mayúscula.\nDebe contener al menos una letra minúscula.\nDebe contener al menos un número.\nDebe contener al menos un carácter especial',
      );
    });

    test('Validación de contraseña válida', () {
      final result = controller.validatePassword('Password123!', context);
      expect(result, null); // La contraseña es válida
    });

    test('Validación de lista vacía', () {
      final result = controller.validateList([], context);
      expect(result, 'La lista no puede estar vacía');
    });

    test('Validación de correo electrónico inválido', () {
      final result = controller.validateEmail('invalid-email', context);
      expect(result, 'Correo electrónico inválido');
    });

    test('Validación de correo electrónico válido', () {
      final result = controller.validateEmail('test@example.com', context);
      expect(result, null); // El correo electrónico es válido
    });

    test('Mostrar error en el log', () {
      controller.addError('Test error');
      // Aquí puedes verificar si el logger ha registrado el error, si es necesario.
    });
  });
}
