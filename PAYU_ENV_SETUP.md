# Configuración de Variables de Entorno - PayU

## 📋 Variables de Entorno Requeridas

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:

```env
# PayU Configuration - Perú (Sandbox)
PAYU_MERCHANT_ID=508029
PAYU_ACCOUNT_ID=512326
PAYU_API_KEY=4Vj8eK4rloUd272L48hsrarnUA
PAYU_API_LOGIN=pRRXKOl8ikMmt9u

# PayU URLs
PAYU_BASE_URL=https://sandbox.api.payulatam.com
PAYU_CHECKOUT_URL=https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/

# PayU Regional Settings
PAYU_CURRENCY=PEN
PAYU_LANGUAGE=es

# PayU Response URLs (simple URLs to avoid errors)
PAYU_RESPONSE_URL=https://www.google.com
PAYU_CONFIRMATION_URL=https://www.google.com

# Environment
PAYU_TEST_MODE=true
```

## 🔧 Configuración para Producción

Para cambiar a producción, modifica estas variables:

```env
PAYU_BASE_URL=https://api.payulatam.com
PAYU_CHECKOUT_URL=https://checkout.payulatam.com/ppp-web-gateway-payu/
PAYU_TEST_MODE=false
```

## 🚀 Cómo usar

1. **Copia el archivo `.env.example`** (si existe) a `.env`
2. **Ajusta los valores** según tu configuración de PayU
3. **Reinicia la app** para cargar las nuevas variables

## 📝 Notas

- Las variables tienen valores por defecto si no están definidas
- El archivo `.env` está en `.gitignore` por seguridad
- Usa credenciales diferentes para sandbox y producción
