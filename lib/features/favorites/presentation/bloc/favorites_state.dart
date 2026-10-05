part of 'favorites_cubit.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.entries = const [],
    this.keys = const {},
    this.isLoading = false,
    this.hasLoaded = false,
    this.error,
  });

  final List<FavoriteEntry> entries;

  /// `"<bucket>:<targetId>"` for every saved target, including optimistic
  /// toggles that are still in flight. Drives the heart icons.
  final Set<String> keys;
  final bool isLoading;
  final bool hasLoaded;
  final String? error;

  static String keyFor(FavoriteKind kind, String targetId) {
    final bucket = switch (kind) {
      FavoriteKind.business => 'business',
      FavoriteKind.service || FavoriteKind.product => 'item',
      FavoriteKind.offer => 'offer',
    };
    return '$bucket:$targetId';
  }

  bool isFavorite(FavoriteKind kind, String targetId) =>
      keys.contains(keyFor(kind, targetId));

  List<FavoriteEntry> entriesOf(FavoriteKind kind) =>
      entries.where((e) => e.kind == kind).toList();

  int countOf(FavoriteKind kind) => entries.where((e) => e.kind == kind).length;

  FavoritesState copyWith({
    List<FavoriteEntry>? entries,
    Set<String>? keys,
    bool? isLoading,
    bool? hasLoaded,
    String? error,
    bool clearError = false,
  }) {
    return FavoritesState(
      entries: entries ?? this.entries,
      keys: keys ?? this.keys,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [entries, keys, isLoading, hasLoaded, error];
}
