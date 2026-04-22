class SelectionResult<T> {
  final String requestKey;
  final T data;

  const SelectionResult({
    required this.requestKey,
    required this.data,
  });
}