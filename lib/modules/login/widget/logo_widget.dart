import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Image.asset('assets/img/logoOutName.png', width: 80, height: 80),
    );
  }
}
