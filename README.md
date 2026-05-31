# RailJet - Mumbai Local Train Ticket Booking App 🚆

<p align="center">
	<img src="https://img.shields.io/badge/Flutter-3.10.4+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
	<img src="https://img.shields.io/badge/Dart-3.10.4+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
	<img src="https://img.shields.io/badge/Provider-State%20Management-8E44AD?style=for-the-badge" alt="Provider" />
	<img src="https://img.shields.io/badge/License-Private-lightgrey?style=for-the-badge" alt="License" />
</p>

RailJet is a Flutter app for booking Mumbai local train tickets. The actual application lives in the [train_ticket](train_ticket) folder, while this root README is the page GitHub shows on the repository homepage.

It is built around a clean booking flow: station selection, route comparison, fare calculation, seat selection, passenger details, payment review, and confirmation with a ticket ID and QR-style summary.

## At a Glance ✨

| What it gives you | Why it matters |
| --- | --- |
| Station search and selection | Fast source and destination setup |
| Route comparison | Lets users see available train options |
| Dynamic fare calculation | Fare changes with distance, class, and ticket type |
| Multi-step booking flow | Keeps the experience simple and predictable |
| Ticket confirmation | Produces a clean mock ticket with QR-style output |
| Provider-based state management | Keeps the UI reactive and easier to maintain |

## Why This Project Exists 💡

RailJet started as a UI reuse exercise, but the end result is a full train-ticket booking experience. Instead of treating the app like a generic Flutter starter, the screens, states, and flows were shaped around a real-world local transport use case.

The result is a project that feels more like a product demo than a template. It shows how to structure a booking experience, how to separate UI from logic, and how to keep the codebase organized enough to grow later.

## What Users Can Do 🎯

- Pick source and destination stations from Mumbai local routes
- Swap stations instantly
- Choose between Single and Return ticket types
- Select Second Class, First Class, or AC
- Review live fare updates as selections change
- Browse available route options
- Continue through seat, passenger, payment, and confirmation screens
- Generate a booking ticket with a booking ID and QR-style summary

## Booking Journey 🧭

1. Splash screen loads the app and prepares the booking flow.
2. Home screen captures the journey details.
3. Route options are generated for the selected stations.
4. A route is chosen and the train details screen is shown.
5. Seat selection assigns a preferred seat.
6. Passenger details are entered and validated.
7. Payment screen reviews the total fare before confirmation.
8. Confirmation screen creates the final booking result.

## App Screens 🖼️

- Splash screen: startup and navigation handoff
- Home screen: station selection and fare preview
- Train list screen: available route comparison
- Train details screen: route and journey details
- Seat selection screen: seat picker and availability view
- Passenger details screen: booking form
- Payment screen: total summary and payment method selection
- Confirmation screen: booking ID and QR-style ticket display

## Feature Set 🌟

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

```text
Screens -> Provider -> Service Layer -> Models / Mock Data
```

## Project Structure 📁

```text
README.md
train_ticket/
├── lib/
├── assets/
├── test/
└── pubspec.yaml
```

## Quick Start 🚀

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

Fare is calculated from journey distance and then adjusted by class and ticket type.

```text
Base fare = ceil(distance / 5 km) * 5
Final fare = Base fare × class multiplier × ticket type multiplier
```

Example:

- Churchgate to Borivali, Second Class, Single Ticket
- Distance: 38 km
- Base fare: 8 intervals × 5 = 40
- Final fare: 40

## Code Layout Inside the App 📚

- [main.dart](train_ticket/lib/main.dart): app entry point and Provider setup
- [providers/ticket_booking_provider.dart](train_ticket/lib/providers/ticket_booking_provider.dart): booking state management
- [services/train_ticket_service.dart](train_ticket/lib/services/train_ticket_service.dart): mock data and fare logic
- [models/station.dart](train_ticket/lib/models/station.dart): station, route, ticket, and booking models
- [widgets/ticket_widgets.dart](train_ticket/lib/widgets/ticket_widgets.dart): reusable UI components
- [screens](train_ticket/lib/screens): booking flow screens

## Development Notes 📝

- The current implementation uses mock data so the app can run without a backend.
- The nested [train_ticket/README.md](train_ticket/README.md) contains app-level documentation.
- The architecture and implementation details are documented in the files inside the `train_ticket` folder.
- The root [.gitignore](.gitignore) keeps IDE metadata and generated files out of GitHub.

## Suggested Next Improvements 🔥

If you want this README to feel even more like a top-tier showcase page, the next upgrades would be:

1. Add a banner image or app mockup at the top.
2. Add real screenshots of the home, route, and confirmation screens.
3. Add badges for build status, platform support, and license.
4. Add a short animated GIF or screen recording section.

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
