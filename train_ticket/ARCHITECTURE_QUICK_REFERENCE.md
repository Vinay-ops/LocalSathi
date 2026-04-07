# Quick Reference Guide - New Architecture

## Where to Put What?

### User Interface Code
📁 **Location:** `lib/ui/screens/{screen_name}/`

- **`{screen_name}.dart`** ← Container Component
  - Manages state with `StatefulWidget`
  - Handles user interactions
  - Calls use cases
  - Creates instances of UI component

- **`{screen_name}_ui.dart`** ← UI Component
  - Pure `StatelessWidget`
  - Only receives data via constructor
  - Only displays UI
  - Triggers callbacks for user actions

### Business Logic
📁 **Location:** `lib/domain/usecases/`

**File naming:** `{feature}_usecase.dart`

- Validation logic
- Data processing
- Business rules
- No UI imports
- Pure functions or async methods

### Data Operations
📁 **Location:** `lib/data/services/`

- API calls
- Database operations
- Data transformations
- File operations

### Shared Components
📁 **Location:** `lib/ui/common/`

- Custom buttons
- Input fields
- Cards
- Dialogs
- Loading spinners

### Models
📁 **Location:** `lib/data/models/`

- Data classes
- Serialization/Deserialization

---

## Quick Code Templates

### 1. Create a New Screen

**File 1:** `lib/ui/screens/my_feature/my_feature_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'my_feature_screen_ui.dart';
import '../../../domain/usecases/my_feature_usecase.dart';

class MyFeatureScreen extends StatefulWidget {
  const MyFeatureScreen({super.key});

  @override
  State<MyFeatureScreen> createState() => _MyFeatureScreenState();
}

class _MyFeatureScreenState extends State<MyFeatureScreen> {
  final MyFeatureUsecase _usecase = MyFeatureUsecase();
  
  // State variables
  String myData = '';
  bool isLoading = false;

  void _handleAction() {
    // Call usecase
    final result = _usecase.doSomething(myData);
    // Update state
    setState(() {
      myData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyFeatureScreenUI(
      data: myData,
      isLoading: isLoading,
      onAction: _handleAction,
    );
  }
}
```

**File 2:** `lib/ui/screens/my_feature/my_feature_screen_ui.dart`
```dart
import 'package:flutter/material.dart';

class MyFeatureScreenUI extends StatelessWidget {
  final String data;
  final bool isLoading;
  final VoidCallback onAction;

  const MyFeatureScreenUI({
    super.key,
    required this.data,
    required this.isLoading,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: Center(
        child: Column(
          children: [
            Text(data),
            ElevatedButton(
              onPressed: onAction,
              child: const Text('Do Action'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**File 3:** `lib/domain/usecases/my_feature_usecase.dart`
```dart
class MyFeatureUsecase {
  String doSomething(String input) {
    // Business logic here
    return input.toUpperCase();
  }
}
```

### 2. Create a Use Case

```dart
// lib/domain/usecases/my_usecase.dart

class MyUsecase {
  /// Validate input
  bool validateInput(String input) {
    return input.isNotEmpty && input.length > 3;
  }

  /// Process data
  Future<String> processData(String input) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return 'Processed: $input';
  }
}
```

### 3. Update Screen Navigation

```dart
// In container component (my_screen.dart)
void _navigateToNextScreen() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const NextScreen(
        data: 'pass data here',
      ),
    ),
  );
}
```

---

## Common Patterns

### Pattern 1: Handle Form Input
```dart
// Container
void _handleInputChange(String value) {
  if (errorMessage != null) {
    setState(() => errorMessage = null);
  }
}

// UI
TextField(
  onChanged: onInputChange,
  // ...
)
```

### Pattern 2: Async Operation with Loading
```dart
// Container
void _handleAsync() async {
  setState(() => isLoading = true);
  
  final result = await _usecase.asyncOperation();
  
  if (mounted) {
    setState(() => isLoading = false);
  }
}

// UI
if (isLoading)
  const CircularProgressIndicator()
else
  Text(data)
```

### Pattern 3: Validation Before Action
```dart
// Container
void _handleSubmit() {
  final error = _usecase.validate(formData);
  
  if (error != null) {
    setState(() => errorMessage = error);
    return;
  }
  
  setState(() => errorMessage = null);
  _proceedWithAction();
}
```

### Pattern 4: Selection State
```dart
// Container
String selectedItem = 'Item 1';

void _handleSelectionChange(String value) {
  setState(() => selectedItem = value);
}

// UI
DropdownButton<String>(
  value: selectedItem,
  items: items.map((item) => 
    DropdownMenuItem(value: item, child: Text(item))
  ).toList(),
  onChanged: (value) => onSelectionChanged(value),
)
```

---

## Import Paths

When importing, remember the structure:

From `lib/ui/screens/{screen}/` to access:

```dart
// Import UI sibling
import '{screen_name}_ui.dart';

// Import usecase
import '../../../domain/usecases/{feature}_usecase.dart';

// Import other screens
import '../{other_screen}/{other_screen}.dart';

// Import services
import '../../../data/services/{service}.dart';

// Import models
import '../../../data/models/{model}.dart';
```

---

## Checklist for New Screen

- [ ] Create folder: `lib/ui/screens/{screen_name}/`
- [ ] Create `{screen_name}.dart` (Container)
  - [ ] StatefulWidget
  - [ ] State variables
  - [ ] Handler methods
  - [ ] Build method that returns UI component
- [ ] Create `{screen_name}_ui.dart` (UI)
  - [ ] StatelessWidget
  - [ ] Constructor parameters
  - [ ] Build method with UI
- [ ] Create `lib/domain/usecases/{feature}_usecase.dart`
  - [ ] Business logic
  - [ ] Validation
  - [ ] Processing
- [ ] Update imports in navigation
- [ ] Update `main.dart` if it's a root screen

---

## File Size Guidelines

- **`*_ui.dart`**: 200-400 lines (UI only)
- **`{screen}.dart`**: 100-200 lines (state + handlers)
- **`*_usecase.dart`**: 100-300 lines (business logic)

If files get larger, break into smaller components!

---

## Debugging Tips

1. **UI not updating?**
   - Check if `setState()` is called in container
   - Verify callbacks are wired correctly

2. **Logic in wrong place?**
   - Business logic → usecase
   - UI rendering → {screen}_ui.dart
   - State management → {screen}.dart

3. **Import errors?**
   - Check relative path `../../../`
   - Verify folder structure

4. **Test a use case?**
   - No UI needed
   - Test business logic directly
   - Mock any dependencies

---

## Still Have Questions?

Refer to: `ARCHITECTURE_REFACTORING.md` for detailed documentation
