import 'dart:async';
import 'package:flutter/material.dart';

/// A debounce utility class to limit the frequency of function calls
class Debounce {
  final Duration duration;
  Timer? _timer;

  Debounce({required this.duration});

  /// Call a function after the specified duration
  void call(VoidCallback callback) {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    _timer = Timer(duration, callback);
  }

  /// Cancel the pending callback
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose of the debounce timer
  void dispose() {
    cancel();
  }

  /// Get whether there's a pending callback
  bool get isPending => _timer != null && _timer!.isActive;
}