# HPanelX - Clean Architecture Flutter Application

## Architecture Overview

This project follows Clean Architecture principles with a strict adherence to SOLID principles and clean code practices. The application is structured into distinct layers with clear separation of concerns.

### Class Hierarchy

The project follows a modular approach with the following layers:

1. **Presentation Layer**
   - Widgets, Pages, and Screens
   - BLoCs (Business Logic Components)
   - State Management

2. **Domain Layer**
   - Use Cases
   - Entities
   - Repository Interfaces

3. **Data Layer**
   - Repository Implementations
   - Data Sources (Remote and Local)
   - Models (DTOs)

4. **Core**
   - Common utilities and services
   - Error handling
   - Dependency injection
   - Routing

### Design Patterns Used

- **Repository Pattern**: Abstracts the data sources from the domain layer
- **Dependency Injection**: Using get_it for service locator pattern
- **BLoC Pattern**: For state management
- **Factory Pattern**: For creating objects without specifying the exact class
- **Adapter Pattern**: For adapting data models between layers
- **Strategy Pattern**: For interchangeable algorithms

## Folder Structure

```
lib/
├── src/
│   ├── core/                     # Core shared components
│   │   ├── api/                  # API client and utilities
│   │   ├── config/               # Configuration
│   │   ├── constants/            # Constants
│   │   ├── di/                   # Dependency injection
│   │   ├── error/                # Error handling
│   │   ├── global/               # Global services
│   │   ├── keys/                 # App keys
│   │   ├── localization/         # Internationalization
│   │   ├── middleware/           # Middleware
│   │   ├── network/              # Network utilities
│   │   ├── routes/               # Routing
│   │   ├── services/             # Services
│   │   ├── theme/                # Theme and styling
│   │   ├── usecases/             # Base use cases
│   │   ├── utils/                # Utilities
│   │   └── widgets/              # Shared widgets
│   │
│   └── modules/                  # Feature modules
│       ├── billing/              # Billing module
│       │   ├── data/             # Data layer
│       │   │   ├── datasources/  # Data sources
│       │   │   ├── models/       # Data models
│       │   │   └── repositories/ # Repository implementations
│       │   ├── domain/           # Domain layer
│       │   │   ├── entities/     # Entities
│       │   │   ├── repositories/ # Repository interfaces
│       │   │   └── usecases/     # Use cases
│       │   └── presentation/     # Presentation layer
│       │       ├── bloc/         # BLoC components
│       │       ├── cubit/        # Cubits
│       │       ├── pages/        # Pages
│       │       └── widgets/      # Module-specific widgets
│       │
│       ├── domains/              # Domains module
│       ├── home/                 # Home module
│       ├── startup/              # Startup module
│       └── vms/                  # Virtual Machines module
│
├── main.dart                     # Application entry point
└── hpanelx.dart                  # Main application widget
```

## Key Features

- **Token Authentication**: Secure storage and management of API tokens
- **Responsive UI**: Adapts to different screen sizes using ResponsiveHelper
- **Error Handling**: Comprehensive error handling for smooth user experience
- **Navigation**: Clean, declarative navigation using go_router
- **API Integration**: Robust API client with Dio for interacting with backend services
- **State Management**: Using BLoC pattern for predictable state management
- **Dependency Injection**: Using get_it for service locator pattern

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Dependencies

- **go_router**: For navigation
- **dio**: For API requests
- **flutter_bloc**: For state management
- **shared_preferences**: For local storage
- **dartz**: For functional programming (Either)
- **equatable**: For efficient comparisons
- **get_it**: For dependency injection
- **lottie**: For animations
- **shimmer**: For loading effects
- **intl**: For internationalization

## Adding New Features

To add a new feature to the application, follow these steps:

1. **Create Entities** in the domain layer
2. **Define Repository Interfaces** in the domain layer
3. **Create Use Cases** in the domain layer
4. **Implement Repositories** in the data layer
5. **Create Data Models** in the data layer
6. **Implement Data Sources** in the data layer
7. **Create BLoC/Cubit** in the presentation layer
8. **Create UI** in the presentation layer

## Using Responsive Design

The application uses a custom ResponsiveHelper to ensure consistent UI across different device sizes:

```dart
// Check device type
final isMobile = ResponsiveHelper.isMobile(context);
final isTablet = ResponsiveHelper.isTablet(context);
final isDesktop = ResponsiveHelper.isDesktop(context);

// Get responsive values
final padding = ResponsiveHelper.responsivePadding(context);
final spacing = ResponsiveHelper.responsiveSpacing(context);
final fontSize = ResponsiveHelper.responsiveFontSize(context, 14);

// Use responsive builder
ResponsiveBuilder(
  builder: (context, isMobile, isTablet, isDesktop) {
    if (isDesktop) {
      return DesktopLayout();
    } else if (isTablet) {
      return TabletLayout();
    } else {
      return MobileLayout();
    }
  },
)
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
