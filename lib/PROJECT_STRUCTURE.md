# Flutter Project Structure - Clean Architecture with GetX

This project follows a clean architecture pattern with GetX for state management and dependency injection.

## Project Structure

```
lib/
├── core/                     # Core functionality used across the app
│   ├── constants/           # App-wide constants (API URLs, storage keys, etc.)
│   ├── services/           # Global services (network, storage)
│   ├── utils/              # Utility functions (validators, formatters)
│   └── theme/              # App theme and styling
│
├── data/                    # Data layer (external data sources)
│   ├── models/             # Data models that extend domain entities
│   ├── datasources/        # API calls and external data sources
│   └── repositories/       # Repository implementations
│
├── domain/                  # Business logic layer
│   ├── entities/           # Plain business objects
│   ├── repositories/       # Repository contracts/interfaces
│   └── usecases/          # Business logic use cases
│
├── presentation/            # UI layer
│   ├── bindings/           # GetX dependency injection bindings
│   ├── controllers/        # GetX controllers for state management
│   ├── screens/            # UI screens organized by feature
│   │   ├── dashboard/
│   │   ├── login/
│   │   ├── profile/
│   │   └── data_list/
│   └── widgets/            # Reusable UI components
│
├── routes/                  # App routing configuration
│   └── app_pages.dart      # GetX route definitions
│
├── app_exports.dart         # Barrel file for easy imports
└── main.dart               # App entry point
```

## Key Features Implemented

### 1. Authentication Flow

- Login screen with form validation
- Token-based authentication
- Automatic route protection
- Logout functionality

### 2. State Management (GetX)

- Reactive state management
- Dependency injection via bindings
- Navigation management
- Snackbar notifications

### 3. Local Storage

- Secure token storage
- User data persistence
- App preferences

### 4. Network Layer

- HTTP client with Dio
- Request/response interceptors
- Error handling
- Authentication headers

### 5. UI Components

- Custom buttons and text fields
- Loading and error states
- Responsive design
- Material 3 theming

### 6. Clean Architecture

- Separation of concerns
- Testable code structure
- Repository pattern
- Use case pattern

## Getting Started

1. **Install dependencies:**

   ```bash
   flutter pub get
   ```

2. **Run the app:**

   ```bash
   flutter run
   ```

3. **Login credentials (demo):**
   - Any email and password combination will work
   - The app uses mock data for demonstration

## Architecture Benefits

- **Maintainable**: Clear separation of layers makes code easy to maintain
- **Testable**: Each layer can be tested independently
- **Scalable**: Easy to add new features without affecting existing code
- **Flexible**: Can easily swap implementations (e.g., change from REST to GraphQL)

## Adding New Features

1. **Create entity** in `domain/entities/`
2. **Define repository contract** in `domain/repositories/`
3. **Create use cases** in `domain/usecases/`
4. **Implement data model** in `data/models/`
5. **Create data source** in `data/datasources/`
6. **Implement repository** in `data/repositories/`
7. **Create controller** in `presentation/controllers/`
8. **Build UI screen** in `presentation/screens/`
9. **Add binding** in `presentation/bindings/`
10. **Define routes** in `routes/app_pages.dart`

## Dependencies Used

- **get**: State management and dependency injection
- **dio**: HTTP client
- **get_storage**: Local storage
- **intl**: Date formatting and internationalization

This structure provides a solid foundation for building scalable Flutter applications with clean architecture principles.
