import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/modules/login/bloc/login_bloc.dart';
import 'package:recetasperuanas/modules/login/bloc/login_event.dart' show LoginRequested;
import 'package:recetasperuanas/shared/widget/widget.dart';

class LoginFormBloc extends StatefulWidget {
  const LoginFormBloc({super.key, required this.formKey, required this.onLogin});

  final GlobalKey<FormState> formKey;
  final VoidCallback onLogin;

  @override
  State<LoginFormBloc> createState() => _LoginFormBlocState();
}

class _LoginFormBlocState extends State<LoginFormBloc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo placeholder
              const Icon(Icons.restaurant, size: 64, color: Colors.orange),
              AppVerticalSpace.md,

              // Title
              const AppText(text: 'Iniciar Sesión', fontSize: 24, fontWeight: FontWeight.bold),
              AppVerticalSpace.sm,

              // Subtitle
              const AppText(
                text: 'Accede a tu cuenta para continuar',
                fontSize: 16,
                color: Colors.grey,
              ),
              AppVerticalSpace.xxmd,

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu email';
                  }
                  return null;
                },
              ),
              AppVerticalSpace.md,

              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: _isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              AppVerticalSpace.xxmd,

              // Login button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: state is LoginLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child:
                      state is LoginLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const AppText(
                            text: 'Iniciar Sesión',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                ),
              ),
              AppVerticalSpace.md,

              // Forgot password
              TextButton(
                onPressed: _handleForgotPassword,
                child: const AppText(
                  text: '¿Olvidaste tu contraseña?',
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogin() {
    if (widget.formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
          type: LoginWith.withUserPassword,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.isNotEmpty) {
      context.read<LoginBloc>().add(RecoverCredentialRequested(_emailController.text));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Por favor ingresa tu email primero')));
    }
  }
}
