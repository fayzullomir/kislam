# 📱 Flutter Attendance App

Mobile app for attendance management built with Flutter and custom Cubit state management.

------------------------------------------------------------------------

## 🚀 Quick Start

```bash
# Clone and setup
git clone https://github.com/abror.esonaliev/umrah-tour.git
```

# Get dependencies
```bash
flutter pub get
```

# Generate generation files
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# Generate string local keys
```bash
dart lib/core/scripts/generate_strings_script.dart
```

------------------------------------------------------------------------

# Customize splash screen
# Get dependencies
# Create logo for using by default platform (Android/iOS) splash screens

```bash
flutter pub get
flutter pub run flutter_native_splash:create
```

### ⚠️ iOS Double Splash Issue Fix

```bash
flutter clean
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ios/build build
dart run flutter_native_splash:create
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
```
------------------------------------------------------------------------

## 🎯 Architecture

### State Management Pattern
- **BaseState**: Generic state wrapper
- **BaseCubit**: Abstract cubit with common functionality
- **BaseListener**: Event handling wrapper
- **BaseBuilder**: State-based widget builder
- **BasePage**: Complete page structure

## 📚 Documentation

- **[🛠️ All Commands](COMMANDS.md)** - Complete command reference
- Development, build, maintenance, and git commands


------------------------------------------------------------------------

## 🆘 Troubleshooting

### Build Issues
```bash
flutter clean
rm -rf .dart_tool/ build/ pubspec.lock
flutter pub get
flutter run --no-hot
```

### Code Generation Issues
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```


------------------------------------------------------------------------

## 🌍 Localization

The app supports multiple languages:
- 🇺🇿 Uzbek (Latin)
- 🇬🇧 English
- 🇷🇺 Russian

Translation files are auto-generated from JSON files in `assets/localization/`.


------------------------------------------------------------------------

## 🚀 Deployment

### Android
```bash
flutter build appbundle --release    # Play Store
flutter build apk --split-per-abi    # Direct distribution
```

### iOS
```bash
flutter build ios --release          # App Store
```

### Web
```bash
flutter build web
```

### Docker
```bash
docker-compose up --build
```

------------------------------------------------------------------------

**For detailed commands and troubleshooting, see [COMMANDS.md](COMMANDS.md)**