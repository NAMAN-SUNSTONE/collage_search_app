import 'dart:async';

//use for debounce a function
class Debounce {
  Timer? _debounce;

  void call({required callBack, required int milliseconds}) {
    _checkAndDispose();
    _debounce = Timer(Duration(milliseconds: milliseconds), () async {
      await callBack();
      _checkAndDispose();
    });
  }

  _checkAndDispose() {
    if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
  }
}

class Throttle {
  final Duration delay;
  Timer? _timer;
  bool _isWaiting = false;

  Throttle(this.delay);

  void call(Function action) {
    if (!_isWaiting) {
      _isWaiting = true;
      action();
      _timer = Timer(delay, () {
        _isWaiting = false;
        if (_timer != null && _timer!.isActive) {
          _timer!.cancel();
        }
      });
    }
  }
}