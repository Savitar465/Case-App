# Market App

A simple market application scaffold using Flutter, Clean Architecture, and BLoC.

## What’s Included
- Clean architecture directory structure (core, app, features).
- Authentication flow using flutter_bloc.
- Login page with email/password form and basic validation.
- Market main page (placeholder list of products) with logout.

## Directory Structure
```
lib/
  app/
    app.dart                # App widget, routing, providers
  core/
    constants/
      app_constants.dart    # Global constants
  features/
    auth/
      data/
        auth_repository.dart
      domain/               # (reserved for entities/usecases)
      presentation/
        bloc/
          auth_bloc.dart
          auth_event.dart
          auth_state.dart
        pages/
          login_page.dart
    market/
      data/                 # (reserved)
      domain/               # (reserved)
      presentation/
        pages/
          market_home_page.dart
```

## Run
1. Get packages:
   flutter pub get
2. Run the app:
   flutter run

## Notes
- The AuthRepository is a fake implementation that accepts any non-empty email and password.
- State management uses flutter_bloc with an AuthBloc managing login/logout.
