import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/subscription_service.dart';
import 'subscription_plans_page.dart';

/// Ejemplos prácticos del nuevo sistema de suscripciones
class SubscriptionUsageExamples extends StatelessWidget {
  const SubscriptionUsageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Suscripciones'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildStatusCard(context),
            const SizedBox(height: 24),
            _buildExampleButtons(context),
            const SizedBox(height: 24),
            _buildIntegrationExamples(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Color(0xFF2E7D32), size: 28),
                SizedBox(width: 8),
                Text(
                  'Sistema de Suscripciones Modernizado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '✅ Sin dependencias específicas de PayU\n'
              '✅ Arquitectura moderna con Provider/ChangeNotifier\n'
              '✅ Almacenamiento local persistente\n'
              '✅ Gestión automática de expiración\n'
              '✅ Sistema de características por plan\n'
              '✅ UI completamente personalizable',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Consumer<SubscriptionService>(
      builder: (context, subscriptionService, child) {
        final subscription = subscriptionService.currentSubscription;
        final isPremium = subscriptionService.isPremiumUser;

        return Card(
          color: isPremium ? Colors.green[50] : Colors.orange[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isPremium ? Icons.verified : Icons.info,
                      color: isPremium ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPremium ? 'Usuario Premium' : 'Usuario Gratuito',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (subscription != null) ...[
                  Text('Plan: ${subscription.planType.displayName}'),
                  Text('Estado: ${subscription.status.name}'),
                  if (subscription.endDate != null)
                    Text('Expira: ${subscription.endDate!.toLocal().toString().split(' ')[0]}'),
                  if (subscription.daysRemaining > 0)
                    Text('Días restantes: ${subscription.daysRemaining}'),
                ] else
                  const Text('No tienes una suscripción activa'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExampleButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ejemplos de Uso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // Botón básico
        SizedBox(
          width: double.infinity,
          child: SubscriptionButton(
            text: 'Ver Planes Premium',
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubscriptionPlansPage()),
                ),
          ),
        ),

        const SizedBox(height: 12),

        // Botón personalizado
        SizedBox(
          width: double.infinity,
          child: SubscriptionButton(
            text: '⭐ Acceso VIP',
            icon: Icons.diamond,
            backgroundColor: Colors.purple,
            onPressed: () => showSubscriptionModal(context),
          ),
        ),

        const SizedBox(height: 12),

        // Botón con verificación de estado
        Consumer<SubscriptionService>(
          builder: (context, service, child) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    service.isPremiumUser
                        ? () => _showPremiumFeatures(context)
                        : () => showSubscriptionModal(context),
                icon: Icon(service.isPremiumUser ? Icons.star : Icons.star_outline),
                label: Text(
                  service.isPremiumUser ? 'Características Premium' : 'Desbloquear Premium',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: service.isPremiumUser ? Colors.green : Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIntegrationExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Integración con Mixin',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Usando SubscriptionMixin:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• navigateToSubscriptionPlans(context)\n'
                  '• showSubscriptionDialog(context)\n'
                  '• buildSubscriptionBanner(context)',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExamplePageWithMixin()),
                      ),
                  child: const Text('Ver Ejemplo con Mixin'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPremiumFeatures(BuildContext context) {
    final service = SubscriptionService();

    // Obtener características basadas en el plan
    List<String> features;
    if (service.currentSubscription?.planType == SubscriptionPlanType.monthly) {
      features = ['Recetas ilimitadas', 'Sin anuncios', 'Videos paso a paso'];
    } else if (service.currentSubscription?.planType == SubscriptionPlanType.quarterly) {
      features = ['Todo lo anterior', 'Recetas de temporada', 'Planificador'];
    } else {
      features = ['Todas las características', 'Masterclasses', 'Comunidad VIP'];
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('🌟 Características Premium'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plan: ${service.currentSubscription?.planType.displayName ?? 'N/A'}'),
                const SizedBox(height: 16),
                const Text('Características disponibles:'),
                const SizedBox(height: 8),
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
            ],
          ),
    );
  }
}

/// Ejemplo de página que usa SubscriptionMixin
class ExamplePageWithMixin extends StatelessWidget with SubscriptionMixin {
  const ExamplePageWithMixin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo con Mixin'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Consumer<SubscriptionService>(
        builder: (context, service, child) {
          return Column(
            children: [
              // Banner de suscripción (solo si no es premium)
              if (!service.isPremiumUser) buildSubscriptionBanner(context),

              // Contenido principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Métodos disponibles del Mixin:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      _buildMethodExample(
                        'navigateToSubscriptionPlans()',
                        'Navega a la página de planes',
                        () => navigateToSubscriptionPlans(context),
                      ),

                      _buildMethodExample(
                        'showSubscriptionDialog()',
                        'Muestra modal desde abajo',
                        () => showSubscriptionDialog(context),
                      ),

                      const SizedBox(height: 16),

                      // Verificación de características
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Verificación de Características:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              _buildFeatureCheck(service, 'unlimited_recipes'),
                              _buildFeatureCheck(service, 'masterclasses'),
                              _buildFeatureCheck(service, 'chef_consultations'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMethodExample(String method, String description, VoidCallback onTap) {
    return Card(
      child: ListTile(
        title: Text(method, style: const TextStyle(fontFamily: 'monospace')),
        subtitle: Text(description),
        trailing: const Icon(Icons.play_arrow),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFeatureCheck(SubscriptionService service, String featureId) {
    final hasAccess = service.hasAccessToFeature(featureId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            hasAccess ? Icons.check_circle : Icons.cancel,
            color: hasAccess ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text('$featureId: ${hasAccess ? "Disponible" : "Bloqueado"}'),
        ],
      ),
    );
  }
}

/// Widget para mostrar limitaciones de características
class FeatureLimitWidget extends StatelessWidget {
  final String featureId;
  final String title;

  const FeatureLimitWidget({super.key, required this.featureId, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionService>(
      builder: (context, service, child) {
        if (!service.isPremiumUser) {
          return Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.lock, color: Colors.red[300], size: 32),
                  const SizedBox(height: 8),
                  Text('$title bloqueado', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Actualiza a Premium para desbloquear'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => showSubscriptionModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Ver Planes'),
                  ),
                ],
              ),
            ),
          );
        }

        final limit = service.getFeatureLimit(featureId);
        return Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.verified, color: Colors.green[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        limit == -1 ? 'Ilimitado' : 'Límite: $limit por mes',
                        style: TextStyle(color: Colors.green[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
