import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enumeración de estados de suscripción
enum SubscriptionStatus { none, active, expired, cancelled, pending }

/// Enumeración de tipos de plan
enum SubscriptionPlanType {
  monthly('monthly', 'Mensual', 1),
  quarterly('quarterly', 'Trimestral', 3),
  biannual('biannual', 'Semestral', 6),
  annual('annual', 'Anual', 12);

  const SubscriptionPlanType(this.id, this.displayName, this.months);

  final String id;
  final String displayName;
  final int months;
}

/// Modelo de suscripción del usuario
@immutable
class UserSubscription {
  final SubscriptionPlanType planType;
  final SubscriptionStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double paidAmount;
  final String? transactionId;
  final Map<String, dynamic>? metadata;

  const UserSubscription({
    required this.planType,
    required this.status,
    this.startDate,
    this.endDate,
    this.paidAmount = 0.0,
    this.transactionId,
    this.metadata,
  });

  /// Verificar si la suscripción está activa
  bool get isActive =>
      status == SubscriptionStatus.active && endDate != null && endDate!.isAfter(DateTime.now());

  /// Días restantes de suscripción
  int get daysRemaining {
    if (endDate == null || !isActive) return 0;
    return endDate!.difference(DateTime.now()).inDays;
  }

  /// Convertir a Map para almacenamiento
  Map<String, dynamic> toJson() => {
    'planType': planType.id,
    'status': status.name,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'paidAmount': paidAmount,
    'transactionId': transactionId,
    'metadata': metadata,
  };

  /// Crear desde Map
  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      planType: SubscriptionPlanType.values.firstWhere(
        (type) => type.id == json['planType'],
        orElse: () => SubscriptionPlanType.monthly,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => SubscriptionStatus.none,
      ),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      paidAmount: (json['paidAmount'] ?? 0.0).toDouble(),
      transactionId: json['transactionId'],
      metadata: json['metadata'],
    );
  }

  UserSubscription copyWith({
    SubscriptionPlanType? planType,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    double? paidAmount,
    String? transactionId,
    Map<String, dynamic>? metadata,
  }) {
    return UserSubscription(
      planType: planType ?? this.planType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paidAmount: paidAmount ?? this.paidAmount,
      transactionId: transactionId ?? this.transactionId,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Servicio principal para gestionar suscripciones
class SubscriptionService extends ChangeNotifier {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // Estado interno
  UserSubscription? _currentSubscription;
  bool _isLoading = false;
  String? _lastError;

  // Getters públicos
  UserSubscription? get currentSubscription => _currentSubscription;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  bool get isPremiumUser => _currentSubscription?.isActive ?? false;
  SubscriptionStatus get subscriptionStatus =>
      _currentSubscription?.status ?? SubscriptionStatus.none;

  // Constantes de almacenamiento
  static const String _subscriptionKey = 'user_subscription';
  static const String _lastCheckKey = 'subscription_last_check';

  /// Inicializar el servicio
  Future<void> initialize() async {
    await _loadSubscriptionFromStorage();
    await _checkSubscriptionExpiry();
  }

  /// Cargar suscripción desde almacenamiento local
  Future<void> _loadSubscriptionFromStorage() async {
    try {
      _setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final subscriptionData = prefs.getString(_subscriptionKey);

      if (subscriptionData != null) {
        final json = jsonDecode(subscriptionData);
        _currentSubscription = UserSubscription.fromJson(json);
      }
    } catch (e, stackTrace) {
      _setError('Error cargando suscripción: $e');
      debugPrint('StackTrace: $stackTrace');
    } finally {
      _setLoading(false);
    }
  }

  /// Guardar suscripción en almacenamiento local
  Future<void> _saveSubscriptionToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentSubscription != null) {
        final json = jsonEncode(_currentSubscription!.toJson());
        await prefs.setString(_subscriptionKey, json);
      } else {
        await prefs.remove(_subscriptionKey);
      }
    } catch (e, stackTrace) {
      _setError('Error guardando suscripción: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  /// Verificar si la suscripción ha expirado
  Future<void> _checkSubscriptionExpiry() async {
    if (_currentSubscription == null) return;

    final now = DateTime.now();
    final endDate = _currentSubscription!.endDate;

    if (endDate != null && now.isAfter(endDate)) {
      // Suscripción expirada
      _currentSubscription = _currentSubscription!.copyWith(status: SubscriptionStatus.expired);
      await _saveSubscriptionToStorage();
      notifyListeners();
    }

    // Guardar timestamp de última verificación
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastCheckKey, now.millisecondsSinceEpoch);
  }

  /// Activar suscripción después de pago exitoso
  Future<void> activateSubscription({
    required SubscriptionPlanType planType,
    required double paidAmount,
    String? transactionId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final now = DateTime.now();
      final endDate = DateTime(now.year, now.month + planType.months, now.day);

      _currentSubscription = UserSubscription(
        planType: planType,
        status: SubscriptionStatus.active,
        startDate: now,
        endDate: endDate,
        paidAmount: paidAmount,
        transactionId: transactionId,
        metadata: metadata,
      );

      await _saveSubscriptionToStorage();
      notifyListeners();

      // Aquí podrías enviar datos al backend
      await _syncWithBackend();
    } catch (e, stackTrace) {
      _setError('Error activando suscripción: $e');
      debugPrint('StackTrace: $stackTrace');
    } finally {
      _setLoading(false);
    }
  }

  /// Cancelar suscripción
  Future<void> cancelSubscription() async {
    try {
      _setLoading(true);
      _clearError();

      if (_currentSubscription != null) {
        _currentSubscription = _currentSubscription!.copyWith(status: SubscriptionStatus.cancelled);
        await _saveSubscriptionToStorage();
        notifyListeners();

        // Sincronizar con backend
        await _syncWithBackend();
      }
    } catch (e, stackTrace) {
      _setError('Error cancelando suscripción: $e');
      debugPrint('StackTrace: $stackTrace');
    } finally {
      _setLoading(false);
    }
  }

  /// Verificar acceso a funcionalidad premium
  bool hasAccessToFeature(String featureId) {
    if (!isPremiumUser) return false;

    // Aquí podrías implementar lógica específica por plan
    switch (_currentSubscription!.planType) {
      case SubscriptionPlanType.monthly:
        return _basicPremiumFeatures.contains(featureId);
      case SubscriptionPlanType.quarterly:
      case SubscriptionPlanType.biannual:
        return _advancedPremiumFeatures.contains(featureId);
      case SubscriptionPlanType.annual:
        return _allPremiumFeatures.contains(featureId);
    }
  }

  /// Obtener información de límites por plan
  int getFeatureLimit(String featureId) {
    if (!isPremiumUser) return 0;

    final limits = _featureLimits[_currentSubscription!.planType] ?? {};
    return limits[featureId] ?? 0;
  }

  /// Renovar suscripción automáticamente
  Future<void> renewSubscription() async {
    if (_currentSubscription == null) return;

    try {
      _setLoading(true);

      // Aquí implementarías la lógica de renovación
      // Por ejemplo, procesar pago automático

      final now = DateTime.now();
      final newEndDate = DateTime(
        now.year,
        now.month + _currentSubscription!.planType.months,
        now.day,
      );

      _currentSubscription = _currentSubscription!.copyWith(
        status: SubscriptionStatus.active,
        endDate: newEndDate,
      );

      await _saveSubscriptionToStorage();
      notifyListeners();
    } catch (e, stackTrace) {
      _setError('Error renovando suscripción: $e');
      debugPrint('StackTrace: $stackTrace');
    } finally {
      _setLoading(false);
    }
  }

  /// Sincronizar con backend (simulado)
  Future<void> _syncWithBackend() async {
    // Aquí implementarías la sincronización real con tu backend
    // Por ejemplo: enviar estado de suscripción al servidor
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Suscripción sincronizada con backend');
  }

  /// Limpiar datos de suscripción
  Future<void> clearSubscription() async {
    _currentSubscription = null;
    await _saveSubscriptionToStorage();
    notifyListeners();
  }

  /// Métodos privados para gestión de estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _lastError = error;
    notifyListeners();
  }

  void _clearError() {
    _lastError = null;
    notifyListeners();
  }

  // Configuración de características por plan
  static const List<String> _basicPremiumFeatures = [
    'unlimited_recipes',
    'no_ads',
    'priority_support',
    'step_by_step_videos',
  ];

  static const List<String> _advancedPremiumFeatures = [
    ..._basicPremiumFeatures,
    'seasonal_recipes',
    'meal_planner',
    'nutrition_tips',
    'course_discounts',
  ];

  static const List<String> _allPremiumFeatures = [
    ..._advancedPremiumFeatures,
    'masterclasses',
    'vip_community',
    'chef_consultations',
    'spice_kit',
    'cooking_certificate',
    'lifetime_basic_access',
  ];

  static const Map<SubscriptionPlanType, Map<String, int>> _featureLimits = {
    SubscriptionPlanType.monthly: {'daily_recipes': 10, 'monthly_masterclasses': 1},
    SubscriptionPlanType.quarterly: {'daily_recipes': 25, 'monthly_masterclasses': 2},
    SubscriptionPlanType.biannual: {'daily_recipes': 50, 'monthly_masterclasses': 3},
    SubscriptionPlanType.annual: {
      'daily_recipes': -1, // ilimitado
      'monthly_masterclasses': -1, // ilimitado
    },
  };
}

/// Extension para obtener precios (esto podría venir de configuración remota)
extension SubscriptionPricing on SubscriptionPlanType {
  double get basePrice {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 29.90;
      case SubscriptionPlanType.quarterly:
        return 69.90;
      case SubscriptionPlanType.biannual:
        return 119.90;
      case SubscriptionPlanType.annual:
        return 199.90;
    }
  }

  double get originalMonthlyPrice => 29.90;

  double get monthlyPrice => basePrice / months;

  double get totalSavings => (originalMonthlyPrice * months) - basePrice;

  int get discountPercentage => ((totalSavings / (originalMonthlyPrice * months)) * 100).round();
}
