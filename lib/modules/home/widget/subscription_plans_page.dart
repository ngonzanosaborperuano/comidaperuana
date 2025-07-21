import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';
import 'package:recetasperuanas/core/services/subscription_service.dart' show SubscriptionPlanType;
import 'package:recetasperuanas/modules/home/models/subscription_plan.dart'
    show SubscriptionPlan, SubscriptionPlans;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

import 'payu_checkout_webview.dart';

class SubscriptionPlansPage extends StatefulWidget {
  final String? userEmail;
  final String? userName;
  final VoidCallback? onSubscriptionSelected;

  const SubscriptionPlansPage({
    super.key,
    this.userEmail,
    this.userName,
    this.onSubscriptionSelected,
  });

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  SubscriptionPlan? selectedPlan;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.color.background),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(
                    children: [
                      _buildDescriptionBanner(),
                      AppVerticalSpace.xmd,
                      ...SubscriptionPlans.available.map(
                        (plan) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildPlanCard(plan),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kTextTabBarHeight),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.color.background.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: context.pop,
                  icon: Icon(Icons.arrow_back_ios_new, color: context.color.text, size: 20),
                  style: IconButton.styleFrom(padding: const EdgeInsets.all(12)),
                ),
              ),
              Expanded(
                child: Text(
                  'Planes Premium',
                  style: AppStyles.h1.copyWith(color: context.color.text),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 56),
            ],
          ),
          AppVerticalSpace.xmd,
        ],
      ),
    );
  }

  Widget _buildDescriptionBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: context.color.backgroundCard,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: context.color.textSecondary.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: context.color.textSecondary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.color.buttonPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.flag, color: context.color.buttonPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Descubre los secretos de la cocina peruana',
              style: TextStyle(
                color: context.color.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isSelected = selectedPlan?.id == plan.id;

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = plan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: context.color.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? context.color.buttonPrimary : context.color.border,
            width: isSelected ? 2.5 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? context.color.buttonPrimary.withValues(alpha: 0.3)
                      : context.color.textSecondary.withValues(alpha: 0.2),
              blurRadius: isSelected ? 16 : 12,
              offset: Offset(0, isSelected ? 8 : 4),
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: context.color.text,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plan.description,
                              style: TextStyle(
                                fontSize: 15,
                                color: context.color.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Precios con mejor jerarquía
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'S/ ${plan.monthlyPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: context.color.buttonPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '/mes',
                        style: TextStyle(
                          fontSize: 18,
                          color: context.color.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (plan.discountPercentage > 0) ...[
                        const SizedBox(width: 16),
                        Text(
                          'S/ ${plan.originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            color: context.color.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (plan.discountPercentage > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.color.buttonPrimary,
                            context.color.buttonPrimary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: context.color.buttonPrimary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: context.color.background,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Ahorra ${plan.discountPercentage}% • S/ ${plan.totalSavings.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: context.color.background,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Características con mejor diseño
                  ...plan.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: context.color.buttonPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: context.color.buttonPrimary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                fontSize: 15,
                                color: context.color.text,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Etiquetas especiales con mejor diseño
            if (plan.isPopular)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.color.buttonPrimary,
                        context.color.buttonPrimary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: context.color.buttonPrimary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department, color: context.color.background, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'MÁS POPULAR',
                        style: TextStyle(
                          color: context.color.background,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (plan.isBestValue)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [context.color.success, context.color.success.withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: context.color.success.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.diamond, color: context.color.background, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'MEJOR VALOR',
                        style: TextStyle(
                          color: context.color.background,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.color.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.color.textSecondary.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.color.textSecondary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.color.buttonPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.security, color: context.color.buttonPrimary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pago 100% seguro',
                        style: TextStyle(
                          color: context.color.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Cancela cuando quieras',
                        style: TextStyle(
                          color: context.color.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppVerticalSpace.xmd,
          AppButton(
            text:
                selectedPlan != null ? 'Continuar con ${selectedPlan!.name}' : 'Selecciona un plan',
            onPressed: selectedPlan != null ? _handleSubscription : null,
            enabledButton: selectedPlan != null,
            showIcon: selectedPlan != null,
            iconWidget: selectedPlan != null ? const Icon(Icons.arrow_forward) : null,
            iconAtStart: false,
          ),

          AppVerticalSpace.sm,

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Al continuar aceptas nuestros Términos y Condiciones',
              style: TextStyle(
                color: context.color.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscription() {
    if (selectedPlan == null) return;

    // Confirmar antes de proceder al pago
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.payment, color: context.color.buttonPrimary),
                const SizedBox(width: 8),
                const Text('Confirmar Suscripción'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plan: ${selectedPlan!.name}'),
                Text(
                  'Duración: ${selectedPlan!.durationMonths} mes${selectedPlan!.durationMonths > 1 ? 'es' : ''}',
                ),
                Text('Precio mensual: S/ ${selectedPlan!.monthlyPrice.toStringAsFixed(2)}'),
                Text(
                  'Total a pagar: S/ ${selectedPlan!.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (selectedPlan!.discountPercentage > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.color.buttonPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '🎉 Ahorras ${selectedPlan!.discountPercentage}% (S/ ${selectedPlan!.totalSavings.toStringAsFixed(2)})',
                      style: TextStyle(
                        color: context.color.buttonPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.security, color: context.color.buttonPrimary, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pago seguro con PayU',
                        style: TextStyle(fontSize: 12, color: context.color.buttonPrimary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _proceedToPayment();
                },
                icon: const Icon(Icons.payment),
                label: const Text('Pagar Ahora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.color.buttonPrimary,
                  foregroundColor: context.color.background,
                ),
              ),
            ],
          ),
    );
  }

  void _proceedToPayment() {
    // Usar el checkout de PayU
    showPayUCheckout(
      context,
      planType: _getPlanType(selectedPlan!.id),
      userEmail: widget.userEmail ?? 'usuario@ejemplo.com',
      userName: widget.userName ?? 'Usuario',
      onSuccess: () {
        widget.onSubscriptionSelected?.call();

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Suscripción ${selectedPlan!.name} activada!'),
            backgroundColor: context.color.success,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      onFailure: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error en el pago. Inténtalo de nuevo.'),
            backgroundColor: context.color.error,
          ),
        );
      },
    );
  }

  SubscriptionPlanType _getPlanType(String planId) {
    switch (planId) {
      case 'monthly':
        return SubscriptionPlanType.monthly;
      case 'quarterly':
        return SubscriptionPlanType.quarterly;
      case 'biannual':
        return SubscriptionPlanType.biannual;
      case 'annual':
        return SubscriptionPlanType.annual;
      default:
        return SubscriptionPlanType.monthly;
    }
  }
}

// Widget de botón para suscripciones
class SubscriptionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const SubscriptionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.star),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? context.color.buttonPrimary,
        foregroundColor: textColor ?? context.color.background,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}

// Función para mostrar modal de suscripciones
void showSubscriptionModal(BuildContext context, {VoidCallback? onSelected}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SubscriptionPlansPage(onSubscriptionSelected: onSelected),
  );
}

// Mixin para integración fácil de suscripciones
mixin SubscriptionMixin {
  // Navegar a planes
  void navigateToSubscriptionPlans(BuildContext context, {VoidCallback? onSelected}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionPlansPage(onSubscriptionSelected: onSelected),
      ),
    );
  }

  // Mostrar modal
  void showSubscriptionModal(BuildContext context, {VoidCallback? onSelected}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SubscriptionPlansPage(onSubscriptionSelected: onSelected),
    );
  }
}
