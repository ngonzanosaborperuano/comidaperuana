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
  SubscriptionPlan? selectedPlan;
  late AnimationController _animationController;
  late AnimationController _shimmerAnimation;
  late AnimationController _selectionAnimation;
  late AnimationController _pulseAnimation;
  late AnimationController _rippleAnimation;

  // Animaciones para efectos de selección
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _pulseScaleAnimation;
  late Animation<double> _rippleScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shimmerAnimation = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _selectionAnimation = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseAnimation = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _rippleAnimation = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animationController.forward();
    _shimmerAnimation.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _selectionAnimation, curve: Curves.elasticOut));

    _borderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _selectionAnimation, curve: Curves.easeInOut));

    _backgroundColorAnimation = ColorTween(
      begin: context.color.background,
      end: context.color.background.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(parent: _selectionAnimation, curve: Curves.easeInOut));

    _pulseScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _pulseAnimation, curve: Curves.easeInOut));

    _rippleScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _rippleAnimation, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerAnimation.dispose();
    _selectionAnimation.dispose();
    _pulseAnimation.dispose();
    _rippleAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.background,
        borderRadius: BorderRadiusDirectional.circular(40),
      ),
      child: Column(
        children: [
          HeaderPlanes(context: context),
          Expanded(
            child: PlanesPremiumListWidget(
              buildPlanCard:
                  (plan) => PlanCardWidget(
                    plan: plan,
                    isSelected: selectedPlan?.id == plan.id,
                    onTap: () => _selectPlan(plan),
                    selectionAnimation: _selectionAnimation,
                    pulseAnimation: _pulseAnimation,
                    rippleAnimation: _rippleAnimation,
                    scaleAnimation: _scaleAnimation,
                    borderAnimation: _borderAnimation,
                    backgroundColorAnimation: _backgroundColorAnimation,
                    pulseScaleAnimation: _pulseScaleAnimation,
                    rippleScaleAnimation: _rippleScaleAnimation,
                  ),
              context: context,
            ),
          ),
          BottomSectionWidget(
            selectedPlan: selectedPlan,
            onContinue: selectedPlan != null ? _handleSubscription : null,
            context: context,
          ),
        ],
      ),
    );
  }

  void _selectPlan(SubscriptionPlan plan) {
    if (selectedPlan?.id == plan.id) {
      setState(() {
        selectedPlan = null;
      });
      return;
    }

    setState(() {
      selectedPlan = plan;
    });
    _playSelectionAnimation();
  }

  void _playSelectionAnimation() {
    // 1. Animación de selección principal
    _selectionAnimation.forward().then((_) {
      // 2. Animación de pulso
      _pulseAnimation.forward().then((_) {
        _pulseAnimation.reverse();
      });

      // 3. Animación de ripple
      _rippleAnimation.forward().then((_) {
        _rippleAnimation.reset();
      });
    });

    // Resetear animación de selección después de un delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _selectionAnimation.reverse();
      }
    });
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
      planType: getPlanType(selectedPlan!.id),
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

  SubscriptionPlanType getPlanType(String planId) {
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

class DescriptionBanner extends StatelessWidget {
  const DescriptionBanner({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
}

class HeaderPlanes extends StatelessWidget {
  const HeaderPlanes({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
}

class PagoSeguro extends StatelessWidget {
  const PagoSeguro({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.color.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.color.buttonPrimary.withValues(alpha: 0.2), width: 1),
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
    );
  }
}

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

void showSubscriptionModal(BuildContext context, {VoidCallback? onSelected}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SubscriptionPlansPage(onSubscriptionSelected: onSelected),
  );
}

class PlanesPremiumListWidget extends StatelessWidget {
  final Widget Function(SubscriptionPlan) buildPlanCard;
  final BuildContext context;

  const PlanesPremiumListWidget({super.key, required this.buildPlanCard, required this.context});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        children: [
          DescriptionBanner(context: this.context),
          AppVerticalSpace.xmd,
          ...SubscriptionPlans.available.map(
            (plan) =>
                Padding(padding: const EdgeInsets.only(bottom: 30), child: buildPlanCard(plan)),
          ),
        ],
      ),
    );
  }
}

class PlanCardWidget extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;
  final Animation<double> selectionAnimation;
  final Animation<double> pulseAnimation;
  final Animation<double> rippleAnimation;
  final Animation<double> scaleAnimation;
  final Animation<double> borderAnimation;
  final Animation<Color?> backgroundColorAnimation;
  final Animation<double> pulseScaleAnimation;
  final Animation<double> rippleScaleAnimation;

  const PlanCardWidget({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
    required this.selectionAnimation,
    required this.pulseAnimation,
    required this.rippleAnimation,
    required this.scaleAnimation,
    required this.borderAnimation,
    required this.backgroundColorAnimation,
    required this.pulseScaleAnimation,
    required this.rippleScaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: isSelected ? selectionAnimation : const AlwaysStoppedAnimation(0.0),
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? scaleAnimation.value : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? backgroundColorAnimation.value : context.color.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected
                              ? context.color.buttonPrimary.withValues(
                                alpha: 0.6 * borderAnimation.value,
                              )
                              : context.color.textSecondary.withValues(alpha: 0.2),
                      width: isSelected ? 3.0 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isSelected
                                ? context.color.buttonPrimary.withValues(alpha: 0.5)
                                : context.color.textSecondary.withValues(alpha: 0.2),
                        blurRadius: isSelected ? 20 : 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PlanContentWidget(plan: plan),
                ),
              );
            },
          ),
          if (isSelected)
            AnimatedBuilder(
              animation: pulseAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.color.buttonPrimary.withValues(
                          alpha: 0.3 * (1 - pulseAnimation.value),
                        ),
                        width: 2.0 * pulseScaleAnimation.value,
                      ),
                    ),
                  ),
                );
              },
            ),
          if (isSelected)
            AnimatedBuilder(
              animation: rippleAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.color.buttonPrimary.withValues(
                          alpha: 0.2 * (1 - rippleAnimation.value),
                        ),
                        width: 1.0,
                      ),
                    ),
                    transform: Matrix4.identity()..scale(rippleScaleAnimation.value),
                  ),
                );
              },
            ),
          if (plan.isBestValue || plan.isPopular)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      plan.isBestValue
                          ? Colors.green.withValues(alpha: 0.9)
                          : context.color.buttonPrimary.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      plan.isBestValue ? Icons.diamond : Icons.local_fire_department,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      plan.isBestValue ? 'MEJOR VALOR' : 'POPULAR',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PlanContentWidget extends StatelessWidget {
  final SubscriptionPlan plan;
  const PlanContentWidget({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
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
            ],
          ),
          const SizedBox(height: 24),
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
                  Icon(Icons.local_fire_department, color: context.color.background, size: 16),
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
                    child: Icon(Icons.check_circle, color: context.color.buttonPrimary, size: 18),
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
    );
  }
}

class BottomSectionWidget extends StatelessWidget {
  final SubscriptionPlan? selectedPlan;
  final VoidCallback? onContinue;
  final BuildContext context;

  const BottomSectionWidget({
    super.key,
    required this.selectedPlan,
    required this.onContinue,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
      decoration: BoxDecoration(
        color: context.color.backgroundCard,
        border: Border.all(color: context.color.textSecondary.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          PagoSeguro(context: this.context),
          AppVerticalSpace.sm,
          AppButton(
            text:
                selectedPlan != null ? 'Continuar con ${selectedPlan!.name}' : 'Selecciona un plan',
            onPressed: onContinue,
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
}
