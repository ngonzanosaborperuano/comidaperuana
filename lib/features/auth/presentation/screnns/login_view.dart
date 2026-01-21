import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/app_botton_sheet.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/core/extension/loading.dart';
import 'package:goncook/core/router/routes.dart' show Routes;
import 'package:goncook/core/services/device/device_info_service.dart';
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';
import 'package:goncook/features/auth/presentation/widget/widget.dart'
    show AnimatedLoginForm, LoginWithGoogle;

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  bool _isSuccessTransition(LoginState previous, LoginState current) {
    return current is LoginSuccess && previous is! LoginSuccess;
  }

  bool _isErrorTransition(LoginState previous, LoginState current) {
    return current is LoginError && previous is! LoginError;
  }

  /// Determines whether the listener should react to state changes.
  bool _listenWhenState(LoginState previous, LoginState current) {
    final isSuccessTransition = _isSuccessTransition(previous, current);
    final isErrorTransition = _isErrorTransition(previous, current);
    return isSuccessTransition || isErrorTransition;
  }

  /// Handles login state changes and triggers appropriate UI actions.
  void _listener(BuildContext context, LoginState state) {
    if (state is LoginSuccess && state.isSuccess) {
      if (!context.mounted) return;
      context.showSuccessToast(context.loc.welcomeToGonCook);
      context.go(Routes.home.description);
    } else if (state is LoginError && state.hasError) {
      if (!context.mounted) return;
      context
        ..hideLoading()
        ..showBottomSheet(
          title: 'Iniciar sesión',
          onClose: context.pop,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.md,
            children: [
              context.image.logo(),
              AppText(text: state.message, fontSize: AppSpacing.md),
              AppButton(text: 'Entendido', onPressed: context.pop),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: _listenWhenState,
      listener: _listener,
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.color.error.withAlpha(10),
                  context.color.buttonPrimary.withAlpha(10),
                ],
              ),
            ),
            child: const Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: _LoginContent(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Card(
      elevation: 2,
      color: context.color.background,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: context.color.border.withAlpha(100),
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          spacing: AppSpacing.md,
          children: [
            AnimatedLoginForm(
              emailController: emailController,
              passwordController: passwordController,
            ),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                AppText(text: ' O ', fontSize: 14),
                Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              ],
            ),
            const LoginWithGoogle(),
            // Botón para probar Pigeon - obtener info del dispositivo
            _TestDeviceInfoButton(),
            Row(
              children: [
                const AppText(text: '¿No tienes cuenta?', fontSize: AppSpacing.md),
                TextButton(
                  child: const AppText(text: 'Registrarse', fontSize: AppSpacing.md),
                  onPressed: () => context.push(Routes.register.description),
                ),
                AppVerticalSpace.md,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón para probar la funcionalidad de Pigeon
class _TestDeviceInfoButton extends StatelessWidget {
  const _TestDeviceInfoButton();

  Future<void> _showDeviceInfo(BuildContext context) async {
    final deviceService = DeviceInfoService();
    
    // Mostrar loading
    context.showLoading();
    
    try {
      final result = await deviceService.getDeviceInfo();
      
      if (!context.mounted) return;
      context.hideLoading();
      
      result.fold(
        (failure) {
          // Mostrar error
          context.showBottomSheet(
            title: 'Error al obtener información',
            onClose: context.pop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              children: [
                AppText(
                  text: failure.message,
                  fontSize: AppSpacing.md,
                  color: context.color.error,
                ),
                AppButton(
                  text: 'Cerrar',
                  onPressed: context.pop,
                ),
              ],
            ),
          );
        },
        (deviceInfo) {
          // Mostrar información exitosa
          context.showBottomSheet(
            title: 'Información del Dispositivo',
            onClose: context.pop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              children: [
                AppText(
                  text: 'Modelo: ${deviceInfo.model}',
                  fontSize: AppSpacing.md,
                ),
                AppText(
                  text: 'OS: ${deviceInfo.osVersion}',
                  fontSize: AppSpacing.md,
                ),
                AppText(
                  text: 'ID: ${deviceInfo.deviceId}',
                  fontSize: AppSpacing.sm,
                ),
                if (deviceInfo.brand != null)
                  AppText(
                    text: 'Marca: ${deviceInfo.brand}',
                    fontSize: AppSpacing.md,
                  ),
                AppButton(
                  text: 'Cerrar',
                  onPressed: context.pop,
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      context.hideLoading();
      context.showBottomSheet(
        title: 'Error',
        onClose: context.pop,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: [
            AppText(
              text: 'Error inesperado: $e',
              fontSize: AppSpacing.md,
              color: context.color.error,
            ),
            AppButton(
              text: 'Cerrar',
              onPressed: context.pop,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: '🔍 Info Dispositivo',
      onPressed: () => _showDeviceInfo(context),
    );
  }
}
