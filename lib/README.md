# HPanelX Source Code

This directory contains the source code for the HPanelX Flutter application. The application follows clean architecture principles with a clear separation of concerns.

## Project Structure

```
lib/
├── main.dart                     # Application entry point
├── hpanelx.dart                  # Main application widget
└── src/                          # Source code
    ├── core/                     # Core components
    │   ├── api/                  # API client and utilities
    │   ├── config/               # Configuration
    │   ├── constants/            # Constants
    │   ├── di/                   # Dependency injection
    │   ├── error/                # Error handling
    │   ├── global/               # Global services
    │   ├── keys/                 # App keys
    │   ├── localization/         # Internationalization
    │   ├── middleware/           # Middleware
    │   ├── network/              # Network utilities
    │   ├── routes/               # Routing
    │   ├── services/             # Services
    │   ├── theme/                # Theme and styling
    │   ├── usecases/             # Base use cases
    │   ├── utils/                # Utilities
    │   └── widgets/              # Shared widgets
    │
    └── modules/                  # Feature modules
        ├── billing/              # Billing module
        ├── domains/              # Domains module
        ├── home/                 # Home module
        ├── startup/              # Startup module
        └── vms/                  # Virtual Machines module
```

## Architecture

The application follows clean architecture principles with the following layers:

1. **Presentation Layer** - UI components and state management
   - Widgets, Pages, and Screens
   - BLoCs (Business Logic Components)
   - State Management

2. **Domain Layer** - Business logic
   - Use Cases
   - Entities
   - Repository Interfaces

3. **Data Layer** - Data access and manipulation
   - Repository Implementations
   - Data Sources (Remote and Local)
   - Models (DTOs)

## Module Structure

Each feature module follows the same structure:

```
module/
├── data/                 # Data layer
│   ├── datasources/      # Data sources
│   ├── models/           # Data models
│   └── repositories/     # Repository implementations
├── domain/               # Domain layer
│   ├── entities/         # Entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Use cases
└── presentation/         # Presentation layer
    ├── bloc/             # BLoC components
    ├── cubit/            # Cubits
    ├── pages/            # Pages
    └── widgets/          # Module-specific widgets
```

## Dependency Injection

The application uses `get_it` for dependency injection. All dependencies are registered in `lib/src/core/di/injection_container.dart`.

## Routing

The application uses `go_router` for navigation. Routes are defined in `lib/src/core/routes/app_router.dart`.

## Responsive Design

The application uses a custom `ResponsiveHelper` to ensure consistent UI across different device sizes. The responsive utilities are in `lib/src/core/utils/responsive_helper.dart`.

## API Integration

The application uses `dio` for API requests. The API client is defined in `lib/src/core/api/api_client.dart`. 