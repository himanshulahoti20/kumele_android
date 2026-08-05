import 'dart:async';

typedef IsLatestChecker = bool Function();

class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;
  Timer? _timer;
  Completer<void>? _delayCompleter;
  int _generation = 0;

  Future<void> runAsync(
    Future<void> Function(IsLatestChecker isLatest) action,
  ) async {
    _completeDelay();
    _timer?.cancel();

    final generation = ++_generation;
    bool isLatest() => generation == _generation;

    final delayCompleter = Completer<void>();
    _delayCompleter = delayCompleter;
    _timer = Timer(delay, () => _completeDelay());

    await delayCompleter.future;
    if (!isLatest()) return;

    await action(isLatest);
  }

  void cancel() {
    _completeDelay();
    _timer?.cancel();
    _timer = null;
    _generation++;
  }

  void dispose() => cancel();

  void _completeDelay() {
    final completer = _delayCompleter;
    _delayCompleter = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }
}
