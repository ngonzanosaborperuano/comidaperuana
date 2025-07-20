# Configuración PayU Producción

## 🚨 Problema Actual

PayU no tiene habilitada la integración Web Checkout para tu cuenta en producción.

## 📞 Contacto PayU Latam

### Información de contacto:

- **Email:** soporte@payulatam.com
- **Teléfono:** +57 1 743 0000
- **Sitio web:** https://payulatam.com

### Información a proporcionar:

```
Merchant ID: 508029
Account ID: 512326
API Key: 4Vj8eK4rloUd272L48hsrarnUA
API Login: pRRXKOl8ikMmt9u
```

## 🔧 Solicitudes a PayU

### 1. Habilitar Web Checkout Integration

- Solicitar activación de integración web checkout
- Confirmar que la cuenta puede procesar pagos web

### 2. Habilitar Producción Environment

- Activar entorno de producción
- Confirmar URLs de producción funcionando

### 3. Configurar Perú como país

- Verificar que Perú esté habilitado como país de operación
- Confirmar moneda PEN habilitada

## 📋 Configuración .env para Producción

```env
# PayU Producción
PAYU_MERCHANT_ID=508029
PAYU_ACCOUNT_ID=512326
PAYU_API_KEY=4Vj8eK4rloUd272L48hsrarnUA
PAYU_API_LOGIN=pRRXKOl8ikMmt9u

# URLs de Producción
PAYU_BASE_URL=https://api.payulatam.com
PAYU_CHECKOUT_URL=https://checkout.payulatam.com/ppp-web-gateway-payu/

# Configuración
PAYU_CURRENCY=PEN
PAYU_LANGUAGE=es
PAYU_TEST_MODE=false

# URLs de respuesta (configurar según tu app)
PAYU_RESPONSE_URL=https://tuapp.com/payment/response
PAYU_CONFIRMATION_URL=https://tuapp.com/payment/confirmation
```

## 🧪 Tarjetas de Prueba para Producción

### Visa

- Número: 4005580000000007
- CVV: 123
- Fecha: Cualquier fecha futura

### Mastercard

- Número: 5454545454545454
- CVV: 123
- Fecha: Cualquier fecha futura

### American Express

- Número: 374245455400126
- CVV: 1234
- Fecha: Cualquier fecha futura

## ⏳ Tiempo estimado de activación

- **Habilitación de integración:** 24-48 horas
- **Activación de producción:** 1-3 días hábiles
- **Configuración completa:** 3-5 días hábiles

## 📝 Notas importantes

- Las credenciales de sandbox funcionan en producción
- El error "Type of integration unsupported" es específico de PayU
- Necesitas contacto directo con soporte técnico de PayU
- La integración web checkout debe estar explícitamente habilitada
