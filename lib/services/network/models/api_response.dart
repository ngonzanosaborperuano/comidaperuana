import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  const ApiResponse({this.success = true, String? message, T? data, String? error})
    : _data = data,
      _message = message;

  const ApiResponse.success({required T data, error})
    : success = true,
      _data = data,
      _message = null;

  const ApiResponse.error({String? message}) : success = false, _data = null, _message = message;

  final bool success;
  final T? _data;

  T? get data {
    if (!success) {
      throw Exception('''
        No se puede acceder a los datos de una respuesta fallida.

        Primero verifique si la respuesta fue exitosa con el atributo `success`.
        ''');
    }
    return _data;
  }

  final String? _message;
  String get message {
    if (success) {
      throw Exception('''
      No se puede acceder al mensaje de una respuesta exitosa.

      Primero verifique si la respuesta fue exitosa con el atributo `success`.
      ''');
    }

    if (_message == null) {
      throw Exception('''
      No se puede acceder al mensaje de una respuesta sin mensaje.

      El error proviene al parsear la respuesta del servidor o al intentar enviar
      la petición.
      ''');
    }

    return _message;
  }

  @override
  List<Object?> get props => [data, success, message];
}
