1. Initialization
   Call getInstance() before using the service (e.g., in main() or your dependency injection setup).

Dart

// Initialize singleton
final prefs = await SharedPreferencesService.getInstance(); 2. Basic Operations
All setters return a Future<bool> indicating success. Getters allow an optional defaultValue.

Dart

// Save data
await prefs.setString('username', 'JohnDoe');
await prefs.setBool('isDarkMode', true);
await prefs.setInt('loginCount', 5);

// Retrieve data
String? user = prefs.getString('username');
// With default value if key doesn't exist
bool isDark = prefs.getBool('isDarkMode', defaultValue: false)!; 3. Storing Objects (JSON)
Automatically handles JSON encoding and decoding for Maps.

Dart

Map<String, dynamic> userProfile = {'id': 101, 'role': 'admin'};

// Save Map
await prefs.setObject('profile', userProfile);

// Get Map
Map<String, dynamic>? data = prefs.getObject('profile'); 4. Utilities
Dart

// Check if key exists
if (prefs.containsKey('token')) { ... }

// Remove specific key
await prefs.remove('token');

// Clear all data
await prefs.clear();

---

### Preview

Here is how it will look when rendered:

# SharedPreferencesService

A robust, Singleton wrapper for the `shared_preferences` package in Flutter/Dart. It provides a simplified, type-safe API for persistent local storage with built-in error handling and JSON object support.

## Features

- **Singleton Pattern:** Ensures a single instance manages storage.
- **Error Handling:** All methods are wrapped in `try-catch` blocks to prevent crashes.
- **Object Support:** Native support for saving/retrieving `Map<String, dynamic>` as JSON.

## Dependencies

Ensure you have `shared_preferences` in your `pubspec.yaml`:

``yaml
dependencies:
shared_preferences: ^2.2.0 # or latest version
Usage

# Initialization

Call getInstance() before using the service (e.g., in main() or your dependency injection setup).

Dart

// Initialize singleton
final prefs = await SharedPreferencesService.getInstance();

# Basic Operations

All setters return a Future<bool> indicating success. Getters allow an optional defaultValue.

Dart

// Save data
await prefs.setString('username', 'JohnDoe');
await prefs.setBool('isDarkMode', true);
await prefs.setInt('loginCount', 5);

// Retrieve data
String? user = prefs.getString('username');
// With default value if key doesn't exist
bool isDark = prefs.getBool('isDarkMode', defaultValue: false)!;

# Storing Objects (JSON)

Automatically handles JSON encoding and decoding for Maps.

Dart

Map<String, dynamic> userProfile = {'id': 101, 'role': 'admin'};

// Save Map
await prefs.setObject('profile', userProfile);

// Get Map
Map<String, dynamic>? data = prefs.getObject('profile');

# Utilities

Dart

// Check if key exists
if (prefs.containsKey('token')) { ... }

// Remove specific key

await prefs.remove('token');

// Clear all data

await prefs.clear();
