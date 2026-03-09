# HeroCtrl Tests

[< Go back to README.md](/README.md)

## Test Structure

```txt
test/
├── models/          # Unit tests for data models and parsing logic
├── services/        # Service layer tests (with mocks for network/storage)
├── utils/           # Utility function and helper tests
├── widgets/         # Widget tests for reusable UI components
└── screens/         # Screen-level widget tests
```

## Running Tests

Run all tests:

```bash
flutter test
```

Run tests with coverage:

```bash
flutter test --coverage
```

Run specific test file:

```bash
flutter test test/models/camera_status_test.dart
```

Run tests in watch mode:

```bash
flutter test --watch
```

## Coverage Report (HTML)

Recommended (single command):

```bash
dart run tool/coverage.dart
```

This command excludes localization files in `lib/l10n/` from the coverage report.

Generate report without opening browser:

```bash
dart run tool/coverage.dart --no-open
```

Generate the coverage data:

```bash
flutter test --coverage
```

Convert the `lcov` output to an HTML report:

```bash
genhtml coverage/lcov.info -o coverage/html
```

Open the report in your browser:

- Linux:

 ```bash
 xdg-open coverage/html/index.html
 ```

- macOS:

 ```bash
 open coverage/html/index.html
 ```

- Windows (PowerShell):

 ```powershell
 start coverage/html/index.html
 ```

## Test Categories

### Unit Tests (Pure Logic)

Located in `models/`, `utils/`, and `constants/` folders.

**What's tested:**

- Binary data parsing (CameraStatus, CameraVersion, etc.)
- JSON serialization/deserialization (GoProRegistration)
- Validation logic (GoProValidator)
- State condition helpers (CameraStateConditions)
- Enum functionality and FPS/resolution compatibility

### Widget Tests

Located in `widgets/` folder.

**What's tested:**

- UI component rendering
- User interactions (taps, text input, toggles)
- State changes and updates
- Accessibility and localization

### Integration Tests (Not Yet Implemented)

Would require mocking:

- HTTP client for API calls
- SecureStorage for persistence
- WiFi scanning and connection
- Media player for live stream

## What's NOT Tested (Requires Hardware)

The following cannot be tested without a physical GoPro HERO3+ camera:

- Actual API communication with camera
- WiFi connection and scanning
- Live video streaming
- Real-time battery monitoring
- Hardware-specific response parsing edge cases

## Adding New Tests

When adding new features, consider:

1. **Models**: Test all parsing logic, edge cases, and data transformations
2. **Utilities**: Test pure functions and validators
3. **Services**: Mock external dependencies (HTTP, storage, WiFi)
4. **Widgets**: Test rendering, interactions, and state updates
5. **Integration**: Test user flows with all mocked dependencies

## Test Naming Conventions

- Test files: `{feature_name}_test.dart`
- Test groups: `group('ClassName', () { ... })`
- Test cases: `test('describes what it tests', (tester) async { ... })`
- Widget tests: `testWidgets('describes interaction', (tester) async { ... })`

## Continuous Integration

Tests are automatically run via GitHub Actions on:

- Every push to non-ignored branches
- Every pull request

See [`.github/workflows/compilation_and_tests.yml`](/.github/workflows/compilation_and_tests.yml) for CI configuration.
