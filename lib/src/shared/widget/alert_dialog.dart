import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showPlatformDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmText,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                onConfirm();
              },
              isDefaultAction: true,
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                onConfirm();
              },
              child: Text(confirmText, style: const TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}
