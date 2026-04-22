import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/state_message/state_message.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_manager.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_type.dart';

@Singleton(as: StateMessageManager)
class StateMessageManagerImpl extends StateMessageManager {
  void Function(StateMessage message)? _onShowSnackBar;
  void Function(StateMessage message)? _onShowBottomSheet;
  void Function()? _onShowNotAuthorizedBottomSheet;

  @override
  void setListeners({
    required void Function(StateMessage message) onShowBottomSheet,
    required void Function(StateMessage message) onShowSnackBar,
    required void Function() onShowNotAuthorizedBottomSheet,
  }) {
    _onShowBottomSheet = onShowBottomSheet;
    _onShowSnackBar = onShowSnackBar;
    _onShowNotAuthorizedBottomSheet = onShowNotAuthorizedBottomSheet;
  }

  void _showSnackBar(MessageType type, String message, [String? title]) =>
      _onShowSnackBar?.call(StateMessage(type, message, title));

  void _showBottomSheet(MessageType type, String message, [String? title]) =>
      _onShowBottomSheet?.call(StateMessage(type, message, title));

  @override
  void showErrorBottomSheet(String message, [String? title]) =>
      _showBottomSheet(MessageType.error, message, title);

  @override
  void showInfoBottomSheet(String message, [String? title]) =>
      _showBottomSheet(MessageType.info, message, title);

  @override
  void showSuccessBottomSheet(String message, [String? title]) =>
      _showBottomSheet(MessageType.success, message, title);

  @override
  void showWarningBottomSheet(String message, [String? title]) =>
      _showBottomSheet(MessageType.warning, message, title);

  @override
  void showNotAuthorizedBottomSheet() {
    _onShowNotAuthorizedBottomSheet?.call();
  }

  @override
  void showErrorSnackBar(String message, [String? title]) =>
      _showSnackBar(MessageType.error, message, title);

  @override
  void showWarningSnackBar(String message, [String? title]) =>
      _showSnackBar(MessageType.warning, message, title);

  @override
  void showInfoSnackBar(String message, [String? title]) =>
      _showSnackBar(MessageType.info, message, title);

  @override
  void showSuccessSnackBar(String message, [String? title]) =>
      _showSnackBar(MessageType.success, message, title);
}
