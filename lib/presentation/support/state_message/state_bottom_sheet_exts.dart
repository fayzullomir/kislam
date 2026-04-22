import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/state_message/state_message.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_type.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';

extension StateBottomSheetExts on BuildContext {
  void showStateMessageBottomSheet(StateMessage message) {
    _showStateBottomSheet(
      title: message.titleOrDefault,
      textSize: 22,
      message: message.message,
      type: message.type,
    );
  }

  void showStateBottomSheet({
    required String title,
    required String message,
    required MessageType type,
  }) {
    _showStateBottomSheet(
      title: title,
      textSize: 18,
      message: message,
      type: type,
    );
  }

  void _showStateBottomSheet({
    required String title,
    required double textSize,
    required String message,
    required MessageType type,
  }) {
    showCupertinoModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: this,
      builder: (BuildContext modalContext) {
        return Material(
          child: Container(
            color: bottomSheetColor,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(
                    child: title
                        .s(textSize)
                        .w(600)
                        .copyWith(textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 14),
                  message.s(16).w(500).copyWith(
                        maxLines: 5,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                  SizedBox(height: 32),
                  MaterialElevatedButton(
                    text: Strings.closeTitle,
                    onPressed: () {
                      Navigator.pop(this);
                      HapticFeedback.lightImpact();
                    },
                    backgroundColor: colors.buttonPrimary,
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
