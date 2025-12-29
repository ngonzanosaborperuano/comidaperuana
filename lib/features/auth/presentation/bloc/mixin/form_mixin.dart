part of '../login_bloc.dart';

mixin LoginFormMixin on Bloc<LoginEvent, LoginState> {
  void _onLoginErrorCleared(LoginErrorCleared event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    emit(currentState.copyWith(emailError: null, passwordError: null));
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    final emailError = Email.create(event.email);
    final isValid =
        emailError.isSuccess &&
        currentState.passwordError == null &&
        event.email.isNotEmpty &&
        currentState.password.isNotEmpty;

    emit(
      currentState.copyWith(
        email: event.email,
        emailError: currentState.hasAttemptedValidation ? emailError.errorMessage : null,
        isValid: isValid,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    final passwordError = Password.create(event.password);
    final isValid =
        currentState.emailError == null &&
        passwordError.isSuccess &&
        currentState.email.isNotEmpty &&
        event.password.isNotEmpty;

    emit(
      currentState.copyWith(
        password: event.password,
        passwordError: currentState.hasAttemptedValidation ? passwordError.errorMessage : null,
        isValid: isValid,
      ),
    );
  }

  void _onPasswordVisibilityToggled(PasswordVisibilityToggled event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    emit(currentState.copyWith(isPasswordVisible: !currentState.isPasswordVisible));
  }

  void _onFormValidated(FormValidated event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    final emailError = Email.create(currentState.email);
    final passwordError = Password.create(currentState.password);
    final isValid =
        emailError.isSuccess &&
        passwordError.isSuccess &&
        currentState.email.isNotEmpty &&
        currentState.password.isNotEmpty;

    emit(
      currentState.copyWith(
        emailError: emailError.errorMessage,
        passwordError: passwordError.errorMessage,
        isValid: isValid,
      ),
    );
  }

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    final emailError = Email.create(event.email);
    final passwordError = Password.create(event.password);

    if (emailError.isFailure || passwordError.isFailure) {
      emit(
        const LoginFormState(
          isValid: false,
          hasAttemptedValidation: true,
        ).copyWith(emailError: emailError.errorMessage, passwordError: passwordError.errorMessage),
      );
    } else {
      emit(LoginFormState(isValid: true, email: event.email, password: event.password));
    }
  }
}
