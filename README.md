# HPanelX - Responsive Hosting Control Panel

A modern, responsive Flutter application for managing hosting services including domains, virtual machines, and billing subscriptions.

## Features

- **Clean Architecture**: Clear separation of concerns with domain, data, and presentation layers
- **Responsive Design**: Adapts to mobile, tablet, and desktop screen sizes
- **Theme Support**: Light, dark, and system theme modes
- **State Management**: Using BLoC pattern for predictable state management
- **Navigation**: Declarative routing using GoRouter
- **API Integration**: Production-ready API client with proper error handling
- **Dependency Injection**: Service locator pattern using GetIt
- **Environment Support**: Development, staging, and production environments

## Screenshots

![App Screenshot](docs/screenshots/app_screenshot.png)

## Tech Stack

- **Flutter**: UI framework
- **Dart**: Programming language
- **BLoC/Cubit**: State management
- **GoRouter**: Navigation
- **Dio**: HTTP client
- **GetIt**: Dependency injection
- **Dartz**: Functional programming
- **SharedPreferences**: Local storage

## Project Structure

```
lib/
├── src/
│   ├── core/                     # Core shared components
│   │   ├── api/                  # API client and utilities
│   │   ├── di/                   # Dependency injection
│   │   ├── error/                # Error handling
│   │   ├── middleware/           # Middleware
│   │   ├── routes/               # Routing
│   │   ├── theme/                # Theme and styling
│   │   ├── utils/                # Utilities
│   │   └── widgets/              # Shared widgets
│   │
│   └── modules/                  # Feature modules
│       ├── billing/              # Billing module
│       │   ├── data/             # Data layer
│       │   ├── domain/           # Domain layer
│       │   └── presentation/     # Presentation layer
│       ├── domains/              # Domains module
│       ├── home/                 # Home module
│       ├── startup/              # Startup module
│       └── vms/                  # Virtual Machines module
│
├── main.dart                     # Application entry point
└── hpanelx.dart                  # Main application widget
```

## Getting Started

### Prerequisites

- Flutter SDK (3.2.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository

```sh
git clone https://github.com/yourusername/hpanelx.git
cd hpanelx
```

2. Install dependencies

```sh
flutter pub get
```

3. Run the application

```sh
# For development environment
flutter run --dart-define=ENVIRONMENT=development

# For staging environment
flutter run --dart-define=ENVIRONMENT=staging

# For production environment
flutter run --dart-define=ENVIRONMENT=production
```

## Building for Production

### App Icons and Splash Screen

For production apps, you should customize the app icons and splash screen. Add the following to your pubspec.yaml:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.8

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"
  min_sdk_android: 21
  web:
    generate: false
  windows:
    generate: false
  macos:
    generate: false

flutter_native_splash:
  color: "#6C63FF"
  image: assets/icons/splash_logo.png
  android_12:
    image: assets/icons/splash_logo.png
    color: "#6C63FF"
  fullscreen: true
```

Then generate the assets:

```sh
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### Android

To build a release APK:

```sh
flutter build apk --dart-define=ENVIRONMENT=production
```

The APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`

To build an App Bundle (recommended for Play Store submission):

```sh
flutter build appbundle --dart-define=ENVIRONMENT=production
```

The Bundle will be available at:
`build/app/outputs/bundle/release/app-release.aab`

### iOS

To build a release IPA:

```sh
flutter build ipa --dart-define=ENVIRONMENT=production
```

The IPA will be available at:
`build/ios/ipa/HPanelX.ipa`

## Responsive Design

The application uses the ResponsiveHelper class to ensure a consistent UI across different device sizes:

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

## State Management

The application uses BLoC and Cubit for state management. These are registered in the dependency injection container (`lib/src/core/di/injection_container.dart`) and accessed via BlocProvider in the UI:

```dart
// Register in dependency injection
sl.registerFactory<HomeBloc>(() => HomeBloc(
  getServersUseCase: sl(),
  getDomainsUseCase: sl(),
  checkTokenUseCase: sl(),
));

// Access in UI
BlocProvider<HomeBloc>(
  create: (context) => di.sl<HomeBloc>(),
  child: const HomePage(),
)

// Use in widget
context.read<HomeBloc>().add(LoadHomeData());
```

## Adding New Features

To add a new feature to the application, follow these steps:

1. Create a new module in `lib/src/modules/`
2. Implement the layers:
   - **Domain**: Entities, repositories (interfaces), use cases
   - **Data**: Models, repositories (implementations), data sources
   - **Presentation**: Bloc/Cubit, pages, widgets
3. Register dependencies in `lib/src/core/di/injection_container.dart`
4. Add routes in `lib/src/core/routes/app_router.dart`

## Environment Configuration

The application supports multiple environments that can be configured at build time:

```dart
// Set with build flag
flutter run --dart-define=ENVIRONMENT=production

// Access in code
const environment = String.fromEnvironment(
  'ENVIRONMENT',
  defaultValue: 'development',
);
```

## Contribution Guidelines

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -am 'Add new feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Flutter](https://flutter.dev)
- [Bloc Library](https://bloclibrary.dev)
- [GoRouter](https://pub.dev/packages/go_router)
- [GetIt](https://pub.dev/packages/get_it)
- [Dio](https://pub.dev/packages/dio)

---

Developed by [Your Name](https://github.com/yourusername)
