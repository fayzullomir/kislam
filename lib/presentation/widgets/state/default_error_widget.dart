import 'package:flutter/cupertino.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';

import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_outlined_button.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
    super.key,
    required this.isFullScreen,
    this.onRetryClicked,
  });

  final bool isFullScreen;
  final VoidCallback? onRetryClicked;

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Strings.validationErrorMessage
                    .s(14)
                    .w(400)
                    .c(context.textPrimary),
                SizedBox(height: 12),
                if (onRetryClicked != null)
                  MaterialOutlinedButton(
                    text: Strings.commonRetry,
                    width: 180,
                    onPressed: () {
                      if (onRetryClicked != null) onRetryClicked!();
                    },
                  )
              ],
            ),
          )
        : Center(
            child: SizedBox(
              height: 160,
              child: Column(
                children: [
                  Strings.commonEmptyMessage
                      .s(14)
                      .w(400)
                      .c(context.textPrimary),
                  SizedBox(height: 12),
                  MaterialElevatedButton(
                    text: Strings.commonRetry,
                    onPressed: () {
                      if (onRetryClicked != null) onRetryClicked!();
                    },
                    width: 180,
                  )
                ],
              ),
            ),
          );
  }
}
