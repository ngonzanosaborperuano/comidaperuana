# Guía de Interacción con Gemini para el Proyecto de Recetas Peruanas

Este archivo proporciona una guía sobre cómo puedes instruirme para ayudarte con el desarrollo de esta aplicación de Flutter.

## Comandos Comunes

A continuación, se presentan algunos comandos de ejemplo que puedes usar para solicitar acciones comunes.

### Ejecutar la Aplicación

Para compilar y ejecutar la aplicación en un dispositivo conectado:

```bash
flutter run
```

### Generación de Código

Si agregas nuevos modelos que requieren `json_serializable` o cualquier otra dependencia que genere código, puedes usar:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Ejecutar Pruebas

Para ejecutar el conjunto de pruebas unitarias y de widgets:

```bash
flutter test
```

### Actualizar Dependencias

Para obtener las dependencias del proyecto listadas en `pubspec.yaml`:

```bash
flutter pub get
```

### Internacionalización

Para actualizar los archivos de localización (`.arb`):

```bash
flutter gen-l10n
```

## Estructura de Archivos

La estructura del proyecto sigue un enfoque modular y por capas:

-   `lib/core`: Contiene la lógica central y los servicios compartidos en toda la aplicación (autenticación, red, base de datos, etc.).
-   `lib/modules`: Cada subdirectorio representa una característica o módulo de la aplicación (por ejemplo, `home`, `login`, `recipe_details`).
-   `lib/shared`: Widgets, modelos y repositorios compartidos que no son parte del `core` pero son utilizados por múltiples módulos.
-   `lib/l10n`: Archivos de localización para la internacionalización.
-   `test`: Contiene todas las pruebas unitarias y de widgets.

## Tareas de Desarrollo

Puedes pedirme que realice tareas como:

-   **"Crea un nuevo módulo llamado 'favorites' con su propia ruta y vista."**
-   **"Agrega un nuevo campo 'preparation_time' al modelo de receta y actualiza la base de datos y la UI."**
-   **"Implementa la lógica para el inicio de sesión con Google usando Firebase Auth."**
-   **"Refactoriza el widget `RecipeCard` para mejorar su diseño."**
-   **"Escribe pruebas unitarias para el `AuthRepository`."**
