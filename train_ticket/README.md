# RailJet - Mumbai Local Train Ticket Booking App

RailJet is a Flutter application for booking Mumbai local train tickets. It uses a clean, modular architecture with Provider-based state management, mock station and route data, fare calculation, ticket generation, and QR-style booking confirmation.

The app reuses familiar mobile UI patterns, but the underlying functionality is built specifically for train ticket booking rather than news or content browsing.

## Features

- Station search and selection for Mumbai local train routes
- Source and destination swapping
- Ticket type selection: Single and Return
- Ticket class selection: Second Class, First Class, and AC
- Dynamic fare calculation based on distance, class, and ticket type
- Route listing with mock train options
- Seat selection and passenger details flow
- Payment review screen
- Booking confirmation with ticket ID and QR code display
- Provider-based state management for a reactive booking flow

## Booking Flow

1. Splash screen loads the app.
2. Home screen lets the user choose source and destination stations.
3. Available routes are shown based on the selected journey.
4. The user selects a route and reviews train details.
5. Seat selection captures a preferred seat.
6. Passenger details are entered and reviewed.
7. Payment screen summarizes the total fare.
8. Confirmation screen generates the ticket and QR code.

## Tech Stack

- Flutter
- Dart
- Provider for state management
- Shared Preferences for lightweight local storage
- QR utilities for ticket display

## Architecture

The codebase is organized into a few clear layers:

- Models: station, route, ticket, and booking state objects
- Services: mock data, fare calculation, and ticket generation
- Providers: booking state orchestration and UI-facing actions
- Widgets: reusable cards, dropdowns, and progress UI
- Screens: the end-to-end booking experience

High-level flow:

```text
UI Screens
	-> Provider
		-> Service Layer
			-> Models / Mock Data
```

## Project Structure

```text
lib/
├── main.dart
├── data/
├── models/
├── providers/
├── screens/
├── services/
├── ui/
└── widgets/

assets/
└── logos/
```

## Getting Started

### Prerequisites

- Flutter 3.10.4 or newer
- Dart 3.10.4 or newer

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### Run Tests

```bash
flutter test
```

### Build Release APK

```bash
flutter build apk --release
```

## Dependencies

The main packages used by this app are:

- `provider` for app state management
- `shared_preferences` for local persistence
- `qr` for ticket QR rendering support
- `cupertino_icons` for iOS-style icons

## Fare Calculation

Fare is calculated from the journey distance and then adjusted by class and ticket type.

```text
Base fare = ceil(distance / 5 km) * 5
Final fare = Base fare * class multiplier * ticket type multiplier
```

Example:

- Churchgate to Borivali, Second Class, Single Ticket
- Distance: 38 km
- Base fare: 8 intervals x 5 = 40
- Final fare: 40

## Customization Notes

- Replace the mock station and route data in the service layer if you want to connect a real backend.
- Update the ticket generation logic if you need integration with a payment provider.
- Add screenshots to the repository if you want to expand the README with visual previews.

## Related Docs

- [Architecture overview](ARCHITECTURE.md)
- [Implementation guide](IMPLEMENTATION.md)
- [Route testing guide](ROUTE_TESTING_GUIDE.md)
- [Route interchange guide](ROUTE_INTERCHANGE_GUIDE.md)
- [Logo setup](LOGO_SETUP.md)

## Flutter Help

If you are new to Flutter, the official documentation is the best next stop:

- https://docs.flutter.dev/
- https://docs.flutter.dev/get-started/codelab
- https://docs.flutter.dev/cookbook
