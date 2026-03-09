# HeroCtrl

## Description

This is a Flutter mobile app for Android to remotely control GoPro Hero 3+ Black cameras

## Installation and usage

To run the app, make sure you have Flutter installed and set up on your machine as well as a device or emulator running. Then, navigate to the project directory and run:

```bash
flutter pub get
flutter run
```

To get logs from the app without the native Android logs, you can use:

```bash
flutter logs
```

## Building the app

To build a release APK for Android, run:

```bash
flutter build apk --release
```

## Documentation

- Check out the API [documentation](/docs/API-docs.md) for more information about the GoPro HERO3+ Black API and how to use it.

- For test strategy and how to run tests, see [`testing.md`](/docs/testing.md).

## Resources used

Special thanks to the following resources that made this app possible:

- [Unofficial GoPro API documentation](https://github.com/KonradIT/goprowifihack/)
- [Python documentation of the `goprohero` library](https://goprohero.readthedocs.io/en/latest/)
