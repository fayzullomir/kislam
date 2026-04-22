import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/support/cubit/base_builder.dart';
import 'package:koreaislam/presentation/support/cubit/base_event.dart';
import 'package:koreaislam/presentation/support/cubit/base_state.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/support/state_message/state_bottom_sheet_exts.dart';
import 'package:koreaislam/presentation/support/state_message/state_message.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_type.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';

abstract class BasePage<CUBIT extends Cubit<BaseState<STATE, EVENT>>, STATE,
    EVENT> extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  void onWidgetCreated(BuildContext context) {}

  void onWidgetRecreated(BuildContext context) {}

  void onEventEmitted(BuildContext context, EVENT event) {}

  Widget onWidgetBuild(BuildContext context, STATE state);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CUBIT>(
      create: (_) => getIt<CUBIT>(),
      child: _PageBody<CUBIT, STATE, EVENT>(
        onFirstBuild: onWidgetCreated,
        onRebuild: onWidgetRecreated,
        onEventEmitted: onEventEmitted,
        onBuildWidget: onWidgetBuild,
      ),
    );
  }

  CUBIT cubit(BuildContext context) {
    return context.read<CUBIT>();
  }

  EVENT event(BuildContext context) {
    return context.read<EVENT>();
  }

  void showExitAlertDialog(BuildContext context) {
    TextButton negativeButton = TextButton(
      child: Text(Strings.commonNo),
      onPressed: () {
        context.router.maybePop(context);
      },
    );

    TextButton positiveButton = TextButton(
      child: Text(Strings.commonYes),
      onPressed: () {
        context.router.maybePop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Alert Title"),
      content: Text("This is the alert message."),
      actions: [negativeButton, positiveButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          child: Center(
            child: CircularProgressIndicator(color: context.colorAccent),
          ),
        );
      },
    );
  }

  void hideProgressBarDialog(BuildContext context) {
    context.router.maybePop();
  }

  void showErrorBottomSheet(BuildContext context, String message) =>
      context.showStateMessageBottomSheet(StateMessage(
        MessageType.error,
        message,
      ));

  void showInfoBottomSheet(BuildContext context, String message) =>
      context.showStateMessageBottomSheet(StateMessage(
        MessageType.info,
        message,
      ));

  void showSuccessBottomSheet(BuildContext context, String message) =>
      context.showStateMessageBottomSheet(StateMessage(
        MessageType.success,
        message,
      ));

  void showWarningBottomSheet(BuildContext context, String message) =>
      context.showStateMessageBottomSheet(StateMessage(
        MessageType.warning,
        message,
      ));

  void showYesNoBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
    required String yesTitle,
    required Function onYesClicked,
    required String noTitle,
    required Function onNoClicked,
  }) {
    showCupertinoModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Material(
        child: Container(
          color: context.bottomSheetColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12),
              BottomSheetTitle(title: title),
              SizedBox(height: 24),
              Center(
                  child: message.s(16).copyWith(textAlign: TextAlign.center)),
              SizedBox(height: 32),
              Row(
                children: <Widget>[
                  SizedBox(width: 16),
                  Expanded(
                    child: MaterialElevatedButton(
                      text: noTitle,
                      onPressed: () {
                        onNoClicked();
                        Navigator.pop(context);
                        HapticFeedback.lightImpact();
                      },
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: MaterialElevatedButton(
                      text: yesTitle,
                      onPressed: () {
                        onYesClicked();
                        Navigator.pop(context);
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              SizedBox(height: defaultBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  void showDefaultDatePickerDialog({
    required BuildContext context,
    String? title,
    DateTime? selectedDate,
    DateTime? recommendedDate,
    DateTime? minDate,
    DateTime? maxDate,
    required Function(String date) onDateSelected,
  }) {
    final dateFormat = DateFormat("yyyy-MM-dd");

    final now = DateTime.now();
    final effectiveMinDate = minDate ?? DateTime(1930);
    final effectiveMaxDate = maxDate ?? DateTime(2100);

    var initialDate = selectedDate ?? recommendedDate ?? now;

    if (initialDate.isBefore(effectiveMinDate)) {
      initialDate = effectiveMinDate;
    } else if (initialDate.isAfter(effectiveMaxDate)) {
      initialDate = effectiveMaxDate;
    }

    var currentSelectedDate = dateFormat.format(initialDate);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext buildContext) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: context.bottomSheetColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                BottomSheetTitle(title: title ?? ""),
                SizedBox(
                  height: 320,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(brightness: context.brightness),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate,
                      minimumDate: effectiveMinDate,
                      maximumDate: effectiveMaxDate,
                      onDateTimeChanged: (DateTime newDateTime) {
                        currentSelectedDate = dateFormat.format(newDateTime);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MaterialElevatedButton(
                    text: Strings.commonSave,
                    onPressed: () {
                      onDateSelected(currentSelectedDate);
                      Navigator.of(buildContext).pop();
                    },
                  ),
                ),
                SizedBox(height: defaultBottomPadding),
              ],
            ),
          ),
        );
      },
    );
  }

  void showToast(
    BuildContext context,
    String message,
    bool isSuccess,
  ) {
    final color = isSuccess ? Colors.green : Colors.red;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20),
        elevation: 6,
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal StatefulWidget for lifecycle management
class _PageBody<CUBIT extends Cubit<BaseState<STATE, EVENT>>, STATE, EVENT>
    extends StatefulWidget {
  final void Function(BuildContext) onFirstBuild;
  final void Function(BuildContext) onRebuild;
  final void Function(BuildContext, EVENT) onEventEmitted;
  final Widget Function(BuildContext, STATE) onBuildWidget;

  const _PageBody({
    required this.onFirstBuild,
    required this.onRebuild,
    required this.onEventEmitted,
    required this.onBuildWidget,
  });

  @override
  State<_PageBody<CUBIT, STATE, EVENT>> createState() =>
      _PageBodyState<CUBIT, STATE, EVENT>();
}

class _PageBodyState<CUBIT extends Cubit<BaseState<STATE, EVENT>>, STATE, EVENT>
    extends State<_PageBody<CUBIT, STATE, EVENT>> {
  @override
  void initState() {
    super.initState();
    // initState FAQAT 1 MARTA chaqiriladi - eng ishonchli joy
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onFirstBuild(context);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _PageBody<CUBIT, STATE, EVENT> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Parent qayta build qilganda (widget props o'zgarganda)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onRebuild(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseListener<CUBIT, STATE, EVENT>(
      onEventEmitted: (event) => widget.onEventEmitted(context, event),
      widget: BaseBuilder<CUBIT, STATE, EVENT>(
        onWidgetBuild: widget.onBuildWidget,
      ),
    );
  }
}
