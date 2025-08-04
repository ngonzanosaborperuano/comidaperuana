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
  int get discountPercentage =>
      ((totalSavings / (originalPrice * durationMonths)) * 100).round();
}

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
