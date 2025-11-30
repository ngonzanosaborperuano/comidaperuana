import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

class PayUConfig {
  static String get merchantId => dotenv.env['PAYU_MERCHANT_ID']!;
  static String get accountId => dotenv.env['PAYU_ACCOUNT_ID']!;
  static String get apiKey => dotenv.env['PAYU_API_KEY']!;
  static String get apiLogin => dotenv.env['PAYU_API_LOGIN']!;

  static String get baseUrl => dotenv.env['PAYU_BASE_URL']!;
  static String get checkoutUrl => dotenv.env['PAYU_CHECKOUT_URL']!;

  static String get currency => dotenv.env['PAYU_CURRENCY']!;
  static String get language => dotenv.env['PAYU_LANGUAGE']!;

  static String get responseUrl => dotenv.env['PAYU_RESPONSE_URL']!;
  static String get confirmationUrl => dotenv.env['PAYU_CONFIRMATION_URL']!;

  static bool get testMode => dotenv.env['PAYU_TEST_MODE'] == 'true';

  static String get paymentMethods => dotenv.env['PAYU_PAYMENT_METHODS']!;
}
