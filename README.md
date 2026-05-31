# RailJet - Mumbai Local Train Ticket Booking App 🚆

RailJet is a Flutter application for booking Mumbai local train tickets. The actual app code lives in the [train_ticket](train_ticket) folder, while this root README is the version GitHub shows on the repository homepage.

The project uses Provider-based state management, mock Mumbai local train data, fare calculation, seat selection, passenger details, payment review, and ticket confirmation with a QR-style booking summary.

## What This Project Does ✨

RailJet turns a standard Flutter app shell into a booking experience for Mumbai local trains. Users can choose stations, compare routes, select ticket type and class, and complete a mock booking flow from search to confirmation.

## Highlights 🌟

- Station search and selection for Mumbai local routes
- Source and destination swapping
- Single and return ticket types
- Second class, first class, and AC selection
- Distance-based fare calculation
- Mock route and train options
- Seat selection and passenger details screens
- Payment review and booking confirmation
- Ticket ID and QR-style confirmation output
- Provider-driven reactive state management

## Booking Flow 🧭

1. Splash screen loads the app.
2. Home screen captures the source and destination stations.
3. Route options are generated for the selected journey.
4. A route is chosen and the train details screen is shown.
5. Seat selection assigns a preferred seat.
6. Passenger details are entered.
7. Payment screen reviews the total fare.
8. Confirmation screen generates the booking result and QR code.

## Screens At a Glance 🖼️

- Splash screen: initial app loading and navigation handoff
- Home screen: station selection and fare preview
- Train list screen: route comparison
- Train details screen: journey details and amenities
- Seat selection screen: available seat picker
- Passenger details screen: booking form
- Payment screen: payment method and total summary
- Confirmation screen: booking ID and QR display

## Tech Stack 🛠️

- Flutter
- Dart
- Provider for state management
- Shared Preferences for local persistence
- QR utilities for ticket display

## Architecture 🧱

The app is organized into distinct layers:

- Models: station, route, ticket, and booking state objects
- Services: mock data, route generation, fare logic, and ticket creation
- Providers: booking state orchestration and screen updates
- Widgets: reusable cards, selectors, and progress UI
- Screens: the end-to-end booking experience

High-level flow:

```text
Screens -> Provider -> Service Layer -> Models / Mock Data
```

## Repository Structure 📁

```text
README.md
train_ticket/
├── lib/
├── assets/
├── test/
└── pubspec.yaml
```

## Getting Started 🚀

### Prerequisites ✅

- Flutter 3.10.4 or newer
- Dart 3.10.4 or newer

### Install Dependencies 📦

```bash
cd train_ticket
flutter pub get
```

### Run the App ▶️

```bash
cd train_ticket
flutter run
```

### Run Tests 🧪

```bash
cd train_ticket
flutter test
```

### Build Release APK 📱

```bash
cd train_ticket
flutter build apk --release
```

## Fare Calculation 💰

Fare is calculated from the journey distance and then adjusted by class and ticket type.

```text
Base fare = ceil(distance / 5 km) * 5
Final fare = Base fare * class multiplier * ticket type multiplier
```

## Development Notes 📝

- The current implementation uses mock data so the app can run without a backend.
- The nested [train_ticket/README.md](train_ticket/README.md) contains app-level documentation.
- The architecture and implementation details are documented in the files inside the `train_ticket` folder.
- The root [.gitignore](.gitignore) keeps IDE metadata and generated files out of GitHub.

## Related Docs 🔗

- [App README](train_ticket/README.md)
- [Architecture overview](train_ticket/ARCHITECTURE.md)
- [Implementation guide](train_ticket/IMPLEMENTATION.md)
- [Route testing guide](train_ticket/ROUTE_TESTING_GUIDE.md)
- [Route interchange guide](train_ticket/ROUTE_INTERCHANGE_GUIDE.md)
- [Logo setup](train_ticket/LOGO_SETUP.md)

## Flutter Help 💡

If you want to learn Flutter or extend this app further, the official docs are the best starting point:

- https://docs.flutter.dev/
- https://docs.flutter.dev/get-started/codelab
- https://docs.flutter.dev/cookbook
