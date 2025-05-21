import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle h2TextBlack = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle headingPrimary = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,

    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle bodyTextBold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle bodyText = TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis);
  static const TextStyle bodyHintText = TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis);

  static const TextStyle labelSmall = TextStyle(fontSize: 16);
  static const TextStyle bodyTextNoOverflow = TextStyle(fontSize: 16);

  static const TextStyle bodyTextBoldPrimary = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static const TextStyle bodyMediumPrimary = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  static const TextStyle bodyMediumWhite = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  static const TextStyle bodyTextPrimary = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}
