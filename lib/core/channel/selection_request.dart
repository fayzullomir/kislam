import 'package:koreaislam/core/channel/selection_result.dart';

class SelectionRequest<T> {
  final String requestKey;
  final T? initialSelection;
  final List<T> disabledItems;

  const SelectionRequest({
    required this.requestKey,
    this.initialSelection,
    this.disabledItems = const [],
  });

  const SelectionRequest.empty()
      : requestKey = '',
        initialSelection = null,
        disabledItems = const [];

  bool get isEmpty => requestKey.isEmpty;

  bool get isNotEmpty => requestKey.isNotEmpty;

  SelectionResult<T> toResult(T data) {
    return SelectionResult(requestKey: requestKey, data: data);
  }

  bool isDisabled(T item, bool Function(T a, T b) equals) {
    return disabledItems.any((e) => equals(e, item));
  }

  bool isEnabled(T item, bool Function(T a, T b) equals) {
    return !isDisabled(item, equals);
  }
}
