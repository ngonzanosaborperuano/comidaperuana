// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome => 'Bienvenido a Comida peruana';

  @override
  String get descriptionWelcome => 'Lo mejor de la gastronomia peruana.';

  @override
  String get getStarted => 'Empezar';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get descriptionLogin => 'Por favor ingrese sus credenciales.';

  @override
  String get email => 'Correo';

  @override
  String get password => 'Contraseña';

  @override
  String get enterPassword => 'Ingrese una Contraseña';

  @override
  String get newUser => 'Nuevo usuario';

  @override
  String get titleAccessDenied => 'Acceso denegado';

  @override
  String get textAccessDenied =>
      'Los datos ingresados son incorrectos o no tiene un usuario registrado, vuelva a intentarlo.';

  @override
  String get validateEmpty => 'Este campo es requerido.';

  @override
  String get emptyPassword => 'La contraseña no puede estar vacía.';

  @override
  String get minEightCharacters => '* Debe tener al menos 8 caracteres.';

  @override
  String get labelUpper => '* Debe contener al menos una letra mayúscula.';

  @override
  String get labelLower => '* Debe contener al menos una letra minúscula';

  @override
  String get anyNumber => '* Debe contener al menos un número.';

  @override
  String get specialCharacter =>
      '* Debe contener al menos un carácter especial.';

  @override
  String get invalidPassword => 'La contraseña es inválida';

  @override
  String get validateList => 'Este campo es requerido.';

  @override
  String get validateEmail => 'Introduce un correo electrónico válido';

  @override
  String get registerNow => 'Registrar ahora';

  @override
  String get enterEmail => 'Ingrese un correo';

  @override
  String get repeatPassword => 'Repetir contraseña';

  @override
  String get register => 'Registrarse';

  @override
  String get validatePasswordText =>
      'Las contraseñas no coinciden, vuelva a intentarlo.';

  @override
  String get error => 'Error';

  @override
  String get accept => 'Aceptar';

  @override
  String get setting => 'Configuración';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get firstName => 'Apellido Paterno';

  @override
  String get lastName => 'Apellido Materno';

  @override
  String get changeLanguage => 'Español';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get completed => 'Completado';

  @override
  String get pending => 'Pendiente';

  @override
  String get status => 'Estado';

  @override
  String get title => 'Título';

  @override
  String get searchRecipe => 'Buscar receta';

  @override
  String get searchTitle => 'Buscar por título';

  @override
  String get insertTitle => 'Escriba un título';

  @override
  String get body => 'Mensaje';

  @override
  String get writeNote => 'Escriba una nota';

  @override
  String get addNote => 'Crea una nota';

  @override
  String get save => 'Guardar';

  @override
  String get back => 'Volver';

  @override
  String get messageAddNote => 'Se creó una nota exitosamente.';

  @override
  String get messageDeleteNote => 'Se eliminó la nota: ';

  @override
  String get updateTask => 'Actualizar tarea';

  @override
  String get messageUpdateNote => 'Se actualizó nota exitosamente.';

  @override
  String get noNote => 'No se encontraron notas.';

  @override
  String get listPending => 'Lista de pendientes';

  @override
  String get completeInformation =>
      'Por favor complete los detalles y cree una cuenta';

  @override
  String get user => 'Usuario';

  @override
  String get or => 'o';

  @override
  String get userPass => 'Usuario y contraseña';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get enterFullName => 'Ingrese nombre completo';

  @override
  String get onboardingTitle1 => 'Comida fresca y deliciosa';

  @override
  String get onboardingSubtitle1 =>
      'Descubre recetas saludables y sabrosas todos los días.';

  @override
  String get onboardingTitle2 => 'Cocina en casa';

  @override
  String get onboardingSubtitle2 => 'Encuentra recetas para cocinar tú mismo.';

  @override
  String get onboardingTitle3 => 'Recetas de chefs y platos típicos';

  @override
  String get onboardingSubtitle3 =>
      'Explora recetas creadas por chefs y sabores tradicionales de todo el mundo.';

  @override
  String get onboardingTitle4 => '¡Bienvenido a Cocinando!';

  @override
  String get onboardingSubtitle4 =>
      'Usa inteligencia artificial para descubrir qué cocinar con los ingredientes que ya tienes en casa.';

  @override
  String get unsupportedSignInMethod => 'Tipo de inicio de sesión no soportado';

  @override
  String get signInError => 'Error al iniciar sesión';

  @override
  String get googleSignInAborted =>
      'Inicio de sesión con Google cancelado por el usuario';

  @override
  String get googleNoToken =>
      'Fallo en el inicio de sesión con Google: No se recibió token de acceso ni token de ID.';

  @override
  String get accountExistsWithDifferentCredential =>
      'La cuenta ya existe con una credencial diferente.';

  @override
  String get invalidCredential => 'La credencial recibida no es válida.';

  @override
  String get operationNotAllowed =>
      'Operación no permitida. Habilita el inicio de sesión con Google en la consola de Firebase.';

  @override
  String get userDisabled =>
      'Usuario deshabilitado. Por favor, contacta con soporte.';

  @override
  String get userNotFound =>
      'No se encontró un usuario con ese correo electrónico.';

  @override
  String get wrongPassword =>
      'Contraseña incorrecta proporcionada para ese usuario.';

  @override
  String get unknownGoogleSignInError =>
      'Ocurrió un error desconocido durante el inicio de sesión con Google';

  @override
  String get googleSignInError =>
      'Ocurrió un error durante el inicio de sesión con Google';

  @override
  String get authSuccess => 'Inicio de sesión o registro exitoso';

  @override
  String get authError => 'Error al iniciar sesión o registrar';

  @override
  String get weakPassword => 'La contraseña proporcionada es demasiado débil.';

  @override
  String get emailAlreadyInUse =>
      'La cuenta ya existe para ese correo electrónico.';

  @override
  String get unknownEmailLoginError =>
      'Ocurrió un error desconocido durante el inicio de sesión con correo/contraseña';

  @override
  String get emailLoginError =>
      'Ocurrió un error durante el inicio de sesión con correo/contraseña';

  @override
  String get recoverEmail => 'Recuperar correo';

  @override
  String get recoverAccountMessage =>
      'Para recuperar tu cuenta, ingresa una dirección de correo electrónico y luego acepta. Revisa tu correo. Si no lo ves, revisa otros correos o la carpeta de spam.';

  @override
  String get recoverPassword => 'Recuperar contraseña';

  @override
  String get send => 'Enviar';

  @override
  String get errorUserNotFound =>
      'No hay ningún usuario registrado con ese correo.';

  @override
  String get errorTooManyRequests =>
      'Demasiadas solicitudes. Inténtalo más tarde.';

  @override
  String get errorNetwork => 'Error de red. Revisa tu conexión a internet.';

  @override
  String get errorDefault => 'Formato del correo no válido.';

  @override
  String get errorInvalidEmail => 'El correo no tiene un formato válido.';
}
