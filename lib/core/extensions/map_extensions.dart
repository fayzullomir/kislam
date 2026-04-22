extension MapExtensions<K, V> on Map<K, V> {
  V? getOrNull(K key) {
    return containsKey(key) ? this[key] : null;
  }
}

extension MapWithIndex<T> on Iterable<T> {
  Iterable<R> mapWithIndex<R>(R Function(int index, T item) transform) {
    var index = 0;
    return map((e) => transform(index++, e));
  }
}
