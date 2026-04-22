import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';

import 'package:koreaislam/core/gen/localization/strings.dart';

class ChipAddItem extends StatelessWidget {
  const ChipAddItem({
    super.key,
    required this.onClicked,
  });

  final Function() onClicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClicked(),
      child: Container(
        padding: EdgeInsets.only(left: 14, top: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: Color(0xFF5C6AC4).withAlpha(64)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Strings.commonChoose
                .w(600)
                .s(13)
                // .c(Color(0xFF5C6AC4))
                .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(width: 14),
            InkWell(
              onTap: () => onClicked(),
              child: Assets.images.component.chipAdd.svg(height: 20, width: 20),
            ),
          ],
        ),
      ),
    );
  }
}
