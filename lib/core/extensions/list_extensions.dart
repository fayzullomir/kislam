import 'package:collection/collection.dart';

extension ListExtensions<T> on List<T> {
  T? getOrNull(int index) {
    return index >= 0 && index < length ? this[index] : null;
  }

  bool containsIf(bool Function(T element) condition) {
    return any(condition);
  }

  T? firstIf(bool Function(T element) condition) {
    return firstWhereOrNull(condition);
  }

  T? lastIf(bool Function(T element) condition) {
    return lastWhereOrNull(condition);
  }

  int indexIf(bool Function(T element) condition) {
    return indexWhere(condition);
  }

  void removeIf(bool Function(T element) condition) {
    return removeWhere(condition);
  }

  List<T> filterIf(bool Function(T element) condition) {
    return where(condition).toList();
  }

  // List<T> sortIf(bool Function(T element) condition) {
  //   return ;
  // }

  List<T> notContainsItems(List<T> other) {
    var setA = Set<T>.from(this);
    var setB = Set<T>.from(other);
    return setB.difference(setA).toList();
  }
}

extension NullableListExtensions<T> on List<T>? {
  T? getOrNull(int index) {
    if (this == null || index < 0 || index >= this!.length) return null;
    return this![index];
  }

  T? get firstOrNull => this == null || this!.isEmpty ? null : this!.first;

  T? get lastOrNull => this == null || this!.isEmpty ? null : this!.last;

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  int get safeLength => this?.length ?? 0;

  List<T> get orEmpty => this ?? [];
}