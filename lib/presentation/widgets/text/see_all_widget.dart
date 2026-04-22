import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class SeeAllWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeaAllClicked;

  const SeeAllWidget({
    super.key,
    required this.title,
    this.onSeaAllClicked,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bool isSeaAllActionEnabled = onSeaAllClicked != null;
    return Padding(
      padding: EdgeInsets.only(
        left: isRtl ? 0 : 16,
        top: isSeaAllActionEnabled ? 6 : 8,
        right: isRtl ? 16 : 0,
        bottom: isSeaAllActionEnabled ? 4 : 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: title
                .w(600)
                .s(16)
                .c(context.textPrimary)
                .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (isSeaAllActionEnabled) ...[
            InkWell(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              onTap: () {
                onSeaAllClicked!();
                HapticFeedback.lightImpact();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 12, top: 1, right: 2, bottom: 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Strings.seeAll.s(12).w(600).c(StaticColors.colorAccent),
                    SizedBox(width: 4),
                    Transform.flip(
                      flipX: isRtl,
                      child: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: StaticColors.colorAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
