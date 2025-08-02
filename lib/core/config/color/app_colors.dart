import 'package:flutter/material.dart';

/// Clase que define la paleta de colores utilizada en la aplicación.
class AppColors {
  static const MaterialColor primary1 = MaterialColor(0xFFff6b35, <int, Color>{});

  static const MaterialColor background = MaterialColor(0xFFffffff, <int, Color>{});
  static const MaterialColor backgroundDark = MaterialColor(0xFF0d1116, <int, Color>{});

  static const MaterialColor backgroundCard = MaterialColor(0xFFF1F5F9, <int, Color>{});
  static const MaterialColor backgroundCardDark = MaterialColor(0xFF161b22, <int, Color>{});

  static const Color text = MaterialColor(0xFF10181c, <int, Color>{});
  static const Color textDark = MaterialColor(0xFFecedee, <int, Color>{});

  static const MaterialColor text2 = MaterialColor(0xFFa1a1aa, <int, Color>{});

  static const MaterialColor error = MaterialColor(0xFFf31a65, <int, Color>{});
  static const MaterialColor errorText = MaterialColor(0xFFF7B7CD, <int, Color>{});

  static const MaterialColor icon = MaterialColor(0xFF71717a, <int, Color>{});

  static const MaterialColor textSecondary = MaterialColor(0xFFff6b35, <int, Color>{});
  static const MaterialColor textSecondaryDark = MaterialColor(0xFFfe9e76, <int, Color>{});

  /// Rojo oscuro utilizado para advertencias y errores.
  static const MaterialColor secondaryBlackRed = MaterialColor(0xFF92400E, <int, Color>{});

  /// Marrón oscuro utilizado para elementos complementarios.
  static const MaterialColor brownDark = MaterialColor(0xFFB45309, <int, Color>{});

  /// Amarillo naranja utilizado para destacar elementos.
  static const MaterialColor yellowOrange = MaterialColor(0xFFF59E0B, <int, Color>{});

  /// Amarillo claro utilizado para fondos suaves.
  static const MaterialColor yellowLight = MaterialColor(0xFFFEF3C7, <int, Color>{});

  /// Gris azulado medio utilizado para elementos secundarios.
  static const MaterialColor slate500 = MaterialColor(0xFF64748B, <int, Color>{});

  /// Gris oscuro utilizado para fondos y texto.
  static const MaterialColor slate700 = MaterialColor(0xFF334155, <int, Color>{});

  // Colores de PayU
  static const MaterialColor payuGreen = MaterialColor(0xFF00A650, <int, Color>{});
  static const MaterialColor payuOrange = MaterialColor(0xFFFF6B35, <int, Color>{});
  static const MaterialColor payuDarkGray = MaterialColor(0xFF2C3E50, <int, Color>{});

  static const MaterialColor payuGreenDark = MaterialColor(0xFF064E3B, <int, Color>{});
  static const MaterialColor payuGreenLight = MaterialColor(0xFFA7F3D0, <int, Color>{});

  static const MaterialColor white = MaterialColor(0xFFFFFFFF, <int, Color>{});

  static const MaterialColor slate800 = MaterialColor(0xFF1E293B, <int, Color>{});

  static const MaterialColor emerald700 = MaterialColor(0xFF047857, <int, Color>{});

  static const MaterialColor amber50 = MaterialColor(0xFFFFFBEB, <int, Color>{});

  static const MaterialColor emerald800 = MaterialColor(0xFF065F46, <int, Color>{});

  static const MaterialColor emerald600 = MaterialColor(0xFF166534, <int, Color>{});

  static const MaterialColor amber700 = MaterialColor(0xFF854D0E, <int, Color>{});

  static const MaterialColor red700 = MaterialColor(0xFF991B1B, <int, Color>{});

  static const MaterialColor rose700 = MaterialColor(0xFF9F1239, <int, Color>{});

  static const MaterialColor emerald50 = MaterialColor(0xFFDCFCE7, <int, Color>{});

  static const MaterialColor slate25 = MaterialColor(0xFFF8FAFC, <int, Color>{});

  static const MaterialColor red50 = MaterialColor(0xFFFEE2E2, <int, Color>{});

  static const MaterialColor yellow100 = MaterialColor(0xFFFEF9C3, <int, Color>{});

  static const MaterialColor rose50 = MaterialColor(0xFFFFE4E6, <int, Color>{});

  // === COLORES PARA MODO DARK ===

  static const MaterialColor yellow400 = MaterialColor(0xFFFBBF24, <int, Color>{});

  static const MaterialColor yellow200 = MaterialColor(0xFFFDE68A, <int, Color>{});

  static const MaterialColor slate200 = MaterialColor(0xFFE2E8F0, <int, Color>{});

  static const MaterialColor slate300 = MaterialColor(0xFFCBD5E1, <int, Color>{});

  static const MaterialColor slate400 = MaterialColor(0xFF94A3B8, <int, Color>{});

  static const MaterialColor emerald200 = MaterialColor(0xFFA7F3D0, <int, Color>{});

  static const MaterialColor emerald900 = MaterialColor(0xFF064E3B, <int, Color>{});

  static const MaterialColor amber900 = MaterialColor(0xFF78350F, <int, Color>{});

  static const MaterialColor slate900 = MaterialColor(0xFF0F172A, <int, Color>{});

  static const MaterialColor red800 = MaterialColor(0xFF7F1D1D, <int, Color>{});

  // === COLORES DE DIFICULTAD ===

  // Fácil - Verde
  static const Color difficultyEasyTextLight = Color(0xFF2E7D32);
  static const Color difficultyEasyBackgroundLight = Color(0xFFE8F5E8);
  static const Color difficultyEasyTextDark = Color(0xFF81C784);
  static const Color difficultyEasyBackgroundDark = Color.fromARGB(102, 46, 125, 50);

  // Media - Naranja/Marrón
  static const Color difficultyMediumTextLight = Color(0xFFE65100);
  static const Color difficultyMediumBackgroundLight = Color(0xFFFFF3E0);
  static const Color difficultyMediumTextDark = Color(0xFFFFB74D);
  static const Color difficultyMediumBackgroundDark = Color.fromARGB(186, 93, 64, 55);

  // Difícil - Rosa/Rojo
  static const Color difficultyHardTextLight = Color(0xFFC2185B);
  static const Color difficultyHardBackgroundLight = Color(0xFFFCE4EC);
  static const Color difficultyHardTextDark = Color(0xFFFF69B4);
  static const Color difficultyHardBackgroundDark = Color.fromARGB(205, 74, 44, 58);

  // === COLORES DE ETIQUETAS ===

  // Etiquetas - Gris neutro
  static const Color labelTextLight = Color(0xFF6B7280);
  static const Color labelBackgroundLight = Color(0xFFF3F4F6);
  static const Color labelTextDark = Color(0xFFD1D5DB);
  static const Color labelBackgroundDark = Color(0xFF374151);

  // === GRADIENTES LINEALES ===

  static const LinearGradient darkModeLinear = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF334155), // slate700
      Color(0xFF0F172A), // slate900
    ],
    stops: [0.0, 1.0],
  );

  static const LinearGradient warmLinear = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFBBF24), // yellow400
      Color(0xFF78350F), // amber900
    ],
    stops: [0.0, 1.0],
  );

  static const LinearGradient successLinear = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [payuGreenDark, payuGreenLight],
    stops: [0.0, 1.0],
  );

  static const LinearGradient orangeToBrownLinear = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF59E0B), // yellowOrange
      Color(0xFFB45309), // brownDark
    ],
    stops: [0.0, 1.0],
  );

  static const MaterialColor transparent = MaterialColor(0x00FFFFFF, <int, Color>{});
}
