# HeroCtrl Tests

[< Go back to README.md](/README.md)

## Test Structure

```txt
test/
├── constants/       # Unit tests for enum definitions and recording settings
│   └── gopro_recording_enums_test.dart
├── models/          # Unit tests for data models and binary/JSON parsing
│   ├── camera_serial_and_mac_test.dart
│   ├── camera_state_test.dart
│   ├── camera_status_test.dart
│   ├── camera_version_test.dart
│   ├── camera_wifi_info_test.dart
│   └── gopro_registration_test.dart
├── utils/           # Unit and widget tests for utility functions and helpers
│   ├── app_routes_test.dart
│   ├── camera_state_conditions_test.dart
│   ├── gopro_validator_test.dart
│   ├── logger_test.dart
│   └── snackbar_test.dart
├── widgets/         # Widget tests for reusable UI components
│   ├── battery_indicator_test.dart
│   ├── password_field_test.dart
│   ├── polling_timer_indicator_test.dart
│   └── red_button_test.dart
├── screens/         # Screen-level widget tests (none yet)
└── services/        # Service layer tests (none yet)
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

Located in `constants/`, `models/`, and `utils/` folders.

**`constants/gopro_recording_enums_test.dart`** — `VideoResolution`, `FOV`, `FPS`, `LoopVideoDuration`

- FPS compatibility per resolution and video standard (NTSC/PAL)
- FOV compatibility per resolution and FPS
- Zoom factors, aspect ratios, uniqueness, and value ranges

**`models/camera_status_test.dart`** — `CameraStatus`

- Binary parsing of all status fields from raw bytes
- Bit-field extraction (video standard, orientation, locate, ProTune, shutter, one-button mode, video preview)
- Multi-byte integer parsing and max-value edge cases
- Unknown enum values fall back to defaults; fallback camera mode override

**`models/camera_version_test.dart`** — `CameraVersion`

- Firmware version and camera type string extraction by offset/length
- Edge cases: short, long, empty, and special-character strings
- Real-world HERO3+ Silver firmware data

**`models/camera_serial_and_mac_test.dart`** — `CameraSerialAndMac`

- Serial number extraction (bytes 19–32) and MAC address extraction (bytes 1–6)
- MAC formatting with separators and zero-padding
- Edge cases: all-zero data, max byte values, special characters

**`models/camera_wifi_info_test.dart`** — `CameraWifiInfo`

- Password and SSID extraction by length-prefixed offset
- Edge cases: short/long/empty credentials, special characters, numeric-only

**`models/camera_state_test.dart`** — `CameraState`

- Initialization with a `CameraStatus`, battery percent calculation
- Mutating `cameraOn`, `previewOn`, and replacing the status

**`models/gopro_registration_test.dart`** — `GoProRegistration`

- Instance creation, JSON serialization and deserialization, round-trip fidelity

**`utils/camera_state_conditions_test.dart`** — `CameraStateConditions` + `isLandscape`

- All condition helpers: `isCameraOn`, `isPreviewOn`, `isRecording`, `isShutterDown`,
  `isInSettingsMode`, `isInPhotoOrBurstMode`, `isInVideoOrTimelapseMode`,
  `isInVideoMode`, `isInPhotoMode`, `isInTimelapseMode`
- Each helper tested for true, false, and null-state cases
- `isLandscape` verified with landscape and portrait viewport sizes

**`utils/gopro_validator_test.dart`** — `GoProValidator`

- `isGoPro`: valid HERO3/HERO3+ BSSID prefix, non-GoPro, invalid format, case-insensitive
- `allKnownPrefixes`: returns full list of OUI prefixes, all properly formatted
- `isRegistered`: async checks for registered, unregistered, and removed cameras

**`utils/logger_test.dart`** — `AppLogger`

- Singleton initialization and listener setup
- `info`, `warning`, and `error` log methods at correct severity levels
- Error logging with exception and stack trace
- Sequential message ordering and log-level filtering

### Widget Tests

Located in `utils/` (snackbar and routes) and `widgets/` folders.

**`utils/snackbar_test.dart`** — `showSnackBar`, `showSnackBarError`, `showSnackBarSuccess`, `showSnackBarWarning`

- Message display, default and custom colors, text color (white)
- Clears previously shown snackbars
- Graceful handling of unmounted context, missing `ScaffoldMessenger`, and errors during build

**`utils/app_routes_test.dart`** — `AppRoutes`

- Route name constants and completeness of the routes map
- Each named route builds the correct screen widget
- Routes work with `MaterialApp` and `Navigator.pushNamed`

**`widgets/battery_indicator_test.dart`** — `BatteryIndicator`

- Displays battery percentage and estimated remaining time
- Time formatting: minutes-only vs. hours + minutes
- Icon selection for high, low, and critical (<5%) battery levels
- Null and zero estimated-time edge cases; custom theme color

**`widgets/password_field_test.dart`** — `PasswordField`

- Renders with default and custom labels; text is obscured by default
- Visibility toggle icon tap, text input, `onChanged` callback, `onEditingComplete` callback

**`widgets/polling_timer_indicator_test.dart`** — `PollingTimerIndicator`

- Shows zero progress when `nextPollTime` is null
- Periodic timer ticks advance progress while mounted
- Progress clamped to zero for a far-future poll time
- `nextPollTimeListenable` takes precedence over `nextPollTime`
- Listener rebinding when the listenable instance is replaced
- UI updates when the listenable value changes
- Custom color and text style application
- Mode switching: listenable → timer and timer → listenable on widget update

**`widgets/red_button_test.dart`** — `RedButton`

- Renders the provided child widget
- Invokes `onPressed` callback when tapped
- Applies red-accent background and white foreground colors

### Screen and Service Tests (Not Yet Implemented)

`screens/` and `services/` test folders exist but are currently empty.
Service tests would require mocking:

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
