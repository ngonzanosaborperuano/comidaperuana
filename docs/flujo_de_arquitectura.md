lib/
├── core/
│   ├── injection.dart          ← AQUÍ va toda la Dependency Inversion
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── material_theme.dart        // ThemeData
│   │   └── cupertino_theme.dart       // CupertinoThemeData
│   ├── ui/
│   │   ├── adaptive/
│   │   │   ├── adaptive_scaffold.dart
│   │   │   ├── adaptive_app_bar.dart
│   │   │   ├── adaptive_button.dart
│   │   │   ├── adaptive_card.dart
│   │   │   ├── adaptive_dialog.dart
│   │   │   ├── adaptive_menu.dart
│   │   │   ├── adaptive_loading.dart
│   │   │   └── adaptive_textfield.dart            
│   │   ├── material/
│   │   │   ├── material_button.dart
│   │   │   └── material_scaffold.dart
│   │   └── cupertino/
│   │       ├── cupertino_button.dart
│   │       └── cupertino_scaffold.dart
│   ├── utils/
│   │   ├── platform_utils.dart        // isIOS, isAndroid, etc.
│   │   ├── validators.dart
│   │   └── logger.dart
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   ├── string_extensions.dart
│   │   └── iterable_extensions.dart
│   ├── generics/
│   │   ├── result.dart                // Result/Either genérico
│   │   └── paginated_list.dart
│   ├── services/
│   │   ├── firebase_service.dart      // Inicializa Firebase
│   │   ├── local_storage_service.dart // SharedPreferences/Hive
│   │   ├── network_info.dart          // Conectividad
│   │   └── api_client.dart            // Cliente HTTP (Dio, http, etc.)
│   ├── errors/
│   │   ├── exceptions.dart            // ServerException, CacheException...
│   │   ├── failures.dart              // ServerFailure, AuthFailure...
│   │   └── error_mapper.dart          // Mapea Exception -> Failure
│   └── config/
│       ├── flavor_config.dart         // dev, prod, etc.
│       └── env.dart                   // claves, endpoints
│
├── common/
│   └── widgets/
│       ├── loading_indicator.dart
│       ├── empty_state.dart
│       └── error_view.dart
│
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── user_model.dart
    │   │   │   └── auth_token_model.dart
    │   │   ├── sources/                      // <── NUEVO nombre
    │   │   │   ├── auth_api_source.dart
    │   │   │   ├── auth_local_source.dart
    │   │   │   └── auth_firestore_source.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart
    │   │   ├── repositories/
    │   │   │   └── i_auth_repository.dart     // <── interfaz (IUserRepository)
    │   │   └── usecases/
    │   │       ├── login_usecase.dart
    │   │       ├── register_usecase.dart
    │   │       ├── logout_usecase.dart
    │   │       └── get_current_user_usecase.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── register_page.dart
    │       └── widgets/
    │           ├── login_form.dart
    │           ├── register_form.dart
    │           └── auth_text_fields.dart
    │
    └── recipes/
        ├── data/
        │   ├── models/
        │   │   ├── recipe_model.dart
        │   │   ├── ingredient_model.dart
        │   │   └── nutrition_model.dart
        │   ├── sources/                      // <── api_source, local_source, firestore_source
        │   │   ├── recipes_api_source.dart
        │   │   ├── recipes_local_source.dart
        │   │   └── recipes_firestore_source.dart
        │   └── repositories/
        │       └── recipes_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   ├── recipe_entity.dart
        │   │   ├── ingredient_entity.dart
        │   │   └── nutrition_entity.dart
        │   ├── repositories/
        │   │   └── i_recipes_repository.dart  // <── interfaz (IItemRepository)
        │   └── usecases/
        │       ├── get_recipes_usecase.dart   // find_items.dart
        │       ├── get_recipe_detail_usecase.dart
        │       ├── search_recipes_usecase.dart
        │       ├── create_recipe_usecase.dart
        │       └── delete_recipe_usecase.dart
        └── presentation/
            ├── bloc/
            │   ├── recipes_bloc.dart
            │   ├── recipes_event.dart
            │   └── recipes_state.dart
            ├── pages/
            │   ├── recipes_list_page.dart
            │   └── recipe_detail_page.dart
            └── widgets/
                ├── recipe_card_content.dart     // contenido sin estilo
                ├── recipe_filters_bar.dart
                └── recipe_rating_stars.dart
