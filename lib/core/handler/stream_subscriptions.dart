import 'dart:async';

class StreamSubscriptions {
  final List<StreamSubscription> _subscriptions = [];

  void add(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  void addAll(List<StreamSubscription> subscriptions) {
    _subscriptions.addAll(subscriptions);
  }

  Future<void> cancelAll() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
  }

  int get length => _subscriptions.length;

  bool get isEmpty => _subscriptions.isEmpty;

  bool get isNotEmpty => _subscriptions.isNotEmpty;
}