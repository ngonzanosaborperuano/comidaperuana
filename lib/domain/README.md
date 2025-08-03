# Domain Layer - DDD Implementation

## Estructura de Dominios

### Auth Domain

- **Entities**: User, AuthSession
- **Value Objects**: Email, Password, UserId
- **Aggregates**: UserAggregate
- **Repositories**: IUserRepository
- **Services**: IAuthService
- **Use Cases**: LoginUseCase, RegisterUseCase, LogoutUseCase

### Recipe Domain

- **Entities**: Recipe, Ingredient, Step
- **Value Objects**: RecipeId, RecipeTitle, CookingTime
- **Aggregates**: RecipeAggregate
- **Repositories**: IRecipeRepository
- **Services**: IRecipeService
- **Use Cases**: CreateRecipeUseCase, GetRecipesUseCase, SearchRecipesUseCase

### Payment Domain

- **Entities**: Payment, Transaction
- **Value Objects**: PaymentId, Amount, Currency
- **Aggregates**: PaymentAggregate
- **Repositories**: IPaymentRepository
- **Services**: IPaymentService
- **Use Cases**: ProcessPaymentUseCase, GetPaymentStatusUseCase

## Principios DDD Implementados

- ✅ Bounded Contexts claros
- ✅ Entidades con identidad
- ✅ Value Objects inmutables
- ✅ Aggregates con invariantes
- ✅ Domain Services para lógica compleja
- ✅ Use Cases para operaciones de aplicación
