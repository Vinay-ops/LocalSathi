# RailJet - Mumbai Local Train Ticket Booking App

RailJet is a Flutter application for booking Mumbai local train tickets. The app lives in the `train_ticket/` folder of this repository and uses Provider-based state management, mock station data, fare calculation, ticket generation, and QR-style booking confirmation.

If you opened this repository on GitHub and did not see a README, the reason was that the documentation only existed inside the nested app folder. GitHub renders the README from the repository root, so this file is the one shown on the main page.

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

## App Flow

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

The codebase is organized into clear layers:

- Models: station, route, ticket, and booking state objects
- Services: mock data, fare calculation, and ticket generation
- Providers: booking state orchestration and UI-facing actions
- Widgets: reusable cards, dropdowns, and progress UI
- Screens: the end-to-end booking experience

## Repository Structure

```text
README.md                # Root project overview shown on GitHub
train_ticket/            # Flutter app source
  ├── lib/
  ├── assets/
  ├── test/
  └── pubspec.yaml
```

## Getting Started

### Prerequisites

- Flutter 3.10.4 or newer
- Dart 3.10.4 or newer

### Install Dependencies

```bash
cd train_ticket
flutter pub get
```

### Run the App

```bash
cd train_ticket
flutter run
```

### Run Tests

```bash
cd train_ticket
flutter test
```

### Build Release APK

```bash
cd train_ticket
flutter build apk --release
```

## Fare Calculation

Fare is calculated from the journey distance and then adjusted by class and ticket type.

```text
Base fare = ceil(distance / 5 km) * 5
Final fare = Base fare * class multiplier * ticket type multiplier
```

## Related Docs

- [App README](train_ticket/README.md)
- [Architecture overview](train_ticket/ARCHITECTURE.md)
- [Implementation guide](train_ticket/IMPLEMENTATION.md)
- [Route testing guide](train_ticket/ROUTE_TESTING_GUIDE.md)
- [Route interchange guide](train_ticket/ROUTE_INTERCHANGE_GUIDE.md)
- [Logo setup](train_ticket/LOGO_SETUP.md)
