# AI Coding Rules for Market App

This file is the contract every AI assistant (Claude Code, Cursor, Copilot
chat, Codex, etc.) must follow when generating, refactoring, or reviewing
code in this repository. **Humans should read `CONTRIBUTING.md` instead** —
it has the long-form rationale. This file is optimized for an LLM context
window: dense, prescriptive, no narrative.

If a rule here conflicts with `CONTRIBUTING.md`, **`CONTRIBUTING.md` wins**
and you should flag the drift.

---

## 0. Repository facts

- Flutter app, Dart `^3.9.2`, package name `market_app`.
- State: `flutter_bloc` (Bloc + Cubit). Equality: `equatable`.
- Persistence: Supabase (`supabase_flutter`) is the source of truth. **No
  local database** — Drift/SQLite was removed. Repositories use a
  per-session in-memory cache (`lib/core/reactive/replay_subject.dart`)
  behind the local data sources so the presentation layer keeps getting
  reactive streams.
- Session storage: handled by `supabase_flutter` itself. The app does
  **not** persist any credentials or tokens on-device.
- Composition root: `lib/main.dart`. **No** DI container.
- Routing: `MaterialApp.routes` + named pushes. **No** `go_router`.
- Codegen: **none**. **No** `freezed` / `json_serializable` / Drift.

---

## 1. Architecture (must follow exactly)

```
lib/
  app/                              # Root widget + routing
  core/                             # db, security, constants
  features/<feature>/
    data/{datasources/{local,remote},models,repositories}/
    domain/{entities,repositories,usecases}/
    presentation/{bloc,pages}/
  main.dart                         # Composition root
```

Import direction (you may **never** invert this):

```
presentation → domain ← data
                 ↑
                core
```

Hard rules:

- `domain/` imports only `dart:*`, `equatable`, `meta`, and other `domain/`
  files from the same feature.
- `presentation/` may **not** import from any `data/` directory (including
  models, data sources, repository implementations, or Supabase types).
- Cross-feature imports go through `domain/` only.
- `data/models/*` never leave `data/`. Repositories convert to entities.

If a request seems to require breaking these rules, stop and ask. Do not
generate code that violates them.

---

## 2. Domain layer — generation rules

### Entity template

```dart
import 'package:equatable/equatable.dart';

class Foo extends Equatable {
  const Foo({
    required this.id,
    required this.name,
    this.optional,
  });

  final String id;
  final String name;
  final String? optional;

  Foo copyWith({String? id, String? name, String? optional}) {
    return Foo(
      id: id ?? this.id,
      name: name ?? this.name,
      optional: optional ?? this.optional,
    );
  }

  @override
  List<Object?> get props => [id, name, optional];
}
```

Rules:
- Every field `final`, constructor `const`.
- Always extend `Equatable` and implement `props`.
- Add `copyWith` only if mutation is actually needed (Bloc states, editor
  forms). Skip for read-only DTOs.
- No Flutter, Drift, or Supabase imports here. **None.**

### Failures

```dart
class FooFailure extends Equatable implements Exception {
  const FooFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
  @override
  String toString() => 'FooFailure: $message';
}
```

One `*Failure` class per feature. Thrown only by repositories.

### Use cases

```dart
class DoFooUseCase {
  const DoFooUseCase(this._repository);
  final FooRepository _repository;
  Future<Foo> call({required String id}) => _repository.doFoo(id: id);
}
```

- One file per use case. Name = `<Verb>UseCase`.
- Expose a single `call(...)` method.
- No business logic beyond delegating to the repository. If you find
  yourself writing logic, push it into the repository or surface it to the
  human for review.

### Repository contract

```dart
abstract class FooRepository {
  Stream<List<Foo>> watchFoos();
  Future<Foo?> getFoo(String id);
  Future<Foo> upsertFoo(Foo foo);
}
```

Abstract only. No fields, no implementation, no Supabase imports.

---

## 3. Data layer — generation rules

### Data sources

- Local: owns an in-memory cache (Map + `ReplaySubject` for streams).
  Never persists anything on-device (Supabase auth state is persisted by
  `supabase_flutter` itself, not by a local data source). Never knows
  about Supabase.
- Remote: takes `SupabaseClient`. Never touches the local cache.
- Throw typed exceptions (`FooRemoteException`, `FooLocalException`) — not
  raw `Exception(...)`.

### Models

- Prefer `class FooModel extends Foo { ... }` with `fromRemote` /
  `toRemoteMap` (and `fromEntity` if the repo round-trips through a model).
- Provide `toEntity()` only if the model adds fields beyond the entity.
- Models never escape `data/`.

### Repository implementation

```dart
class FooRepositoryImpl implements FooRepository {
  FooRepositoryImpl({
    required FooRemoteDataSource remoteDataSource,
    required FooLocalDataSource localDataSource,
  }) : _remote = remoteDataSource, _local = localDataSource;

  final FooRemoteDataSource _remote;
  final FooLocalDataSource _local;

  @override
  Future<Foo> upsertFoo(Foo foo) async {
    try {
      // local first (offline-first), then remote, then mark synced
      ...
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  FooFailure _mapInfraError(Object error) {
    if (error is FooFailure) return error;
    if (error is FooRemoteException) return FooFailure(error.message);
    if (error is SocketException) return const FooFailure('No internet connection');
    if (error is TimeoutException) return const FooFailure('Request timed out');
    return FooFailure(error.toString());
  }
}
```

- All infrastructure errors map to one `_mapInfraError(...)` helper. Never
  duplicate four catch arms across methods.
- Remote-first policy: write to Supabase, then update the in-memory cache
  on success. Reads stream from the cache; repositories call
  `syncProducts` / `syncPendingChanges` to refill it from Supabase.

---

## 4. Presentation layer — generation rules

### Bloc vs. Cubit

- **Bloc** when the feature has discrete named events.
- **Cubit** when it's a single state with method-style mutations.

### State

- Always `Equatable`. List every relevant field in `props`.
- Sealed class hierarchy only for finite-state flows
  (`Initial`/`Loading`/`Authenticated`/`Error`). For data-loading screens
  use a **single** state with `isLoading` / `error` fields.
- `copyWith` accepts every field. To reset a nullable to `null`, add a
  `bool clearX = false` parameter:

```dart
FooState copyWith({String? error, bool clearError = false}) {
  return FooState(
    error: clearError ? null : error ?? this.error,
  );
}
```

### Bloc / Cubit body

```dart
class FooCubit extends Cubit<FooState> {
  FooCubit({required FooRepository repository})
      : _repository = repository,
        super(const FooState());

  final FooRepository _repository;
  StreamSubscription<List<Foo>>? _subscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    _subscription?.cancel();
    _subscription = _repository.watchFoos().listen(
      (foos) => emit(state.copyWith(isLoading: false, foos: foos)),
      onError: (error, _) =>
          emit(state.copyWith(isLoading: false, error: error.toString())),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
```

- Cubits call **use cases** for Blocs that drive multi-step flows; for
  simple Cubits that fan a repository stream into a state, calling the
  repository directly via `domain/` interfaces is acceptable.
- Always cancel stream subscriptions in `close()`.
- Catch typed `*Failure` first, then `Object` for safety.

### Widgets

- Page widgets own `static const routeName = '/...'`.
- Split a widget when its `build` exceeds ~150 lines or when a sub-tree is
  reused.
- Promote helpers to private widgets (`class _Header extends StatelessWidget`)
  rather than passing `BuildContext` around.

---

## 5. Composition (`lib/main.dart`)

- Only `main.dart` constructs concrete data sources and repositories.
- Provide repositories as their **interface** type
  (`RepositoryProvider<FooRepository>.value(value: fooRepository)`).
- Screen-scoped Cubits/Blocs are provided **inside the page** that owns
  them. Global Bloc providers only for app-wide state (e.g. `AuthBloc`).

---

## 6. Forbidden patterns (do not generate)

- `print(...)`. Use `dart:developer` `developer.log(...)` in `data/`,
  `debugPrint(...)` in `presentation/`.
- `RepositoryProvider<FooRepositoryImpl>` — always provide the interface.
- `SupabaseClient` references inside `presentation/` or `domain/`.
- Re-introducing Drift / SQLite or any other on-device database without
  prior discussion. Persistence is remote-only (Supabase).
- `// ignore: <rule>` without a one-line justification on the same line.
- `// TODO` without a name and a description of the fix. Prefer raising
  the question to the human reviewer instead.
- New top-level utilities files (`utils.dart`, `helpers.dart`). Put helpers
  next to their one caller, or inside the class that uses them.
- `Future.wait` over operations that mutate the same in-memory cache or
  remote table — order matters; sequence them.
- Catching `Exception` and silently swallowing it. If you intentionally
  ignore an error, leave a one-line comment explaining why.

---

## 7. When you're asked to add a new feature

Follow this exact order — do not skip:

1. **Confirm the feature folder name** (singular noun, snake_case).
2. **Domain first**:
   - Entities (`features/<name>/domain/entities/<entity>.dart`)
   - Failure (`<name>_failure.dart`)
   - Repository interface (`domain/repositories/<name>_repository.dart`)
   - Use cases (`domain/usecases/<verb>_use_case.dart`)
3. **Data**:
   - Models extending entities, with `fromRemote` / `toRemoteMap` factories.
   - Local data source: in-memory cache (Map + `ReplaySubject` for streams).
   - Remote data source on `SupabaseClient`.
   - Repository implementation, with `_mapInfraError`.
4. **Presentation**:
   - Bloc/Cubit + State (+ Event for Bloc) as `part of` files.
   - Page with `static const routeName`.
5. **Wire into `main.dart`** as the interface type.
6. **Self-check** against §1 dependency rule before reporting done.

If the human asks for "just the model" or "just the cubit," still surface
which of the above steps would be needed for the feature to actually work.

---

## 8. When you're asked to modify existing code

- Read the existing file before editing — match its existing style
  (indentation, brace placement, trailing commas, single vs. double quotes).
- Never rewrite a file from scratch when an `Edit` of a few lines suffices.
- Preserve behavior unless explicitly asked to change it. Refactor =
  same observable behavior. Bug fix = behavior change, explicitly called out.
- If you spot a violation of these rules in code you're already touching,
  fix it inline and mention it in the response. If the violation is in
  unrelated code, mention it but do not silently fix it.
- After changes, **always** run `flutter analyze --no-pub` and report
  what's left. Do not claim "done" with new warnings.

---

## 9. Output discipline

- Reply with the minimum text needed to convey what changed and why.
- Reference files as `relative/path.dart:LINE`.
- When showing diffs in chat, show **only** the changed regions, not the
  whole file.
- Never paste generated Drift files (`*.g.dart`) into chat.
- Do not invent file paths, package names, or APIs. If a symbol is not in
  the codebase or in the declared dependencies, grep for it before using
  it; if it's not there, ask.

---

## 10. Prompt suggestions for this project

Copy these as-is. They include the context the model needs to follow this
file without re-discovering the architecture each turn.

### 10.1 New feature scaffold

```
You are working in the `market_app` Flutter repo. Read AGENTS.md before
generating anything.

Task: scaffold a new feature called <name> for <one-sentence purpose>.

Domain shape:
- Entity <Entity> with fields: <field: Type, ...>
- Repository methods: <verb(...) -> Type, ...>
- Use cases: <list>

Data:
- Remote table: market.<table_name> with columns <list>
- Local: in-memory cache (Map keyed by id + `ReplaySubject<List<...>>` for
  the watch stream). Do NOT add a Drift table — persistence is remote-only.

Presentation:
- One Cubit watching the repository stream + a single page rendering a
  list. No editor yet.

Constraints:
- Follow AGENTS.md sections 1–5 exactly.
- Wire the repository as the abstract type in lib/main.dart.
- Run `flutter analyze --no-pub` at the end and report remaining issues.
```

### 10.2 Add a method to an existing feature

```
Repo: market_app. Read AGENTS.md.

Feature: <feature>
Add method: <signature> on <FooRepository>.

Behavior:
- <bullet>
- <bullet>
- Errors map through _mapInfraError into <FooFailure>.

Touch only:
- domain/repositories/<...>.dart (add abstract method)
- data/datasources/{local,remote}/<...>.dart (add the queries)
- data/repositories/<...>_impl.dart (implement)
- The cubit that should expose it: <name>

Do NOT modify pages or unrelated cubits. Do NOT add new dependencies.
After editing, run `flutter analyze --no-pub` and report.
```

### 10.3 Bug fix

```
Repo: market_app. Read AGENTS.md before changing code.

Bug: <symptom, with reproduction steps if known>
Suspected location: <file or "investigate">

Constraints:
- Minimal diff. Refactor only the offending code.
- If the root cause requires a wider change, stop and explain before
  editing.
- Add a one-line comment at the fix site explaining WHY the previous
  behavior was wrong (only if not obvious from the diff).
- Do not introduce new abstractions for this fix.
```

### 10.4 Refactor / cleanup

```
Repo: market_app. Read AGENTS.md.

Refactor target: <file or directory>
Goal: <e.g. "match the conventions in AGENTS.md §3", "remove duplicated
catch arms by introducing _mapInfraError", "split widgets per §4">.

Hard constraints:
- Behavior must not change. Public method signatures must not change
  unless I asked for that.
- No new dependencies.
- Run `flutter analyze --no-pub`. The issue count must be <= the current
  baseline (currently 6 pre-existing info-level issues). Report the diff.
```

### 10.5 Code review

```
You are reviewing a diff for the market_app Flutter repo. Read AGENTS.md
first.

Diff:
<paste diff>

Produce:
1. Architecture violations (dependency direction, layer boundaries) — must
   block merge.
2. Convention violations (naming, Equatable, print, error handling).
3. Bug risks (untracked subscriptions, race conditions, swallowed errors).
4. Nits — separate section, do not block merge on these.

Reference each finding with `path/to/file.dart:LINE`.
```

## 11. Self-check before declaring done

Run through this list mentally on every change:

- [ ] `flutter analyze --no-pub` issue count ≤ baseline.
- [ ] No new `print(...)`.
- [ ] No `presentation/` → `data/` imports added.
- [ ] New entities extend `Equatable` with full `props`.
- [ ] New repositories have an abstract contract in `domain/`.
- [ ] Cubits cancel subscriptions in `close()`.
- [ ] `--dart-define` secrets unchanged and unread anywhere except
      `main.dart`.
- [ ] No new on-device DB dependencies (drift, sqflite, hive, isar, ...).

If any box is unchecked, fix it before reporting the task as complete.
