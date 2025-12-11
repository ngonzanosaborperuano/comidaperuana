# fpdart Extensions - Guía Completa de Uso

Guía completa para usar todas las extensiones de fpdart en el proyecto. Estas extensiones facilitan el manejo de errores, valores opcionales, operaciones asíncronas y el reporte global de fallos.

## Tipos de fpdart Disponibles

Este proyecto incluye extensiones útiles que complementan los métodos nativos de fpdart:

- ✅ **`Either<L, R>`** - Extensiones para side effects y utilidades específicas
- ✅ **`Option<T>`** - Extensiones para side effects y getters convenientes
- ✅ **`Task<T>`** - Conversión a Either con manejo de errores
- ✅ **`TaskEither<L, R>`** - Reporte global de errores
- ✅ **`Unit`** - Utilidades para operaciones sin retorno

**Nota:** Para métodos nativos de fpdart como `map`, `flatMap`, `getOrElse`, `toEither`, `toNullable`, `filter`, etc., usa directamente los métodos proporcionados por fpdart.

## Tabla de Contenidos

- [Función Centralizada](#función-centralizada)
- [Extensiones Either](#extensiones-either)
- [Extensiones Option](#extensiones-option)
- [Extensiones Task](#extensiones-task)
- [Extensiones TaskEither](#extensiones-taskeither)
- [Extensiones Unit](#extensiones-unit)
- [Ejecutar Peticiones en Paralelo](#ejecutar-peticiones-en-paralelo)
- [Ejemplos Completos](#ejemplos-completos)

---

## Función Centralizada

### `failureToException(Failure failure)`

Convierte un `Failure` a su `AppException` correspondiente. Único punto de conversión autorizado en toda la app.

**Ejemplo:**
```dart
final failure = NetworkFailure('Sin conexión a internet');
final exception = failureToException(failure);
```

**Salida:** NetworkException con el mensaje y código correspondiente.

---

## Extensiones Either

### `onLeft(void Function(L left) f)`

Ejecuta una acción cuando hay un error, sin modificar el resultado.

**Con extensión:**
```dart
final result = await getUserUseCase(userId);
result
  .onLeft((error) => logger.e('Error: $error'))
  .fold(
    (failure) => emit(UserState.error(failure)),
    (user) => emit(UserState.loaded(user)),
  );
```

**Sin extensión:**
```dart
final result = await getUserUseCase(userId);
result.fold(
  (failure) {
    logger.e('Error: $failure');
    emit(UserState.error(failure));
  },
  (user) => emit(UserState.loaded(user)),
);
```

**Ventaja:** La extensión permite encadenar operaciones y separar side effects de la lógica de negocio.

---

### `onRight(void Function(R right) f)`

Ejecuta una acción cuando hay éxito, sin modificar el resultado.

**Con extensión:**
```dart
final result = await saveUserUseCase(user);
result
  .onRight((savedUser) => logger.i('Guardado: ${savedUser.id}'))
  .fold(
    (failure) => emit(SaveState.error(failure)),
    (user) => emit(SaveState.success(user)),
  );
```

**Sin extensión:**
```dart
final result = await saveUserUseCase(user);
result.fold(
  (failure) => emit(SaveState.error(failure)),
  (user) {
    logger.i('Guardado: ${user.id}');
    emit(SaveState.success(user));
  },
);
```

**Ventaja:** La extensión permite separar logging de la lógica de negocio y encadenar operaciones.

---

### `getOrElse(R Function() defaultValue)`

Obtiene el valor exitoso o un valor por defecto si hay error.

**Con extensión:**
```dart
final result = await getUserUseCase(userId);
final user = result.getOrElse(() => User.guest());
print('Usuario: ${user.name}');
```

**Sin extensión:**
```dart
final result = await getUserUseCase(userId);
final user = result.fold(
  (failure) => User.guest(),
  (user) => user,
);
print('Usuario: ${user.name}');
```

**Ventaja:** Más conciso y legible, especialmente cuando no necesitas el valor del error.

---

### `isRight` / `isLeft`

Indican si el resultado es exitoso o un error.

**Con extensión:**
```dart
if (result.isRight) {
  print('Éxito');
} else if (result.isLeft) {
  print('Error');
}
```

**Sin extensión:**
```dart
if (result.isRight()) {
  print('Éxito');
} else if (result.isLeft()) {
  print('Error');
}
```

**Ventaja:** Los getters son más convenientes que los métodos (sin paréntesis).

---

### `reportLeft()` - Solo para `Either<Failure, R>`

Reporta el error al sistema global de monitoreo y retorna el mismo resultado para seguir trabajando con él.

**Con extensión:**
```dart
final result = await registerUserUseCase(userData);
result.reportLeft().fold(
  (failure) => emit(RegisterState.error(failure)),
  (user) => emit(RegisterState.success(user)),
);
```

**Sin extensión:**
```dart
final result = await registerUserUseCase(userData);
result.fold(
  (failure) {
    getIt<ErrorNotifierCubit>().notifyError(failureToException(failure));
    emit(RegisterState.error(failure));
  },
  (user) => emit(RegisterState.success(user)),
);
```

**Ventaja:** Automatiza el reporte de errores sin duplicar código en cada `fold()`.

---

### `getRightOrThrow(Object Function() onLeft)`

Obtiene el valor Right o lanza una excepción si es Left.

**Con extensión:**
```dart
final user = result.getRightOrThrow(() => Exception('Usuario no encontrado'));
print('Usuario: ${user.name}');
```

**Sin extensión:**
```dart
final user = result.fold(
  (failure) => throw Exception('Usuario no encontrado'),
  (user) => user,
);
print('Usuario: ${user.name}');
```

**Ventaja:** Más legible y expresivo para casos donde esperas un Right.

---

### `getLeftOrThrow(Object Function() onRight)`

Obtiene el valor Left o lanza una excepción si es Right.

**Con extensión:**
```dart
final error = result.getLeftOrThrow(() => Exception('No debería ser exitoso'));
print('Error: $error');
```

**Sin extensión:**
```dart
final error = result.fold(
  (failure) => failure,
  (user) => throw Exception('No debería ser exitoso'),
);
print('Error: $error');
```

**Ventaja:** Más legible para casos donde esperas un Left (útil en tests o validaciones).

**Nota:** Para convertir a `Option` o `nullable`, usa los métodos nativos de fpdart: `toOption()` y `toNullable()`.

---

## Extensiones Option

**Nota:** Para obtener valores con `getOrElse`, convertir a `Either` o `nullable`, o filtrar, usa los métodos nativos de fpdart: `getOrElse()`, `toEither()`, `toNullable()` y `filter()`.

### `onSome(void Function(T value) f)`

Ejecuta una acción cuando hay un valor, sin modificar el Option.

**Con extensión:**
```dart
userOption
  .onSome((user) => logger.i('Usuario: $user'))
  .match(
    () => print('No hay usuario'),
    (user) => print('Usuario encontrado'),
  );
```

**Sin extensión:**
```dart
userOption.match(
  () => print('No hay usuario'),
  (user) {
    logger.i('Usuario: $user');
    print('Usuario encontrado');
  },
);
```

**Ventaja:** Permite separar side effects de la lógica de negocio y encadenar operaciones.

---

### `onNone(void Function() f)`

Ejecuta una acción cuando no hay valor, sin modificar el Option.

**Con extensión:**
```dart
userOption
  .onNone(() => logger.w('No hay usuario'))
  .match(
    () => print('No hay usuario'),
    (user) => print('Usuario: ${user.name}'),
  );
```

**Sin extensión:**
```dart
userOption.match(
  () {
    logger.w('No hay usuario');
    print('No hay usuario');
  },
  (user) => print('Usuario: ${user.name}'),
);
```

**Ventaja:** Permite separar logging de la lógica de negocio y mantener el código más limpio.

---

### `isSome` / `isNone`

Indican si el Option contiene un valor o no.

**Con extensión:**
```dart
if (userOption.isSome) {
  print('Hay usuario');
} else if (userOption.isNone) {
  print('No hay usuario');
}
```

**Sin extensión:**
```dart
if (userOption.isSome()) {
  print('Hay usuario');
} else if (userOption.isNone()) {
  print('No hay usuario');
}
```

**Ventaja:** Los getters son más convenientes que los métodos (sin paréntesis).

---

### `getOrThrow(Exception Function() onNone)`

Obtiene el valor o lanza una excepción si es None.

**Con extensión:**
```dart
final user = userOption.getOrThrow(() => Exception('Usuario no encontrado'));
print('Usuario: ${user.name}');
```

**Sin extensión:**
```dart
final user = userOption.match(
  () => throw Exception('Usuario no encontrado'),
  (user) => user,
);
print('Usuario: ${user.name}');
```

**Ventaja:** Más legible y expresivo para casos donde esperas un Some.

---

## Extensiones Task

### `toEither<L>(L Function(Object error, StackTrace stackTrace) onError)`

Ejecuta la tarea y retorna un Either con el resultado o el error.

**Con extensión:**
```dart
final task = Task(() async => await api.getData());
final result = await task.toEither((error, stack) => ServerFailure('Error: $error'));
result.fold(
  (failure) => emit(DataState.error(failure)),
  (data) => emit(DataState.loaded(data)),
);
```

**Sin extensión:**
```dart
Either<ServerFailure, Data> result;
try {
  final data = await api.getData();
  result = Right(data);
} catch (error, stack) {
  result = Left(ServerFailure('Error: $error'));
}
result.fold(
  (failure) => emit(DataState.error(failure)),
  (data) => emit(DataState.loaded(data)),
);
```

**Ventaja:** Convierte automáticamente excepciones a Either de forma funcional y consistente.

---

### `toEitherFailure()`

Ejecuta la tarea y retorna un Either con Failure si hay error.

**Con extensión:**
```dart
final task = Task(() async => await api.getData());
final result = await task.toEitherFailure();
result.reportLeft().fold(
  (failure) => emit(DataState.error(failure)),
  (data) => emit(DataState.loaded(data)),
);
```

**Sin extensión:**
```dart
Either<Failure, Data> result;
try {
  final data = await api.getData();
  result = Right(data);
} catch (error, stack) {
  result = Left(UnknownFailure('Error en tarea: $error', stack));
}
result.fold(
  (failure) {
    getIt<ErrorNotifierCubit>().notifyError(failureToException(failure));
    emit(DataState.error(failure));
  },
  (data) => emit(DataState.loaded(data)),
);
```

**Ventaja:** Simplifica la conversión de Task a Either con Failure automático.

---

## Extensiones TaskEither

### `reportLeft()` - Solo para `TaskEither<Failure, R>`

Ejecuta la tarea y reporta el error si es un Failure.

**Con extensión:**
```dart
final taskEither = TaskEither(() async => await getUserUseCase(userId));
final result = await taskEither.reportLeft();
result.fold(
  (failure) => emit(UserState.error(failure)),
  (user) => emit(UserState.loaded(user)),
);
```

**Sin extensión:**
```dart
final taskEither = TaskEither(() async => await getUserUseCase(userId));
final result = await taskEither.run();
result.fold(
  (failure) {
    getIt<ErrorNotifierCubit>().notifyError(failureToException(failure));
    emit(UserState.error(failure));
  },
  (user) => emit(UserState.loaded(user)),
);
```

**Ventaja:** Automatiza el reporte de errores sin duplicar código en cada uso.

---

## Extensiones Unit

### `toEither<L>()`

Convierte Unit a un Either exitoso.

**Con extensión:**
```dart
final result = unit.toEither<Failure>();
result.fold(
  (failure) => print('Error'),
  (_) => print('Éxito'),
);
```

**Sin extensión:**
```dart
final result = const Right<Failure, Unit>(unit);
result.fold(
  (failure) => print('Error'),
  (_) => print('Éxito'),
);
```

**Ventaja:** Más expresivo y claro sobre la intención de convertir Unit a Either.

---

### `isSuccess`

Indica que la operación fue exitosa.

**Con extensión:**
```dart
if (unit.isSuccess) {
  print('Operación exitosa');
}
```

**Sin extensión:**
```dart
// Unit siempre representa éxito, pero no hay forma directa de verificarlo
// Tendrías que usar: const Right<Failure, Unit>(unit).isRight()
```

**Ventaja:** Proporciona una forma clara y expresiva de verificar que Unit representa éxito.

---

## Ejecutar Peticiones en Paralelo

Para ejecutar múltiples peticiones en paralelo, tienes varias opciones según tus necesidades:

### Opción 1: `Future.wait` con `Either` (Recomendado para casos simples)

**Ejemplo:**
```dart
// Ejecutar dos peticiones en paralelo
final results = await Future.wait([
  getUserUseCase(userId1),
  getUserUseCase(userId2),
]);

// Procesar resultados
for (final result in results) {
  result.reportLeft().fold(
    (failure) => logger.e('Error: ${failure.message}'),
    (user) => logger.i('Usuario: ${user.name}'),
  );
}
```

**Ventaja:** Simple y directo, funciona con cualquier `Future<Either<Failure, T>>`.

---

### Opción 2: `Future.wait` con `TaskEither` (Recomendado para composición funcional)

**Con TaskEither:**
```dart
final task1 = TaskEither(() async => getUserUseCase(userId1));
final task2 = TaskEither(() async => getUserUseCase(userId2));

final results = await Future.wait([
  task1.run(),
  task2.run(),
]);

// Procesar y reportar errores
for (final result in results) {
  result.fold(
    (failure) {
      getIt<ErrorNotifierCubit>().notifyError(failureToException(failure));
      logger.e('Error: ${failure.message}');
    },
    (user) => logger.i('Usuario: ${user.name}'),
  );
}
```

**Ventaja:** Mantiene el estilo funcional de fpdart y permite composición.

---

### Opción 3: Extensión `runParallel()` (Recomendado para múltiples TaskEither)

**Con extensión:**
```dart
final task1 = TaskEither(() async => getUserUseCase(userId1));
final task2 = TaskEither(() async => getUserUseCase(userId2));

final results = await [task1, task2].runParallel();

// Procesar resultados
for (final result in results) {
  result.reportLeft().fold(
    (failure) => logger.e('Error: ${failure.message}'),
    (user) => logger.i('Usuario: ${user.name}'),
  );
}
```

**Sin extensión:**
```dart
final task1 = TaskEither(() async => getUserUseCase(userId1));
final task2 = TaskEither(() async => getUserUseCase(userId2));

final results = await Future.wait([
  task1.run(),
  task2.run(),
]);

// Procesar resultados
for (final result in results) {
  result.fold(
    (failure) {
      getIt<ErrorNotifierCubit>().notifyError(failureToException(failure));
      logger.e('Error: ${failure.message}');
    },
    (user) => logger.i('Usuario: ${user.name}'),
  );
}
```

**Ventaja:** Más conciso cuando trabajas con múltiples `TaskEither`.

---

### Opción 4: Extensión `runParallelAndReport()` (Recomendado para reporte automático)

**Con extensión:**
```dart
final task1 = TaskEither(() async => getUserUseCase(userId1));
final task2 = TaskEither(() async => getUserUseCase(userId2));

final results = await [task1, task2].runParallelAndReport();

// Procesar resultados (errores ya reportados)
for (final result in results) {
  result.fold(
    (failure) => emit(UserState.error(failure)),
    (user) => emit(UserState.loaded(user)),
  );
}
```

**Sin extensión:**
```dart
final task1 = TaskEither(() async => getUserUseCase(userId1));
final task2 = TaskEither(() async => getUserUseCase(userId2));

final results = await Future.wait([
  task1.run(),
  task2.run(),
]);

// Reportar errores primero
for (final result in results) {
  result.fold(
    (failure) => getIt<ErrorNotifierCubit>().notifyError(failureToException(failure)),
    (_) {},
  );
}

// Procesar resultados
for (final result in results) {
  result.fold(
    (failure) => emit(UserState.error(failure)),
    (user) => emit(UserState.loaded(user)),
  );
}
```

**Ventaja:** Automatiza el reporte de errores para todas las peticiones en paralelo.

---

### Comparación de Opciones

| Opción | Cuándo Usar | Ventajas |
|--------|-------------|----------|
| `Future.wait` con `Either` | Peticiones simples que ya retornan `Either` | Simple, directo, sin conversión |
| `Future.wait` con `TaskEither` | Cuando necesitas composición funcional | Mantiene estilo fpdart, composable |
| `runParallel()` | Múltiples `TaskEither` sin reporte automático | Más conciso, funcional |
| `runParallelAndReport()` | Múltiples `TaskEither` con reporte automático | Reporte automático, menos código |

---

## Extensiones Reader

**Nota:** Para transformar y encadenar Readers, usa los métodos nativos de fpdart: `map()` y `flatMap()`.

---

## Ejemplos Completos

### Ejemplo 1: Manejo de Errores con Logging (Either)

```dart
Future<void> _loadUserProfile(String userId) async {
  final result = await getUserProfileUseCase(userId);
  
  result
    .onLeft((failure) => logger.e('Error: ${failure.message}'))
    .onRight((profile) => logger.i('Perfil cargado: ${profile.id}'))
    .fold(
      (failure) => emit(ProfileState.error(failure)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
}
```

**Salida esperada:**
- Si hay error: Se loguea el error y se emite `ProfileState.error`
- Si es exitoso: Se loguea el éxito y se emite `ProfileState.loaded`

---

### Ejemplo 2: Valor por Defecto con Reporte (Either)

```dart
Future<void> _loadSettings() async {
  final result = await getSettingsUseCase();
  
  final settings = result
    .reportLeft()
    .getOrElse(() => Settings.defaultSettings());
  
  emit(SettingsState.loaded(settings));
}
```

**Salida esperada:**
- Si hay error: Se reporta al sistema y se usa `Settings.defaultSettings()`
- Si es exitoso: Se usa la configuración obtenida

---

### Ejemplo 3: Manejo de Valores Opcionales (Option)

```dart
Future<void> _loadUser() async {
  final userOption = repository.currentUser;
  
  userOption
    .onSome((user) => logger.i('Usuario encontrado: ${user.email}'))
    .onNone(() => logger.w('No hay usuario autenticado'));
  
  final username = userOption.getOrElse(() => 'Guest');
  emit(UserState.loaded(username));
}
```

**Salida esperada:**
- Si hay usuario: Se loguea el usuario y se usa su nombre
- Si no hay usuario: Se loguea la advertencia y se usa 'Guest'

---

### Ejemplo 4: Operaciones Asíncronas (Task)

```dart
Future<void> _processData() async {
  final task = Task(() async {
    await Future.delayed(Duration(seconds: 1));
    return 'Datos procesados';
  });
  
  final result = await task.toEitherFailure();
  
  result.reportLeft().fold(
    (failure) => emit(DataState.error(failure)),
    (data) => emit(DataState.loaded(data)),
  );
}
```

**Salida esperada:**
- Si hay error: Se reporta y se emite `DataState.error`
- Si es exitoso: Se emite `DataState.loaded` con los datos procesados

---

### Ejemplo 5: TaskEither con Reporte

```dart
Future<void> _syncData() async {
  final taskEither = TaskEither<Failure, SyncResult>(
    () async => await syncUseCase(),
  );
  
  final result = await taskEither.reportLeft();
  
  result.fold(
    (failure) => emit(SyncState.error(failure)),
    (syncResult) => emit(SyncState.completed(syncResult)),
  );
}
```

**Salida esperada:**
- Si hay error: Se reporta automáticamente y se emite `SyncState.error`
- Si es exitoso: Se emite `SyncState.completed` con el resultado

---

### Ejemplo 6: Unit para Operaciones Sin Retorno

```dart
Future<void> _deleteItem(String id) async {
  final result = await deleteItemUseCase(id);
  
  result.reportLeft().fold(
    (failure) => emit(DeleteState.error(failure)),
    (_) {
      // Unit no tiene valor, solo indica éxito
      final successResult = unit.toEither<Failure>();
      emit(DeleteState.success());
    },
  );
}
```

**Salida esperada:**
- Si hay error: Se reporta y se emite `DeleteState.error`
- Si es exitoso: Se emite `DeleteState.success` (Unit indica éxito sin valor)

---

### Ejemplo 7: Ejecutar Peticiones en Paralelo

```dart
Future<void> _loadUserData(String userId) async {
  // Opción 1: Future.wait con Either (más simple)
  final results = await Future.wait([
    getUserUseCase(userId),
    getUserProfileUseCase(userId),
    getUserSettingsUseCase(userId),
  ]);

  // Procesar y reportar errores
  for (final result in results) {
    result.reportLeft().fold(
      (failure) => logger.e('Error cargando datos: ${failure.message}'),
      (data) => logger.i('Dato cargado exitosamente'),
    );
  }

  // Opción 2: Con TaskEither y extensión (más funcional)
  final tasks = [
    TaskEither(() async => getUserUseCase(userId)),
    TaskEither(() async => getUserProfileUseCase(userId)),
    TaskEither(() async => getUserSettingsUseCase(userId)),
  ];

  final taskResults = await tasks.runParallelAndReport();

  // Procesar resultados (errores ya reportados)
  taskResults[0].fold(
    (failure) => emit(UserState.error(failure)),
    (user) => emit(UserState.loaded(user)),
  );
}
```

**Salida esperada:**
- Todas las peticiones se ejecutan en paralelo (más rápido)
- Si hay errores, se reportan automáticamente
- Los resultados se procesan de forma independiente

---

### Ejemplo 8: Uso de Métodos Nativos de fpdart

```dart
// Usar métodos nativos de fpdart para Option
final userOption = repository.currentUser;
final username = userOption.getOrElse(() => 'Guest'); // Método nativo
final either = userOption.toEither(() => UserNotFoundFailure()); // Método nativo

// Usar métodos nativos de fpdart para Reader
final configReader = Reader<AppConfig, String>(
  (config) => config.apiUrl,
);
final urlReader = configReader.map((url) => Uri.parse(url)); // Método nativo
final fullUrlReader = urlReader.flatMap(
  (uri) => Reader((config) => uri.resolve('/api/users')),
); // Método nativo
```

**Salida esperada:**
- Los métodos nativos de fpdart proporcionan toda la funcionalidad necesaria
- Usa las extensiones solo cuando agreguen valor específico (side effects, reporte, etc.)

---

## Mejores Prácticas

1. **Siempre usa `reportLeft()`** cuando trabajes con `Either<Failure, R>` o `TaskEither<Failure, R>` para asegurar que todos los errores se reporten al sistema global.

2. **Encadena métodos** para mantener el código limpio y legible:
   ```dart
   result.reportLeft().onLeft(...).onRight(...).fold(...)
   ```

3. **Usa `getOrElse()`** cuando necesites un valor seguro sin manejar el error explícitamente.

4. **Usa `isRight`/`isLeft`** o `isSome`/`isNone`** para validaciones rápidas antes de procesar el resultado.

5. **Combina `onLeft`/`onRight`** o `onSome`/`onNone`** con `reportLeft()` para logging y reporte sin duplicar código.

6. **Usa `Task` y `TaskEither`** para operaciones asíncronas complejas que requieren composición funcional.

7. **Usa `Option`** en lugar de valores nullable cuando quieras manejar la ausencia de valores de forma explícita. Usa métodos nativos como `getOrElse()`, `toEither()`, `toNullable()`, `filter()`.

8. **Usa `Unit`** para operaciones que solo necesitan indicar éxito o error sin retornar datos.

9. **Prefiere métodos nativos de fpdart** cuando estén disponibles. Las extensiones solo agregan valor cuando proporcionan funcionalidad específica del proyecto (como `reportLeft()`).

---

## Notas Importantes

- `reportLeft()` solo reporta errores, no los muestra al usuario. Debes manejar la UI en el `fold()`.
- `onLeft()` y `onRight()` no modifican el resultado, solo ejecutan acciones secundarias.
- `onSome()` y `onNone()` funcionan igual para Option.
- `getOrElse()` en Either es una versión simplificada (sin parámetro L) del método nativo de fpdart.
- `isRight`/`isLeft` e `isSome`/`isNone` son getters más convenientes que los métodos nativos.
- Todos los errores deben pasar por `failureToException()` para mantener consistencia en el sistema de reporte.
- Para métodos como `map`, `flatMap`, `getOrElse`, `toEither`, `toNullable`, `filter` en Option y Reader, usa los métodos nativos de fpdart.