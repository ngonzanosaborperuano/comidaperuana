import 'package:flutter/material.dart';

import '../../../core/services/subscription_service.dart';
import 'payu_checkout_webview.dart';

// Modelo de plan de suscripción
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double monthlyPrice;
  final double originalPrice;
  final int durationMonths;
  final bool isPopular;
  final bool isBestValue;
  final List<String> features;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.originalPrice,
    required this.durationMonths,
    this.isPopular = false,
    this.isBestValue = false,
    required this.features,
  });

  double get totalPrice => monthlyPrice * durationMonths;
  double get totalSavings => (originalPrice * durationMonths) - totalPrice;
  int get discountPercentage => ((totalSavings / (originalPrice * durationMonths)) * 100).round();
}

// Planes de suscripción disponibles
class SubscriptionPlans {
  static const List<SubscriptionPlan> available = [
    SubscriptionPlan(
      id: 'monthly',
      name: 'Mensual',
      description: 'Acceso completo por 1 mes',
      monthlyPrice: 29.90,
      originalPrice: 29.90,
      durationMonths: 1,
      features: [
        'Recetas premium ilimitadas',
        'Técnicas de cocina exclusivas',
        'Videos paso a paso',
        'Lista de compras inteligente',
        'Soporte prioritario',
      ],
    ),
    SubscriptionPlan(
      id: 'quarterly',
      name: 'Trimestral',
      description: '¡Más Popular! - 3 meses',
      monthlyPrice: 23.30,
      originalPrice: 29.90,
      durationMonths: 3,
      isPopular: true,
      features: [
        'Todo lo del plan mensual',
        'Recetas de temporada exclusivas',
        'Planificador de menús',
        'Consejos nutricionales',
        'Descuentos en cursos',
      ],
    ),
    SubscriptionPlan(
      id: 'biannual',
      name: 'Semestral',
      description: 'Ahorra más - 6 meses',
      monthlyPrice: 19.98,
      originalPrice: 29.90,
      durationMonths: 6,
      features: [
        'Todo lo del plan trimestral',
        'Acceso a masterclasses',
        'Comunidad VIP de cocina',
        'Calendario gastronómico',
        'Libro digital de recetas',
      ],
    ),
    SubscriptionPlan(
      id: 'annual',
      name: 'Anual',
      description: '¡Mejor Valor! - 12 meses',
      monthlyPrice: 16.66,
      originalPrice: 29.90,
      durationMonths: 12,
      isBestValue: true,
      features: [
        'Todo lo de planes anteriores',
        'Consultas con chef profesional',
        'Kit de especias peruanas',
        'Certificado de cocina peruana',
        'Acceso de por vida a contenido básico',
      ],
    ),
  ];
}

// Página principal de planes de suscripción
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFF388E3C), Color(0xFF4CAF50)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [_buildHeader(), Expanded(child: _buildPlansList()), _buildBottomSection()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Expanded(
                child: Text(
                  'Planes Premium',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '🇵🇪 Descubre los secretos de la cocina peruana',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: SubscriptionPlans.available.length,
      itemBuilder: (context, index) {
        final plan = SubscriptionPlans.available[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildPlanCard(plan),
        );
      },
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isSelected = selectedPlan?.id == plan.id;

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = plan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.orange : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
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
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              plan.description,
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Precios
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'S/ ${plan.monthlyPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const Text('/mes', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      if (plan.discountPercentage > 0) ...[
                        const SizedBox(width: 12),
                        Text(
                          'S/ ${plan.originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (plan.discountPercentage > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Ahorra ${plan.discountPercentage}% • S/ ${plan.totalSavings.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Características
                  ...plan.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(feature, style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Etiquetas especiales
            if (plan.isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '🔥 MÁS POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            if (plan.isBestValue)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '💎 MEJOR VALOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Información de seguridad
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.security, color: Colors.white70, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '🔒 Pago 100% seguro\n✅ Cancela cuando quieras',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Botón de continuar
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selectedPlan != null ? _handleSubscription : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 8,
              ),
              child: Text(
                selectedPlan != null ? 'Continuar con ${selectedPlan!.name}' : 'Selecciona un plan',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Términos y condiciones
          const Text(
            'Al continuar aceptas nuestros Términos y Condiciones',
            style: TextStyle(color: Colors.white60, fontSize: 12),
            textAlign: TextAlign.center,
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
            title: const Row(
              children: [
                Icon(Icons.payment, color: Colors.green),
                SizedBox(width: 8),
                Text('Confirmar Suscripción'),
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
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '🎉 Ahorras ${selectedPlan!.discountPercentage}% (S/ ${selectedPlan!.totalSavings.toStringAsFixed(2)})',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.security, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pago seguro con PayU',
                        style: TextStyle(fontSize: 12, color: Colors.green),
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
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
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
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      onFailure: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error en el pago. Inténtalo de nuevo.'),
            backgroundColor: Colors.red,
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
        backgroundColor: backgroundColor ?? const Color(0xFF2E7D32),
        foregroundColor: textColor ?? Colors.white,
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
    builder:
        (context) => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SubscriptionPlansPage(onSubscriptionSelected: onSelected),
          ),
        ),
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
  void showSubscriptionDialog(BuildContext context, {VoidCallback? onSelected}) {
    showSubscriptionModal(context, onSelected: onSelected);
  }

  // Banner de suscripción
  Widget buildSubscriptionBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hazte Premium!',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Accede a recetas exclusivas',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => navigateToSubscriptionPlans(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Ver Planes'),
          ),
        ],
      ),
    );
  }
}
