# CONFIGURACIÓN TEMPORAL - Copiar este contenido al archivo .env

# PayU Configuration - Perú (Sandbox) - CORREGIDO

PAYU_MERCHANT_ID=508029
PAYU_ACCOUNT_ID=512326
PAYU_API_KEY=4Vj8eK4rloUd272L48hsrarnUA
PAYU_API_LOGIN=pRRXKOl8ikMmt9u

# PayU URLs (Sandbox)

PAYU_BASE_URL=https://sandbox.api.payulatam.com
PAYU_CHECKOUT_URL=https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/

# PayU Regional Settings

PAYU_CURRENCY=PEN
PAYU_LANGUAGE=es

# PayU Response URLs (simple URLs to avoid errors)

PAYU_RESPONSE_URL=https://www.google.com
PAYU_CONFIRMATION_URL=https://www.google.com

# Environment (IMPORTANTE: true para sandbox)

PAYU_TEST_MODE=true

# INSTRUCCIONES:

# 1. Crear archivo .env en la raíz del proyecto

# 2. Copiar todo el contenido de arriba al archivo .env

# 3. Reiniciar la app

# 4. Verificar que test=1 en la URL generada
