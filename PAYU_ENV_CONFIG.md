# Configuración de Variables de Entorno para PayU

## 📋 Copia este contenido a tu archivo `.env`:

```env
# PayU Producción - Credenciales reales
PAYU_MERCHANT_ID=1025140
PAYU_ACCOUNT_ID=1034315
PAYU_API_KEY=GtyOI4RDWGO7pBbDQsptJqMQ1J
PAYU_API_LOGIN=vll2XHR8E7OJ5Ts
PAYU_API_KEYPLUBLIC=PKb7m89A7bE4ok85T90209LL1z

# URLs de Producción
PAYU_BASE_URL=https://api.payulatam.com
PAYU_CHECKOUT_URL=https://checkout.payulatam.com/ppp-web-gateway-payu/

# Configuración
PAYU_CURRENCY=PEN
PAYU_LANGUAGE=es
PAYU_TEST_MODE=false

# URLs de respuesta (configurar según tu app)
PAYU_RESPONSE_URL=https://www.google.com
PAYU_CONFIRMATION_URL=https://www.google.com
```

## 🔧 Pasos para configurar:

### 1. Crear archivo `.env` en la raíz del proyecto:

```bash
touch .env
```

### 2. Copiar el contenido de arriba al archivo `.env`

### 3. Verificar que el archivo esté en `.gitignore`:

```gitignore
.env
```

## ✅ Verificación:

Después de crear el archivo `.env`, reinicia la app y revisa los logs. Deberías ver:

```
🔧 Cargando variables de entorno...
✅ Variables de entorno cargadas correctamente
📋 Configuración PayU: MerchantID=1025140, Currency=PEN, TestMode=false
```

## 🚀 Para probar:

1. **Crea el archivo `.env`** con el contenido de arriba
2. **Reinicia la app**
3. **Ve a suscripciones** y presiona PayU
4. **Revisa los logs** - deberías ver tus credenciales reales

## 📝 Notas importantes:

- ✅ Las variables de entorno se cargan en el bootstrap
- ✅ Los valores por defecto están configurados como fallback
- ✅ El archivo `.env` debe estar en la raíz del proyecto
- ✅ No subir el archivo `.env` a Git (debe estar en `.gitignore`)
