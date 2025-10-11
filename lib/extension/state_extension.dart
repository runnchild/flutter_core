import 'package:flutter/material.dart'
    show StatefulWidget, ValueNotifier, State;

// dispose all observers when the state is disposed
mixin NotifierState<S extends StatefulWidget> on State<S> {
  final _observers = <ValueNotifier, List<void Function()>>{};

  void observe<T>(ValueNotifier<T> notifier, void Function(T value) listener) {
    void observe() {
      listener(notifier.value);
    }

    notifier.addListener(observe);
    _observers[notifier] ??= [];
    _observers[notifier]?.add(observe);
  }

  @override
  void dispose() {
    for (var notifier in _observers.keys) {
      _observers[notifier]?.forEach(notifier.removeListener);
    }
    _observers.clear();
    super.dispose();
  }
}

extension ValueNotifierExt<T> on ValueNotifier<T> {
  void observe(NotifierState state, void Function(T value) listener) {
    state.observe(this, listener);
  }
}
