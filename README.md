# Tracky - Realtime Location Tracker

Tracky is a Flutter application that allows you to track your real-time location and more. With features like geolocation tracking and maps integration, Tracky is your go-to app for keeping tabs on your whereabouts.

## Getting Started

To get started with Tracky, make sure you have Flutter installed on your development machine. You can download and install Flutter by following the [official installation guide](https://flutter.dev/docs/get-started/install).

1. Clone the Tracky repository to your local machine:

   ```bash
   git clone https://github.dev/Njuguna-JohnBrian/Tracky-Realtime-Location-Tracker
   ```

2. Change your current directory to the project folder:

   ```bash
   cd Tracky-Realtime-Location-Tracker
   ```

3. Install the required dependencies by running:

   ```bash
   flutter pub get
   ```

4. Connect your device or start an emulator and run the app:

   ```bash
   flutter run
   ```

## Features

### Realtime Location Tracking

Tracky provides a real-time location tracking feature that keeps you updated with your current location on a map.

### Geolocation

The app uses the `geolocator` package to access the device's geolocation services and retrieve accurate location data.

### Maps Integration

Tracky integrates with Google Maps through the `google_maps_flutter` package, allowing you to visualize your location on a map.

### Hooks Riverpod State Management

The app uses the `hooks_riverpod` package for efficient state management, making it easy to handle and share location data across the app.

### Route Polyline Drawing

With the `flutter_polyline_points` package, Tracky can draw polylines on the map to display your route.

## Configuration

Make sure to configure the necessary API keys for Google Maps if you haven't already. Refer to the official documentation on how to obtain and set up the API keys: [Google Maps API Key](https://developers.google.com/maps/gmp-get-started).

## Dependencies

- Flutter SDK
- Cupertino Icons for iOS-style icons
- `geolocator` for geolocation services
- `google_maps_flutter` for maps integration
- `hooks_riverpod` for state management
- `flutter_polyline_points` for drawing route polylines

## Contributing

Contributions to Tracky are welcome. If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Authors

- [Njuguna John Brian](njugunajb96@gmail.com)

Thank you for using Tracky! We hope you find it useful for all your location tracking needs.