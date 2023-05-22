import 'dart:async';

class Debouncer {
  Duration delay;
  Timer? timer;

  Debouncer(
    this.delay,
  );

  call(void Function() callback) {
    timer?.cancel();
    timer = Timer(delay, callback);
  }

  dispose() {
    timer?.cancel();
  }
}
