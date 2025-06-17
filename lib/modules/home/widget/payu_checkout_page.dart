import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PayUCheckoutPage extends StatefulWidget {
  const PayUCheckoutPage({super.key});

  @override
  PayUCheckoutPageState createState() => PayUCheckoutPageState();
}

class PayUCheckoutPageState extends State<PayUCheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String email = 'niltongr@outlook.com';
  String description = 'suscripcion de un mes';
  double amount = 50.0;
  String? checkoutUrl;
  WebViewController? _webViewController;

  Future<void> getCheckoutUrl() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.102:3000/api/payu/v1/checkout-url'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount.toStringAsFixed(2),
        'description': description,
        'reference': 'pedido_${DateTime.now().millisecondsSinceEpoch}',
        'buyerEmail': email,
        //'buyerName': 'Nilton Gonzano',
        //'buyerPhone': '999999999',
        //'buyerAddress': 'Calle 123',
        //'buyerCity': 'Lima',
        //'buyerState': 'Lima',
        //'buyerZip': '12345',
      }),
    );
    final data = jsonDecode(response.body);
    setState(() {
      checkoutUrl = data['checkoutUrl'];
      if (checkoutUrl != null) {
        _webViewController =
            WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(checkoutUrl!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null && _webViewController != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Completa tu pago')),
        body: WebViewWidget(controller: _webViewController!),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pagar con PayU')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo'),
                onChanged: (v) => email = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (v) => description = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                onChanged: (v) => amount = double.tryParse(v) ?? 0.0,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: getCheckoutUrl, child: const Text('Pagar')),
            ],
          ),
        ),
      ),
    );
  }
}
