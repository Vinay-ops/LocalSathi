# RailJet App - New Architecture Documentation

## Overview

The RailJet app has been refactored to follow a **Clean Architecture** pattern with clear separation of concerns. This document explains the new folder structure and how different components interact.

## Folder Structure

```
lib/
├── ui/                              # User Interface Layer
│   ├── screens/                    # Screen components organized by feature
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── login/
│   │   │   ├── login_screen.dart           (Container - State Management)
│   │   │   └── login_screen_ui.dart        (UI Only - Presentation)
│   │   ├── home/
│   │   │   ├── home_screen.dart            (Container - State Management)
│   │   │   └── home_screen_ui.dart         (UI Only - Presentation)
│   │   ├── route_selection/
│   │   │   └── route_selection_screen.dart
│   │   ├── payment/
│   │   │   └── payment_screen.dart
│   │   ├── profile/
│   │   │   └── profile_screen.dart
│   │   └── qr_ticket/
│   │       └── qr_ticket_screen.dart
│   └── common/                     # Shared UI components
│       └── (reusable widgets)
│
├── domain/                          # Business Logic Layer
│   ├── usecases/                   # Use cases for different features
│   │   ├── login_usecase.dart
│   │   └── home_screen_usecase.dart
│   └── repositories/               # Repository interfaces
│
├── data/                           # Data Layer
│   ├── models/                     # Data models
│   │   └── station.dart
│   ├── services/                   # Data services & API calls
│   │   ├── train_ticket_service.dart
│   │   └── route_calculator.dart
│   └── (database, cache, etc.)
│
├── providers/                      # State Management (Provider)
│   └── ticket_booking_provider.dart
│
├── widgets/                        # Legacy (to be migrated)
│   └── ticket_widgets.dart
│
├── screens/                        # Legacy (to be migrated)
│   └── (old screen files)
│
├── models/                         # Legacy (to be migrated)
│   └── station.dart
│
├── services/                       # Legacy (to be migrated)
│   ├── train_ticket_service.dart
│   └── route_calculator.dart
│
└── main.dart                       # App entry point
```

## Architecture Layers Explained

### 1. **UI Layer** (`lib/ui/`)

Handles all presentation logic and user interface.

#### Screen Structure Pattern

Each screen is organized in its own folder with two main files:

**Example: Login Screen**

- **`login_screen_ui.dart`** - Pure UI Component
  - Contains only widgets and layout
  - No business logic
  - Receives all data via constructor parameters
  - Callbacks for user interactions
  - Fully reusable and testable

  ```dart
  class LoginScreenUI extends StatelessWidget {
    final TextEditingController phoneController;
    final bool isLoading;
    final String? errorMessage;
    final VoidCallback onLoginPressed;
    final ValueChanged<String> onPhoneChanged;
    
    // UI widgets only
    @override
    Widget build(BuildContext context) { ... }
  }
  ```

- **`login_screen.dart`** - Container/Smart Component
  - StatefulWidget that manages state
  - Handles user interactions
  - Calls business logic (usecases)
  - Delegates rendering to UI component

  ```dart
  class LoginScreen extends StatefulWidget { ... }
  
  class _LoginScreenState extends State<LoginScreen> {
    final LoginUsecase _loginUsecase = LoginUsecase();
    
    void _handleLogin() {
      // Call usecase
      final error = _loginUsecase.validatePhoneNumber(phone);
      // Update state
      // Navigate
    }
  }
  ```

#### Common Widgets (`lib/ui/common/`)

Shared UI components used across multiple screens:
- Custom form fields
- Card components
- Buttons
- Dialogs
- Loading indicators

### 2. **Domain Layer** (`lib/domain/`)

Contains business logic and use cases - independent of UI framework and database implementations.

#### Use Cases (`lib/domain/usecases/`)

Each use case handles a specific business operation:

- **`login_usecase.dart`**
  - Phone number validation
  - Login processing
  - Returns validation errors or success

- **`home_screen_usecase.dart`**
  - Get all stations
  - Validate station selection
  - Get ticket classes and types

**Guidelines:**
- No UI imports
- No context dependencies
- Pure functions with inputs/outputs
- Easily testable

```dart
class LoginUsecase {
  String? validatePhoneNumber(String phone) { ... }
  Future<bool> performLogin(String phoneNumber) async { ... }
}
```

#### Repositories (`lib/domain/repositories/`)

Abstract interfaces for data access:
- Define contract for data operations
- No implementation details
- Implemented by Data Layer

### 3. **Data Layer** (`lib/data/`)

Handles all data operations - APIs, database, cache, etc.

#### Models (`lib/data/models/`)

Data classes representing backend entities:
- Station model
- Ticket model
- User model

#### Services (`lib/data/services/`)

Concrete implementations for data fetching:
- **`train_ticket_service.dart`** - Ticket operations
- **`route_calculator.dart`** - Route calculation logic

### 4. **State Management** (`lib/providers/`)

Uses Provider package for state management:
- **`ticket_booking_provider.dart`** - Manages booking state globally

## Data Flow

```
User Interaction
    ↓
UI Component (login_screen_ui.dart) triggers callback
    ↓
Container Component (login_screen.dart) receives callback
    ↓
Container calls Business Logic (usecase)
    ↓
Usecase may call Data Services
    ↓
Services make API calls if needed
    ↓
Container updates state → UI re-renders
```

### Example: Login Flow

1. User enters phone number in `LoginScreenUI`
2. `onPhoneChanged` callback fired → Container clears error
3. User taps login → `onLoginPressed` callback fired
4. Container calls `_loginUsecase.validatePhoneNumber()`
5. If invalid, display error in UI
6. If valid, call `_loginUsecase.performLogin()`
7. After success, navigate to HomeScreen
8. UI automatically reflects state changes

## Benefits of This Architecture

✅ **Separation of Concerns**
- UI logic separate from business logic
- Easy to understand each component's responsibility

✅ **Reusability**
- UI components can be used in different contexts
- Business logic can be reused across platforms

✅ **Testability**
- Use cases can be tested without UI
- Services can be mocked easily
- UI components receive mock data

✅ **Maintainability**
- Changes to business logic don't affect UI
- UI updates don't require logic changes
- Clear dependency flow

✅ **Scalability**
- Easy to add new screens/features
- Business logic layer can grow independently
- Services can be easily extended

## Migration Guide

### For Legacy Code

Old files in `lib/screens/` and `lib/services/` are still present. Gradual migration:

1. **Identify screen to refactor**
2. **Create folder in `lib/ui/screens/{screen_name}/`**
3. **Split UI and Container logic**
4. **Extract business logic to `lib/domain/usecases/`**
5. **Update imports in `main.dart` or other screens**
6. **Test thoroughly**
7. **Remove old files**

### Example Migration

**Before:**
```dart
// lib/screens/home_screen.dart
class _HomeScreenState extends State<HomeScreen> {
  String sourceStation = 'Churchgate';
  List<String> stations = [...];
  
  void _swapStations() { ... }
  void _validateStations() { ... }
  void _getStations() { ... }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold( ... ); // 500+ lines of UI code
  }
}
```

**After:**
```dart
// lib/ui/screens/home/home_screen.dart
class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenUsecase _usecase = HomeScreenUsecase();
  
  void _handleSwapStations() => setState(...);
  void _handleFindTrains() {
    if(!_usecase.validateStations(...)) return;
    // Navigate
  }
  
  @override
  Widget build(BuildContext context) {
    return HomeScreenUI(
      // Pass data and callbacks
    );
  }
}

// lib/ui/screens/home/home_screen_ui.dart
class HomeScreenUI extends StatelessWidget {
  // Only UI widgets
  @override
  Widget build(BuildContext context) { ... }
}

// lib/domain/usecases/home_screen_usecase.dart
class HomeScreenUsecase {
  bool validateStations(String source, String dest) { ... }
  List<String> getAllStations() { ... }
}
```

## Best Practices

### UI Components (`*_ui.dart`)
- ✅ Constructor parameters only
- ✅ `final` widgets and collections
- ✅ No business logic
- ✅ No async operations
- ✅ No navigation
- ❌ No `setState` (stateless)
- ❌ No service calls

### Container Components (`screen.dart`)
- ✅ Manage state
- ✅ Call usecases
- ✅ Handle navigation
- ✅ Manage lifecycle
- ✅ Stateful when needed
- ❌ No complex UI building
- ❌ Minimal widget hierarchy

### Use Cases (`*_usecase.dart`)
- ✅ Pure functions
- ✅ No UI framework imports
- ✅ Business logic only
- ✅ Easy to test
- ✅ Can be async
- ❌ No context parameter
- ❌ No navigation

## Testing Examples

### Testing Use Case
```dart
test('validates valid phone number', () {
  final usecase = LoginUsecase();
  final result = usecase.validatePhoneNumber('9876543210');
  expect(result, null); // null = valid
});

test('rejects invalid phone', () {
  final usecase = LoginUsecase();
  final result = usecase.validatePhoneNumber('123');
  expect(result, isNotNull); // has error message
});
```

### Testing UI Component
```dart
testWidgets('shows error message', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LoginScreenUI(
        phoneController: TextEditingController(),
        isLoading: false,
        errorMessage: 'Invalid phone',
        onLoginPressed: () {},
        onPhoneChanged: (_) {},
      ),
    ),
  );
  
  expect(find.text('Invalid phone'), findsOneWidget);
});
```

## Next Steps

1. **Continue migrating screens** - Apply same pattern to remaining screens
2. **Add unit tests** - Test usecases and services
3. **Add widget tests** - Test UI components
4. **Implement repositories** - Create abstraction layer for data
5. **Add documentation** - Update as you discover patterns
6. **Code review** - Ensure consistency across team

## Questions & Support

For questions about this architecture:
- Review the files in new structure
- Check examples in refactored components
- Follow the pattern for new screens
