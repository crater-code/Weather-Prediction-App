# Flood & Earthquake Alert System - Frontend

A Flutter frontend-only mock application for an Emergency Response System designed to help citizens and NGOs during flood and earthquake disasters.

## Features

- **Citizen Features**
  - Real-time emergency alerts and notifications
  - Report incidents and emergencies
  - Interactive disaster maps
  - AI chatbot for emergency guidance
  - Location calibration for accurate positioning
  - Emergency hotline access
  - Community updates and information sharing

- **NGO Features**
  - Dashboard for monitoring emergency reports
  - Report management and verification
  - Inventory management for resources
  - Post updates to community
  - Heatmaps for disaster visualization
  - Community engagement tools

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart               # Main app configuration
├── models/                # Data models
├── screens/               # UI screens for different features
├── services/              # Business logic and mock data
├── theme/                 # App theming and styling
└── widgets/               # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.18.0)

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/flood_quake_frontend.git
   cd flood_quake_frontend
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

## Development

This is a mock frontend application with no backend integration. All data is simulated using the `MockDataService`.

### Running on Different Platforms

- **Android**: `flutter run -d android`
- **iOS**: `flutter run -d ios`
- **Web**: `flutter run -d chrome`

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Documentation](https://dart.dev/guides)
