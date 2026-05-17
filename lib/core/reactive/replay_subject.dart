import 'dart:async';

/// Minimal "replay-one" broadcast controller.
///
/// New subscribers immediately receive the last emitted value and then any
/// future values. This is the behavior the presentation layer used to get
/// from Drift's reactive streams; we recreate it here so removing Drift
/// doesn't force adding `rxdart` as a direct dependency.
class ReplaySubject<T> {
  ReplaySubject(T initial) : _value = initial;

  T _value;
  final StreamController<T> _controller = StreamController<T>.broadcast();

  T get value => _value;

  Stream<T> get stream async* {
    yield _value;
    yield* _controller.stream;
  }

  void add(T value) {
    _value = value;
    if (!_controller.isClosed) {
      _controller.add(value);
    }
  }

  bool get isClosed => _controller.isClosed;

  Future<void> close() => _controller.close();
}
