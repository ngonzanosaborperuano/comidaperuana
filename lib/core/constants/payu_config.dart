import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

class PayUConfig {
  static String get merchantId => dotenv.env['PAYU_MERCHANT_ID'] ?? '508029';
  static String get accountId => dotenv.env['PAYU_ACCOUNT_ID'] ?? '512326';
  static String get apiKey => dotenv.env['PAYU_API_KEY'] ?? '4Vj8eK4rloUd272L48hsrarnUA';
  static String get apiLogin => dotenv.env['PAYU_API_LOGIN'] ?? 'pRRXKOl8ikMmt9u';

  static String get baseUrl => dotenv.env['PAYU_BASE_URL'] ?? 'https://sandbox.api.payulatam.com';
  static String get checkoutUrl =>
      dotenv.env['PAYU_CHECKOUT_URL'] ??
      'https://sandbox.checkout.payulatam.com/ppp-web-gateway-payu/';

  static String get currency => dotenv.env['PAYU_CURRENCY'] ?? 'PEN';
  static String get language => dotenv.env['PAYU_LANGUAGE'] ?? 'es';

  static String get responseUrl => dotenv.env['PAYU_RESPONSE_URL'] ?? 'https://www.google.com';
  static String get confirmationUrl =>
      dotenv.env['PAYU_CONFIRMATION_URL'] ?? 'https://www.google.com';

  static bool get testMode =>
      dotenv.env['PAYU_TEST_MODE'] == 'true' || dotenv.env['PAYU_TEST_MODE'] == null;
}
