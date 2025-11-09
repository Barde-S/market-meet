# MarketMate Mobile App

Flutter mobile application for MarketMate - connecting travelers and shoppers with trusted local agents.

## Features

- **User Authentication**: Firebase Auth integration for secure user management
- **Agent Discovery**: Find verified local agents based on location and specialties
- **Booking System**: Schedule and manage shopping assistance services
- **Real-time Messaging**: In-app chat with agents (coming soon)
- **Maps Integration**: Google Maps for location services and navigation
- **Multi-language Support**: Translation and negotiation services

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- Firebase account

## Setup

1. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**:
   - Create a Firebase project at https://console.firebase.google.com
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Run FlutterFire CLI to generate configuration:
     ```bash
     flutterfire configure
     ```

3. **Configure Google Maps**:
   - Get API keys from Google Cloud Console
   - Add keys to:
     - Android: `android/app/src/main/AndroidManifest.xml`
     - iOS: `ios/Runner/AppDelegate.swift`

## Running the App

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release

# Build APK (Android)
flutter build apk

# Build iOS app
flutter build ios
```

## Project Structure

```
mobile/
├── lib/
│   ├── config/          # Configuration files
│   ├── models/          # Data models
│   ├── providers/       # State management (Provider)
│   ├── screens/         # UI screens
│   ├── services/        # API and external services
│   ├── utils/           # Helper functions
│   ├── widgets/         # Reusable UI components
│   └── main.dart        # App entry point
├── assets/              # Images, fonts, etc.
├── test/                # Unit and widget tests
└── pubspec.yaml         # Dependencies
```

## State Management

This app uses the Provider package for state management. Main providers:

- `AuthProvider`: User authentication and session management
- `AgentProvider`: Agent discovery and management
- `BookingProvider`: Booking creation and tracking

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Contributing

Please read the main project README for contribution guidelines.

## License

MIT License - See LICENSE file for details
