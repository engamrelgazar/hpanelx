# <div align="center">HPanelX</div>

<div align="center">

![HPanelX](docs/screenshots/app_screenshot.png)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.2.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.2.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Bloc](https://img.shields.io/badge/Bloc-8.1.3-blue)](https://bloclibrary.dev)

A modern, responsive Flutter application for managing hosting services including domains, virtual machines, and billing subscriptions.

</div>

## 📋 Table of Contents

- [✨ Features](#-features)
- [🖼️ Screenshots](#-screenshots)
- [🛠️ Tech Stack](#-tech-stack)
- [📂 Project Structure](#-project-structure)
- [🚀 Getting Started](#-getting-started)
- [🏗️ Building for Production](#-building-for-production)
- [📱 Responsive Design](#-responsive-design)
- [🧩 State Management](#-state-management)
- [➕ Adding New Features](#-adding-new-features)
- [🌐 Environment Configuration](#-environment-configuration)
- [🤝 Contribution Guidelines](#-contribution-guidelines)
- [📄 License](#-license)
- [👏 Acknowledgements](#-acknowledgements)
- [👨‍💻 Developer](#-developer)

## ✨ Features

- **🏛️ Clean Architecture**: Clear separation of concerns with domain, data, and presentation layers
- **📱 Responsive Design**: Adapts to mobile, tablet, and desktop screen sizes
- **🎨 Theme Support**: Light, dark, and system theme modes
- **🧩 State Management**: Using BLoC pattern for predictable state management
- **🧭 Navigation**: Declarative routing using GoRouter
- **🔌 API Integration**: Production-ready API client with proper error handling
- **💉 Dependency Injection**: Service locator pattern using GetIt
- **🌐 Environment Support**: Production environment configuration

## 🖼️ Screenshots

<div align="center">
  <img src="docs/screenshots/app_screenshot.png" alt="App Screenshot" width="600">
</div>

## 🛠️ Tech Stack

| Category | Technologies |
|----------|--------------|
| **Framework** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter) |
| **Language** | ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart) |
| **State Management** | ![Bloc](https://img.shields.io/badge/Bloc-8.1.3-blue) ![Cubit](https://img.shields.io/badge/Cubit-8.1.2-blue) |
| **Navigation** | ![GoRouter](https://img.shields.io/badge/GoRouter-13.0.0-brightgreen) |
| **Networking** | ![Dio](https://img.shields.io/badge/Dio-5.4.0-red) |
| **Storage** | ![SharedPreferences](https://img.shields.io/badge/SharedPreferences-2.2.2-orange) |
| **Utilities** | ![Dartz](https://img.shields.io/badge/Dartz-0.10.1-yellowgreen) ![GetIt](https://img.shields.io/badge/GetIt-7.6.4-blueviolet) |

## 📂 Project Structure

<details>
<summary>Click to expand the project structure</summary>

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
</details>

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.2.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio or VS Code with Flutter extensions

### Installation

<details>
<summary>Expand installation steps</summary>

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
# For production environment
flutter run --dart-define=ENVIRONMENT=production
```
</details>

## 🏗️ Building for Production

<details>
<summary>Expand build instructions</summary>

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
</details>

## 📱 Responsive Design

The application uses the ResponsiveHelper class to ensure a consistent UI across different device sizes:

<details>
<summary>View responsive design code example</summary>

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
</details>

## 🧩 State Management

The application uses BLoC and Cubit for state management:

<details>
<summary>View state management code example</summary>

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
</details>

## ➕ Adding New Features

<details>
<summary>View instructions for adding new features</summary>

To add a new feature to the application, follow these steps:

1. Create a new module in `lib/src/modules/`
2. Implement the layers:
   - **Domain**: Entities, repositories (interfaces), use cases
   - **Data**: Models, repositories (implementations), data sources
   - **Presentation**: Bloc/Cubit, pages, widgets
3. Register dependencies in `lib/src/core/di/injection_container.dart`
4. Add routes in `lib/src/core/routes/app_router.dart`
</details>

## 🌐 Environment Configuration

<details>
<summary>View environment configuration details</summary>

The application supports environment configuration at build time:

```dart
// Set with build flag
flutter run --dart-define=ENVIRONMENT=production

// Access in code
const environment = String.fromEnvironment(
  'ENVIRONMENT',
  defaultValue: 'development',
);
```
</details>

## 🤝 Contribution Guidelines

<details>
<summary>View contribution guidelines</summary>

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -am 'Add new feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Submit a pull request
</details>

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👏 Acknowledgements

- [Flutter](https://flutter.dev)
- [Bloc Library](https://bloclibrary.dev)
- [GoRouter](https://pub.dev/packages/go_router)
- [GetIt](https://pub.dev/packages/get_it)
- [Dio](https://pub.dev/packages/dio)

## 👨‍💻 Developer

<div align="center">

### Amr Elgazar

<div style="display: flex; justify-content: center; gap: 10px; margin-top: 10px;">
  <a href="https://amrelgazar.com">
    <img src="https://img.shields.io/badge/Website-amrelgazar.com-blue?style=for-the-badge&logo=web" alt="Website" />
  </a>
  <a href="https://www.facebook.com/elgazarTech/">
    <img src="https://img.shields.io/badge/Facebook-elgazarTech-blue?style=for-the-badge&logo=facebook" alt="Facebook" />
  </a>
  <a href="https://www.linkedin.com/in/amr-ahmed-elgazar/">
    <img src="https://img.shields.io/badge/LinkedIn-amr--ahmed--elgazar-blue?style=for-the-badge&logo=linkedin" alt="LinkedIn" />
  </a>
  <a href="http://wa.me/201030691425">
    <img src="https://img.shields.io/badge/WhatsApp-201030691425-25D366?style=for-the-badge&logo=whatsapp" alt="WhatsApp" />
  </a>
</div>

</div>
