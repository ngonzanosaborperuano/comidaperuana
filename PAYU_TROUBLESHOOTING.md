# 🔧 Solución de Problemas - PayU Integration

## 📋 Problemas Identificados y Soluciones

### 1. **"No se pudo crear solicitud de pago"**

**Causa:** Parámetros incorrectos o faltantes en la URL de checkout.

**Solución:**

- ✅ Verificar que todos los parámetros requeridos estén presentes
- ✅ Validar que las credenciales sean las oficiales de prueba
- ✅ Asegurar que la firma MD5 sea correcta
- ✅ **IMPORTANTE:** Usar URLs de respuesta simples (misma URL de checkout)

### 2. **"Type of integration unsupported"**

**Causa:** PayU no reconoce el tipo de integración.

**Solución:**

- ✅ Usar solo parámetros soportados por WebCheckout
- ✅ No incluir parámetros de API REST en WebCheckout
- ✅ Verificar que la URL de checkout sea la correcta

### 3. **"Error cargando página: net::ERR_BLOCKED_BY_ORB"**

**Causa:** Bloqueo de recursos externos por el navegador.

**Solución:**

- ✅ Configurar WebView para permitir recursos externos
- ✅ Usar User-Agent apropiado
- ✅ Habilitar JavaScript sin restricciones

## 🔧 Configuración Correcta

### Credenciales de Prueba (Sandbox)

```dart
merchantId: '508029'
accountId: '512326'
apiKey: '4Vj8eK4rloUd272L48hsrarnUA'
apiLogin: 'pRRXKOl8ikMmt9u'
```

### URLs Correctas

```dart
checkoutUrl: 'https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/'
responseUrl: 'https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/'
confirmationUrl: 'https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/'
```

### Parámetros Requeridos (Configuración Simplificada)

```dart
{
  'merchantId': '508029',
  'accountId': '512326',
  'apiLogin': 'pRRXKOl8ikMmt9u',
  'description': 'Descripción del producto',
  'referenceCode': 'REF_UNICA',
  'amount': '100.0',
  'currency': 'PEN',
  'signature': 'FIRMA_MD5',
  'test': '1',
  'buyerEmail': 'comprador@email.com',
  'buyerFullName': 'Nombre Completo',
  'responseUrl': 'https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/',
  'confirmationUrl': 'https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/'
}
```

## 🧪 Tarjetas de Prueba

### Tarjetas Aprobadas (CVV: 777, Mes: < 6)

- VISA: `4907840000000005`
- MASTERCARD: `5491610000000001`
- AMEX: `377753000000009`

### Tarjetas Rechazadas (CVV: 666, Mes: > 6)

- VISA: `4634010000000005`
- MASTERCARD: `5491610000000001`

### Transacción Pendiente

- Email: `manual-review-hub@email.com`

## 🔍 Pasos de Depuración

1. **Usar el Widget de Prueba**
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const PayUTestWidget()),
   );
   ```

2. **Verificar Conectividad**
   ```dart
   await payuService.testPayUConnectivity();
   ```

3. **Generar URL de Prueba**
   ```dart
   final testUrl = payuService.generateTestUrl();
   ```

4. **Validar Configuración**
   ```dart
   payuService._validatePayUConfiguration();
   ```

5. **Revisar Logs**
   - Buscar logs con prefijo `🚀 PAYU`
   - Verificar que no haya errores de validación
   - Confirmar que la URL generada sea correcta

6. **Probar con Tarjetas de Prueba**
   - Usar tarjetas oficiales de PayU
   - Seguir las reglas de CVV y mes de expiración
   - Verificar que el email sea válido

## 🚨 Errores Comunes

### Error: "Invalid signature"

- Verificar que la firma MD5 use el formato correcto
- Asegurar que el monto tenga formato decimal (ej: 100.0)

### Error: "Invalid merchant"

- Confirmar que merchantId y accountId sean correctos
- Verificar que esté usando credenciales de sandbox

### Error: "Invalid currency"

- Usar solo 'PEN' para Perú
- No incluir símbolos de moneda

## 📞 Soporte

Si los problemas persisten:

- Email: test.tech@payulatam.com
- Teléfono: 7512354
- Documentación: https://developers.payulatam.com/latam/es/docs/
