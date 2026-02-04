# Todo App

## Setup

```bash
flutter pub get
```

- **Build Run (release/prod flavor):**
```bash
flutter run --flavor dev --dart-define=FLAVOR=dev
flutter run --flavor staging --dart-define=FLAVOR=staging
flutter run --flavor qa --dart-define=FLAVOR=qa
flutter run --flavor prod --dart-define=FLAVOR=prod
```

- **Build APK (release/prod flavor):**
```bash
flutter build apk  --flavor dev --dart-define=FLAVOR=dev
flutter build apk  --flavor staging --dart-define=FLAVOR=staging
flutter build apk  --flavor qa --dart-define=FLAVOR=qa
flutter build apk  --flavor prod --dart-define=FLAVOR=prod
```

## Brief architecture

- **Entry point:** `lib/main.dart` — app bootstrap and provider setup.
- **Core:** `lib/core/` — app-wide configuration, constants, utilities, and lifecycle services.
- **Domain:** `lib/domain/` — business models and repository interfaces (pure Dart, no platform code).
- **Data:** `lib/data/` — data sources (remote, local), database helpers, and concrete implementations of domain repositories.
- **Presentation:** `lib/presentation/` — UI screens, widgets, themes, and routing.
- **State management:** `lib/provider/` — providers and state wiring used by the UI.

This structure keeps business logic separated from platform and UI code. If you want, I can add a diagram or expand any layer with coding conventions and examples.
