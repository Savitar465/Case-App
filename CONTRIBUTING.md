# Contributing to Market App

Thank you for contributing! This document is the source of truth for **how the
app is structured** and **the conventions every change must follow**. Read it
end-to-end before opening your first PR.

> If you find code that breaks a rule listed here, that code is wrong, not the
> rule. Open a PR to fix it (or a TODO comment if it's out of scope).

---

## 1. Tech stack

| Concern              | Choice                                           |
| -------------------- | ------------------------------------------------ |
| Framework            | Flutter (Dart `^3.9.2`)                          |
| State management     | `flutter_bloc` (Bloc + Cubit)                    |
| Persistence          | Supabase (`supabase_flutter`) only — remote-only |
| Session storage      | `flutter_secure_storage` (cached auth session)   |
| In-session cache     | In-memory + `ReplaySubject` (see `core/reactive`) |
| Crypto               | `cryptography` (AES-GCM + PBKDF2)                |
| Value equality       | `equatable`                                      |
| Identifiers          | `uuid` v4                                        |
| Linting              | `flutter_lints`                                  |

We deliberately do **not** use:

- An on-device database (`drift`, `sqflite`, `hive`, `isar`). Supabase is
  the source of truth; the app keeps a per-session in-memory cache to
  power reactive streams in the UI. If you find yourself reaching for one,
  surface the requirement first.
- Code generation for models (`freezed`, `json_serializable`). Models are
  written by hand — see §4.
- A DI container (`get_it`, `riverpod`, etc.). Composition happens in
  `lib/main.dart` — see §3.
- Routing packages (`go_router`, `auto_route`). We use `MaterialApp` `routes` +
  `Navigator.pushReplacementNamed`. Keep routes shallow.

---

## 2. Architecture: feature-first Clean Architecture

```
lib/
├── app/                       # Root widget, theme, top-level routing
├── core/                      # Cross-cutting infra (crypto, constants, reactive)
│   ├── constants/
│   ├── reactive/              # ReplaySubject helper (used by local caches)
│   └── security/              # Credential cipher
├── features/                  # One folder per bounded context
│   └── <feature>/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── local/     # In-memory cache (+ secure storage for auth)
│       │   │   └── remote/    # Supabase
│       │   ├── models/        # JSON / DB ↔ entity converters
│       │   └── repositories/  # Repository implementations
│       ├── domain/
│       │   ├── entities/      # Plain Dart, framework-free
│       │   ├── repositories/  # Abstract contracts
│       │   └── usecases/      # Single-action callables
│       └── presentation/
│           ├── bloc/          # Bloc / Cubit + State (+ Event)
│           └── pages/         # Screens & widgets
└── main.dart                  # Composition root
```

### Dependency rule

```
presentation → domain ← data
                 ↑
                core
```

- `domain/` may not import anything from `data/`, `presentation/`, or any
  third-party package other than `equatable` and `meta`.
- `data/` depends on `domain/` (to implement contracts) and `core/`.
- `presentation/` depends on `domain/` only. **Never import a `data/` class
  from a widget or Bloc.**
- Cross-feature imports go through `domain/` entities and repositories only.

### Why a use case for a one-line repository call?

Every Bloc/Cubit calls **use cases**, not repositories directly. Yes, many of
them are one-liners (`LoginUseCase`, `LogoutUseCase`). That's intentional:

- The presentation layer has a single, named verb to test against.
- Adding cross-cutting logic (analytics, validation, retries) later happens in
  one place without touching the Bloc.
- It keeps Blocs free of `await _repo.x(...)` chains.

---

## 3. Composition root (`lib/main.dart`)

`main.dart` is the **only** place that:

1. Reads `--dart-define` env vars (Supabase URL/key).
2. Initializes Supabase and builds the credential cipher.
3. Constructs concrete data sources (local caches + Supabase-backed remotes),
   then concrete repositories.
4. Hands repositories to `App` typed as their **abstract** interface.

Rules:

- Provide repositories as their **interface type** (`AuthRepository`, not
  `AuthRepositoryImpl`). Presentation code reads `context.read<AuthRepository>()`.
- Cubits/Blocs that are screen-scoped are provided in their **page**, not
  globally. Only provide a Bloc globally if its state must survive across
  navigation (e.g. `AuthBloc`).
- Do **not** mix global and per-page providers for the same Cubit.

---

## 4. Domain layer rules

### Entities

- Pure Dart, no Flutter/Supabase/Drift imports.
- Immutable: every field `final`, constructor `const`.
- Extend `Equatable` and implement `props`.
- Provide `copyWith` only when state actually needs to be partially mutated
  (Blocs, settings, editor forms). Don't add `copyWith` to read-only DTOs.

### Enums

- Define string parsing as a top-level helper (`userRoleFromString`) and
  display/label fields as an extension (`UserRoleX`). Do not mix both styles.

### Failures

- Each feature owns one `*Failure` class implementing `Exception`, with a
  required `String message`. Failures are thrown by the repository, **never**
  by use cases or Blocs.
- Blocs catch the typed failure and emit an error state. They must also catch
  the generic `Object` to surface unexpected errors with a generic message.

### Use cases

- One file per use case. Name = verb + `UseCase`.
- A use case exposes `Future<R> call(...)` (or `Stream<R> call(...)` for
  streams). Invoke with `useCase(arg)`, not `useCase.call(arg)`.

---

## 5. Data layer rules

### Data sources

- `local/` data sources keep state in memory (Map + `ReplaySubject` for
  streams) and use `flutter_secure_storage` only when data has to survive a
  restart (currently just the cached auth session). They never know about
  Supabase.
- `remote/` data sources own a `SupabaseClient`. They never touch the local
  cache.
- Data sources throw typed exceptions (`AuthRemoteException`,
  `ProductRemoteException`, …) — not raw `Exception` strings.

### Models

- A `*Model` either:
  - **Extends** the domain entity and adds `fromRemote` / `toRemoteMap`
    factories (preferred when the model is a 1:1 representation), **or**
  - Is a standalone class with `toEntity()` (when the wire shape differs from
    the entity).
- Do **not** leak models out of `data/`. Repositories convert to entities
  before returning.

### Repositories

- Implementation lives in `data/repositories/<name>_impl.dart`.
- Implements the abstract contract from `domain/repositories/`.
- Owns the remote-first policy: write to Supabase, update the in-memory
  cache on success, and refill the cache via `syncProducts` /
  `syncPendingChanges` as needed.
- Catches infrastructure errors (`SocketException`, `TimeoutException`,
  `supabase.AuthException`, etc.) and re-throws as the feature's `*Failure`.

---

## 6. Presentation layer rules

### Bloc vs. Cubit

- **Bloc** when the feature has multiple discrete events (auth has `Started`,
  `LoginSubmitted`, `LogoutRequested`).
- **Cubit** when the feature is a small set of methods on a single state
  (catalogs, dashboards, editors).

### State

- Always `Equatable`. List all relevant fields in `props`.
- Use a sealed class hierarchy (`AuthState` → `AuthInitial`, `AuthLoading`,
  `AuthAuthenticated`, `AuthError`) **only** for finite-state flows. For
  data-loading screens, use a single state with `isLoading`/`error` fields.
- `copyWith` for single-state Cubits must accept every field. Use `bool
  clearError` parameter when nullable fields need to be reset to `null`.

### Files

- One Bloc/Cubit per file. Use `part of` for the matching `_state.dart` /
  `_event.dart` so they sit next to the Bloc.
- Naming: `<feature>_bloc.dart`, `<feature>_event.dart`, `<feature>_state.dart`
  for Bloc; `<feature>_cubit.dart`, `<feature>_state.dart` for Cubit.

### Widgets

- Pages own a `static const routeName = '/...'`. Register routes in `App` or
  navigate by name; do **not** hardcode route strings at call sites.
- Split widgets when a `build` method exceeds ~150 lines or when a child
  widget is reused. Private `_Widget` classes are fine; avoid passing
  `BuildContext` through helper functions — promote to a widget instead.

### No debug noise

- Never commit `print(...)`. Use `debugPrint` guarded by `kDebugMode`, or
  better, a structured logger.

---

## 7. Naming conventions

| Kind                  | Convention                              | Example                          |
| --------------------- | --------------------------------------- | -------------------------------- |
| Files                 | `snake_case.dart`                       | `auth_repository_impl.dart`      |
| Classes / enums       | `UpperCamelCase`                        | `AuthRepositoryImpl`             |
| Members               | `lowerCamelCase`                        | `restoreSession`                 |
| Private members       | leading `_`                             | `_remoteDataSource`              |
| Constants             | `lowerCamelCase` (avoid `SCREAMING`)    | `appName`                        |
| Abstract repositories | `<Name>Repository`                      | `AuthRepository`                 |
| Implementations       | `<Name>RepositoryImpl`                  | `AuthRepositoryImpl`             |
| Use cases             | `<Verb>UseCase`                         | `RestoreSessionUseCase`          |
| Events / states       | past tense / adjective                  | `LoginSubmitted`, `AuthLoading`  |

---

## 8. Error handling

Layered policy:

| Layer        | Throws                                  | Catches                                    |
| ------------ | --------------------------------------- | ------------------------------------------ |
| Data source  | `*RemoteException` / `*LocalException`  | Nothing (lets infra errors bubble)         |
| Repository   | Feature `*Failure`                      | All infra errors, maps to `*Failure`       |
| Use case     | Nothing (transparent passthrough)        | Nothing                                    |
| Bloc / Cubit | Nothing (emits state)                   | Typed `*Failure`, then generic `Object`    |
| Widget       | Nothing                                  | Reads state, never `try/catch`s use cases  |

Never swallow errors silently. If you intentionally ignore one (e.g. logout
when offline), leave a one-line comment explaining why.

---

## 9. Persistence

- Supabase is the only source of truth. Schema changes happen on the Supabase
  side (SQL migrations / dashboard); there is no local database.
- The app keeps a per-session in-memory cache inside each local data source
  so the presentation layer can subscribe to reactive streams. The helper
  for replay-once streams lives at `lib/core/reactive/replay_subject.dart`.
- The only thing persisted on-device is the encrypted auth session, stored
  via `flutter_secure_storage` inside `AuthLocalDataSource`.
- Do **not** reintroduce Drift/SQLite/Hive/Isar without prior discussion.

---

## 10. Secrets & configuration

- The app reads `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define` at
  build time. They are **not** in `pubspec.yaml`, source, or version control.
- Run locally:
  ```bash
  flutter run \
    --dart-define=SUPABASE_URL=... \
    --dart-define=SUPABASE_ANON_KEY=...
  ```
- The encryption key for cached credentials is generated on first launch and
  stored in `flutter_secure_storage`. Never persist it elsewhere.

---

## 11. Pull request checklist

Before requesting review:

- [ ] `dart format .` is clean.
- [ ] `flutter analyze` passes with **zero** warnings.
- [ ] `flutter test` passes.
- [ ] No `print(...)` calls.
- [ ] No new `data/` imports from `presentation/`.
- [ ] New entities extend `Equatable` and override `props`.
- [ ] New repositories have an abstract contract in `domain/`.
- [ ] New strings shown to the user are not hard-coded debug English (they
      should at minimum read naturally — i18n is on the roadmap).
- [ ] No new on-device DB dependencies were added (drift, sqflite, hive,
      isar, …).

PR description should answer: **what changed, why, and how to verify**.

---

## 12. Commit style

Short, present-tense, scoped to the feature touched:

```
auth: handle offline fallback on Supabase 5xx
inventory: split transactions section into header + list widgets
core: remove Drift; remote-only persistence via Supabase
```

No `[skip ci]`, no emoji, no auto-generated AI tool footers.
