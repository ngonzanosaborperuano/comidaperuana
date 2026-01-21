import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_auth_repository.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/auth_usecase.dart';
import 'package:goncook/features/auth/domain/usecases/logout_usecase.dart';
import 'package:goncook/features/presentation.dart' show LoginView, LoginBloc;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  //factory LoginPage.routeBuilder(_, _) {
  //  return const LoginPage(key: Key('login_page'));
  //}
  
  //   ✔ Solo en páginas navegables
  //   ✔ Router limpio: sin lógica de negocio pesada
  //   ✔ Keys estándar
  //   ✔ Nada de lógica de negocio pesada ahí
 
   static Widget routeBuilder( _,  _) {
    return const LoginPage(key: Key('login_page'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc(
        loginUseCase: LoginUseCase(context.read<IUserAuthRepository>()),
        logoutUseCase: LogoutUseCase(context.read<IUserAuthRepository>()),
        userRepository: context.read<IUserRepository>(),
      ),
      child: const Scaffold(body: LoginView()),
    );
  }
}
