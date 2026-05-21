# Market App

A simple market application scaffold using Flutter, Clean Architecture, and BLoC.

## What's Included
- Clean architecture directory structure (core, app, features).
- Authentication flow using flutter_bloc, backed by Supabase Auth.
- Login page with email/password form and basic validation.
- Business list main page (with logout).

## Persistence
- Supabase is the **only** source of truth — there is no on-device
  database (Drift/SQLite was removed) and no on-device credential cache.
- The Supabase auth session is persisted by `supabase_flutter` itself so
  it can be restored on next launch.
- Each `local/` data source keeps an in-memory cache (Map +
  `ReplaySubject`) so the UI can stream from it during the session;
  state is rebuilt on launch by repository sync calls.

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
    reactive/
      replay_subject.dart   # In-memory cache helper for streams
  features/
    auth/
      data/
        datasources/remote/ # Supabase auth client wrapper
        models/             # Session / user models
        repositories/       # AuthRepositoryImpl
      domain/               # Entities, repository contracts, use cases
      presentation/
        bloc/               # AuthBloc + events + states
        pages/
          login_page.dart
    business/
      data/                 # Supabase remote source + models
      domain/               # Entities, repository, use cases
      presentation/
        bloc/
        pages/
```

## Run
1. Get packages:
   flutter pub get
2. Run the app:
   flutter run

## Notes
- Authentication is done entirely through Supabase Auth. There is no fake
  or offline fallback.
- State management uses flutter_bloc with an AuthBloc managing
  login/logout.
