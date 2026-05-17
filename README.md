# Market App

A simple market application scaffold using Flutter, Clean Architecture, and BLoC.

## What’s Included
- Clean architecture directory structure (core, app, features).
- Authentication flow using flutter_bloc.
- Login page with email/password form and basic validation.
- Market main page (placeholder list of products) with logout.

## Persistence
- Supabase is the **only** source of truth — there is no on-device
  database (Drift/SQLite was removed).
- Each `local/` data source keeps an in-memory cache (Map +
  `ReplaySubject`) so the UI can stream from it during the session;
  state is rebuilt on launch by repository sync calls.
- Only the encrypted authentication session is persisted across launches
  (via `flutter_secure_storage`) so the user can be restored offline.

## Run project
1. **Create an environment file:**  
   Create a file named `env.dev.json` in the root of the project.
2. **Run flutter**
   With args: --dart-define-from-file=env.dev.json

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
