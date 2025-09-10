import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;

  Timer? _timer;

  Debouncer(this.milliseconds);

  void call(VoidCallback fn) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), fn);
  }
}
