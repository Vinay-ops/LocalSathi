# RailJet - Mumbai Local Train Ticket Booking System

A Flutter mobile application for booking Mumbai local train tickets. This app reuses modern mobile UI patterns (similar to news apps) but repurposes them for train ticket booking, featuring clean architecture, state management with Provider, and a complete booking flow.

## Project Structure

```
lib/
├── main.dart                          # App entry point with Provider setup
├── models/
│   └── station.dart                   # Data models (Station, Route, Ticket, BookingState)
├── services/
│   └── train_ticket_service.dart      # Business logic & mock data service
├── providers/
│   └── ticket_booking_provider.dart   # State management (Provider pattern)
├── widgets/
│   └── ticket_widgets.dart            # Reusable UI components
└── screens/
    ├── splash_screen.dart             # App startup / loading screen
    ├── home_screen.dart               # Original home screen
    ├── home_screen_refactored.dart    # NEW: Enhanced home with Provider
    ├── train_list_screen.dart         # List of available trains
    ├── train_details_screen.dart      # Train details & amenities
    ├── seat_selection_screen.dart     # Seat selection interface
    ├── passenger_details_screen.dart  # Passenger info form
    ├── payment_screen.dart            # Payment selection
    └── confirmation_screen.dart       # Booking confirmation & ticket
```

## Architecture & Design Patterns

### 1. **Model-Service-Provider-UI Pattern**

This replaces typical news app architecture:

| News App | Train Ticket App | Purpose |
|----------|-----------------|---------|
| News Articles | Train Routes | Core data unit |
| Article Categories | Ticket Types (Single/Return) | User preferences |
| Article Details | Ticket Booking Details | Transaction data |
| Favorite Articles | Saved Bookings | User history |
| API Client | TrainTicketService | Data & business logic |

### 2. **State Management (Provider)**

Uses `provider: ^6.0.0` for reactive state management without Redux/Riverpod complexity:

```dart
// Single provider for entire booking flow
ChangeNotifierProvider(
  create: (_) => TicketBookingProvider()..initialize()
)
```

### 3. **Service Layer (Dependency Injection Pattern)**

`TrainTicketService` - Singleton that handles:
- Station data (mock data replaces API calls)
- Fare calculations
- Ticket generation
- QR code generation
- Seat availability

### 4. **Reusable Widgets**

Components designed to be modular and theme-consistent:

```dart
- StationCard          // Station display (replaces news article card)
- RouteCard           // Train route display
- TicketPreviewCard   // Ticket preview (replaces article preview)
- DropdownSelector    // Reusable dropdown
- BookingProgressStepper // Visual progress indicator
```

## Data Models Explained

### Station Model
```dart
Station(
  id: '1',
  name: 'Churchgate',
  code: 'CHG',              // 3-letter station code
  line: 'WR',               // Railway line (Western/Central)
  distance: 0.0,            // km from starting point
  description: '...'
)
```
**Replaces:** News article source/category

### Route Model
```dart
Route(
  id: '1',
  source: station1,
  destination: station2,
  baseFare: 25.0,           // Base fare in Rupees
  distance: 38.0,
  trainName: 'Mumbai Local Fast',
  trainNumber: 'ML-001'
)
```
**Replaces:** News article data

### Ticket Model
```dart
Ticket(
  id: '123',
  bookingId: 'ML20260322',
  source: station1,
  destination: station2,
  ticketType: 'Single',     // Single or Return
  ticketClass: 'Second Class',  // First, Second, or AC
  fare: 45.0,
  bookingDateTime: DateTime.now(),
  qrCode: 'TICKET|ML20260322|...',
  passengerName: 'John Doe',
  seatNumber: 'A1'
)
```
**Replaces:** Purchased/saved news article

### BookingState Model
```dart
BookingState(
  source: station1,
  destination: station2,
  ticketType: 'Single',
  ticketClass: 'Second Class',
  passengerName: 'John Doe',
  seatNumber: 'A1',
  calculatedFare: 45.0
)
```
**Purpose:** Tracks current booking progress

## Booking Flow

```
1. Splash Screen (SplashScreen)
   ↓ (2 seconds delay)
   
2. Home Screen (HomeScreenRefactored)
   - Select source & destination stations
   - Choose ticket type & class
   - Button: "Find Trains" → triggers fare calculation
   ↓
   
3. Train List Screen (TrainListScreen)
   - Display available routes as RouteCards
   - Show fare from TrainTicketService.calculateFare()
   - Button: "Book Ticket"
   ↓
   
4. Train Details Screen (TrainDetailsScreen)
   - Show detailed train info
   - Button: "Select Seats"
   ↓
   
5. Seat Selection Screen (SeatSelectionScreen)
   - Display available seats from service
   - Select seat
   - Button: "Continue"
   ↓
   
6. Passenger Details Screen (PassengerDetailsScreen)
   - Input passenger name
   - Button: "Continue to Payment"
   ↓
   
7. Payment Screen (PaymentScreen)
   - Select payment method
   - Show total amount from provider
   - Button: "Pay Now"
   ↓
   
8. Confirmation Screen (ConfirmationScreen)
   - Display generated Ticket
   - Show booking ID & QR code
   - Button: "Go to Home" → resets to step 1
```

## Fare Calculation Logic

```dart
double calculateFare({
  source: Station,
  destination: Station,
  ticketClass: String,      // Default: "₹5 per 5km"
  ticketType: String        // Return = 1.8x Single
}) {
  // 1. Distance calculation
  double distance = (destination.distance - source.distance).abs();
  
  // 2. Base fare: ₹5 for every 5km
  double baseFare = (distance / 5).ceil() * 5.0;
  
  // 3. Class multipliers
  //    - First Class: 2.0x
  //    - AC Class: 3.0x
  //    - Second Class: 1.0x
  
  // 4. Return ticket: 1.8x single fare
  
  return fare;
}
```

**Examples:**
- Churchgate (0 km) → Borivali (38 km): 8 × ₹5 = ₹40 (Second Class, Single)
- Same route, First Class: ₹40 × 2.0 = ₹80
- Same route, Return: ₹40 × 1.8 = ₹72

## Mock Data Implementation

### Stations
17 stations across 2 railway lines (WR - Western, CR - Central)
- Replaces news API with hardcoded data in `TrainTicketService._stations`
- Easy to replace with real API by modifying Service class

### Routes
Generated on-demand between any two stations
```dart
// TrainTicketService.getRoutes() returns 2 sample routes:
// 1. Fast train with standard fare
// 2. Slow train with slightly higher fare
```

### Ticket Generation
- **Booking ID:** "ML" + timestamp (e.g., "ML20260322140530")
- **QR Code:** Concatenated string of ticket|bookingId|timestamp
- Generated on confirmation, never persisted in mock app

## Key Features

✅ **Station Selection**
- Dropdown with search
- Swap source/destination with one tap
- Popular routes quick-selection

✅ **Dynamic Fare Calculation**
- Based on distance, class, and ticket type
- Real-time update as preferences change

✅ **Complete Booking Flow**
- Multi-step form with progress indicator
- Form validation at each step
- State persists through navigation

✅ **Ticket Confirmation**
- Display all booking details
- Generate mock QR code
- Booking ID for future reference

✅ **Clean Architecture**
- Separation of concerns (Models, Services, Providers, UI)
- No business logic in widgets
- Easy to test and extend

## How to Extend

### Add Real API
Replace mock data in `TrainTicketService`:
```dart
// Before: Static list
final List<Station> _stations = [...];

// After: API call
Future<List<Station>> getAllStations() async {
  final response = await http.get(Uri.parse('api/stations'));
  // Parse response
}
```

### Add Payment Gateway
Extend `PaymentScreen`:
```dart
// Mock: Just navigate to confirmation
// Real: Integrate Razorpay/PayTM/etc before navigation
```

### Add Local Storage
Use `shared_preferences` or `hive` to save:
```dart
_userTickets  // Current mock implementation
_bookingHistory  // New: persisted bookings
```

### Add Firebase
Logging & Analytics:
```dart
// Log booking events
FirebaseAnalytics.instance.logEvent(
  name: 'ticket_booked',
  parameters: {'fare': ticket.fare}
);
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0      # State management
  cupertino_icons: ^1.0.8  # iOS icons
```

## Running the App

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Run with specific device
flutter run -d <device_id>

# Build APK
flutter build apk --release
```

## Testing the App

### Manual Test Scenarios

1. **Happy Path Booking**
   - Select Churchgate → Borivali
   - Single ticket, Second Class
   - Verify fare = ₹40
   - Complete booking

2. **Return Ticket**
   - Select CSMT → Thane
   - Return ticket, AC Class
   - Verify fare = 15km × ₹5 × 3.0 (AC) × 1.8 (Return) = ₹405

3. **Station Swap**
   - Select source/destination
   - Click swap button
   - Verify positions are reversed

4. **Form Validation**
   - Click "Find Trains" without selecting stations
   - Button should be disabled

5. **Complete Flow**
   - Go through all 5 steps
   - Verify data passes correctly
   - Confirm QR code generates
   - Confirm booking ID format: "ML" + timestamp

##Flutter Architecture Comparison

Original (Without Architecture):
```
HomeScreen → TrainListScreen → TrainDetailsScreen → ...
(Local state, hardcoded data, no separation)
```

New (With Architecture):
```
UI (Screens/Widgets)
    ↓ (uses)
Providers (TicketBookingProvider)
    ↓ (uses)
Services (TrainTicketService)
    ↓ (uses)
Models (Station, Route, Ticket)
```

Benefits:
- **Testable:** Can test business logic independently
- **Maintainable:** Changes in service don't affect UI
- **Scalable:** Easy to add features without UI rewrites
- **Reusable:** Widgets work across screens

## Code Comments Convention

```dart
/// Public API documentation
/// Explains: What, Why, How

// Implementation comment
// Current approach: why this way?

// TODO: Future improvement
// FIXME: Known issue
// NOTE: Important caveat
```

## Summary

This app demonstrates:
1. ✅ Reusing UI patterns (news app → booking app)
2. ✅ Clean Flutter architecture (Models, Services, Providers)
3. ✅ State management with Provider
4. ✅ Mock data → easily connected to real APIs
5. ✅ Complete booking flow implementation
6. ✅ Professional code organization
7. ✅ Separation of concerns
8. ✅ Reusable, testable components

Perfect starting point for a production train booking app! 🚂
