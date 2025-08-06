import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller_old.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_confirm_dialog.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

Future<void> showRecoverPasswordDialog({
  required BuildContext context,
  required LoginControllerOld controller,
}) {
  final textEditingController = TextEditingController();
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => AppConfirmDialog(
          title: context.loc.recoverPassword,
          content: Column(
            children: [
              AppText(
                text: context.loc.recoverAccountMessage,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: context.color.textSecondary,
                textAlign: TextAlign.center,
              ),
              AppVerticalSpace.md,
              AppTextField(
                hintText: context.loc.email,
                textEditingController: textEditingController,
              ),
            ],
          ),
          confirmLabel: context.loc.send,
          cancelLabel: context.loc.cancel,
          onConfirm: () async {
            await const LoadingDialog().show(
              context,
              future: () async {
                final msg = await controller.recoverCredential(textEditingController.text);
                if (!context.mounted) return;
                switch (msg) {
                  case 'success':
                    context.showSuccessToast(context.loc.recoverEmailSent);
                    break;
                  case 'invalid-email':
                    context.showErrorToast(context.loc.errorInvalidEmail);
                    break;
                  case 'user-not-found':
                    context.showErrorToast(context.loc.errorUserNotFound);
                    break;
                  case 'too-many-requests':
                    context.showErrorToast(context.loc.errorTooManyRequests);
                    break;
                  case 'network-request-failed':
                    context.showErrorToast(context.loc.errorNetwork);
                    break;
                  default:
                    context.showErrorToast(context.loc.errorDefault);
                    break;
                }
              },
            );
          },
          onCancel: context.pop,
          confirmColor: context.color.buttonPrimary,
          borderColorFrom: context.color.buttonPrimary,
          borderColorTo: context.color.error,
        ),
  );
}
