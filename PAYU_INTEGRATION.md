# Integración PayU + Google Pay

## 🎯 Resumen

Sistema de pagos integrado con PayU que incluye soporte para Google Pay, específicamente diseñado para suscripciones Premium de la app de Recetas Peruanas.

## ✅ Características Implementadas

### 🔧 **PayUGooglePayService**

- ✅ Generación de URLs de checkout seguras
- ✅ Integración con formularios web de PayU
- ✅ Soporte nativo para Google Pay
- ✅ Gestión automática de respuestas de pago
- ✅ Activación automática de suscripciones

### 🌐 **PayUCheckoutWebView**

- ✅ WebView segura para proceso de pago
- ✅ Detección automática de resultados
- ✅ UI optimizada con indicadores de carga
- ✅ Manejo de errores y estados de pago
- ✅ Navegación fluida

### 🎨 **Integración UI**

- ✅ Modificación de SubscriptionPlansPage
- ✅ Diálogos de confirmación mejorados
- ✅ Mensajes de éxito/error
- ✅ Indicadores de seguridad PayU

## 🏗️ Arquitectura

```
[SubscriptionPlansPage] → [PayUGooglePayService] → [PayU API]
           ↓                        ↓                    ↓
[PayUCheckoutWebView]     [URL Generation]      [Secure Checkout]
           ↓                        ↓                    ↓
[Payment Detection]    [Response Processing]   [Transaction Result]
           ↓                        ↓                    ↓
[SubscriptionService]   [Auto Activation]      [User Notification]
```

## 🚀 Uso Rápido

### 1. Configuración Inicial

En tu `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionService()),
        ChangeNotifierProvider(create: (_) => PayUGooglePayService()),
      ],
      child: MyApp(),
    ),
  );
}
```

### 2. Configurar Credenciales PayU

En `lib/core/services/payu_google_pay_service.dart`:

```dart
class PayUConfig {
  static const String merchantId = 'TU_MERCHANT_ID';
  static const String accountId = 'TU_ACCOUNT_ID';
  static const String apiKey = 'TU_API_KEY';

  // URLs de respuesta (cambiar por las tuyas)
  static const String responseUrl = 'https://tu-app.com/response';
  static const String confirmationUrl = 'https://tu-app.com/confirmation';
}
```

### 3. Usar en tu UI

```dart
// Botón directo
ElevatedButton(
  onPressed: () => showPayUCheckout(
    context,
    planType: SubscriptionPlanType.monthly,
    userEmail: 'usuario@ejemplo.com',
    userName: 'Juan Pérez',
    onSuccess: () => print('¡Pago exitoso!'),
    onFailure: () => print('Error en pago'),
  ),
  child: Text('Suscribirse con PayU'),
)

// Desde planes de suscripción
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SubscriptionPlansPage(
      userEmail: 'usuario@ejemplo.com',
      userName: 'Juan Pérez',
    ),
  ),
);
```

## 💳 Métodos de Pago Soportados

### PayU Checkout incluye:

- 💳 **Tarjetas de Crédito/Débito**: Visa, Mastercard
- 📱 **Google Pay**: Activado automáticamente
- 🏦 **Transferencias bancarias**
- 💰 **Cuotas**: Disponibles según configuración PayU

## 🔒 Seguridad

### Datos Nunca Expuestos:

- ❌ **Números de tarjeta** → Manejados por PayU
- ❌ **CVV/CVC** → Nunca pasan por la app
- ❌ **Datos bancarios** → Directos a PayU

### Datos Manejados por la App:

- ✅ **Email del usuario**
- ✅ **Nombre del usuario**
- ✅ **Monto de suscripción**
- ✅ **ID de transacción** (post-pago)

## 📋 Estados de Pago

| Estado        | Código | Descripción      | Acción                               |
| ------------- | ------ | ---------------- | ------------------------------------ |
| **Aprobado**  | `4`    | Pago exitoso     | ✅ Activar suscripción               |
| **Rechazado** | `6`    | Pago rechazado   | ❌ Mostrar error, permitir reintento |
| **Pendiente** | `7`    | En procesamiento | ⏳ Notificar estado pendiente        |

## 🔧 Configuración Avanzada

### URLs de Respuesta

Para producción, configura estas URLs en tu servidor:

1. **Response URL**: Donde PayU redirige después del pago
2. **Confirmation URL**: Webhook para confirmación server-to-server

Ejemplo de respuesta:

```
https://tu-app.com/response?
  transactionState=4&
  referenceCode=SUB_MONTHLY_1234567890&
  transactionId=abc123&
  orderId=ORDER_123
```

### Webhooks (Recomendado)

Implementa un endpoint en tu backend:

```javascript
// Node.js example
app.post("/api/payu/confirmation", (req, res) => {
  const { reference_sale, state_pol, transaction_id } = req.body;

  if (state_pol === "4") {
    // Aprobado
    // Activar suscripción en tu base de datos
    activateSubscription(reference_sale, transaction_id);
  }

  res.status(200).send("OK");
});
```

## 🧪 Testing

### Datos de Prueba PayU:

**Tarjetas de Prueba:**

```
Visa: 4097440000000004
Mastercard: 5178040000000018
CVV: 123
Fecha: 12/25
```

**Google Pay:** Funciona automáticamente en el sandbox

### Verificar Integración:

```dart
// Test de servicio
final payuService = PayUGooglePayService();
final response = await payuService.processSubscriptionPayment(
  planType: SubscriptionPlanType.monthly,
  amount: 29.90,
  userEmail: 'test@ejemplo.com',
  userName: 'Usuario Test',
);

print('Checkout URL: ${response.checkoutUrl}');
```

## 🚀 Pasos a Producción

### 1. Credenciales Reales

```dart
class PayUConfig {
  static const String baseUrl = 'https://api.payulatam.com'; // ⚠️ Cambiar
  // Actualizar merchantId, accountId, apiKey con datos reales
}
```

### 2. URLs Reales

- Cambiar `responseUrl` y `confirmationUrl`
- Configurar DNS y SSL para tu dominio

### 3. Testing Final

- ✅ Probar con tarjetas reales
- ✅ Verificar Google Pay en dispositivos reales
- ✅ Confirmar activación de suscripciones
- ✅ Probar webhooks de confirmación

## 📊 Monitoreo

### Logs Importantes:

```dart
// El servicio automáticamente registra:
log('Checkout URL generada: $checkoutUrl');
log('Pago procesado: $transactionState');
log('Suscripción activada: $planType');
```

### Métricas Recomendadas:

- 📈 **Tasa de conversión** por plan
- 💳 **Métodos de pago más usados**
- ⏱️ **Tiempo de checkout**
- ❌ **Errores de pago comunes**

## 🆘 Troubleshooting

### Problemas Comunes:

**Error: "Signature inválida"**

```dart
// Verificar que los parámetros estén en el orden correcto:
// apiKey~merchantId~referenceCode~amount~currency
```

**WebView no carga**

```dart
// Verificar permisos de internet en AndroidManifest.xml
<uses-permission android:name="android.permission.INTERNET" />
```

**Google Pay no aparece**

- ✅ Verificar configuración en `google_pay_config.json`
- ✅ Confirmar que el dispositivo tiene Google Pay
- ✅ Usar ambiente TEST para pruebas

## 📞 Soporte

- **PayU Docs**: https://developers.payulatam.com/
- **Google Pay**: https://developers.google.com/pay/
- **Flutter WebView**: https://pub.dev/packages/webview_flutter

---

**Nota**: Esta integración está optimizada para Perú (PEN) pero puede adaptarse a otros países latinoamericanos soportados por PayU.
