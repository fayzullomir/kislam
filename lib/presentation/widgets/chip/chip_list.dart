import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/widgets/chip/chip_add_item.dart';
import 'package:koreaislam/presentation/widgets/chip/chip_show_less_item.dart';

import 'chip_show_more_item.dart';

class ChipList extends StatelessWidget {
  final List<Widget> chips;
  final VoidCallback? onClickedAdd;
  final VoidCallback? onClickedShowLess;
  final VoidCallback? onClickedShowMore;
  final int? showOnlyFirstItemsCount;
  final AutovalidateMode? autoValidateMode;
  final String? Function(int count)? validator;

  const ChipList({
    super.key,
    required this.chips,
    this.onClickedAdd,
    this.onClickedShowLess,
    this.onClickedShowMore,
    this.showOnlyFirstItemsCount,
    this.autoValidateMode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        return validator != null ? validator!(chips.length) : null;
      },
      builder: (state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              direction: Axis.horizontal,
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              children: _getActualChips(),
            ),
            if (state.hasError) SizedBox(height: 8),
            if (state.hasError)
              Row(
                children: [
                  SizedBox(width: 4),
                  (state.errorText!).s(12).c(Colors.red).copyWith(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                ],
              ),
          ],
        );
      },
    );
  }

  List<Widget> _getActualChips() {
    List<Widget> actualChips = [];
    if (onClickedAdd != null) {
      actualChips.add(ChipAddItem(onClicked: onClickedAdd!));
    }
    if (showOnlyFirstItemsCount == null ||
        showOnlyFirstItemsCount! <= 0 ||
        chips.length <= showOnlyFirstItemsCount!) {
      actualChips.addAll(chips);
      return actualChips;
    } else {
      if (showOnlyFirstItemsCount != null && showOnlyFirstItemsCount! > 0) {
        actualChips.addAll(chips);
        if (onClickedShowLess != null) {
          actualChips.add(ChipShowLessItem(onClicked: onClickedShowLess!));
        }
      } else {
        actualChips.addAll(chips.sublist(0, showOnlyFirstItemsCount));
        if (onClickedShowMore != null) {
          actualChips.add(ChipShowMoreItem(onClicked: onClickedShowMore!));
        }
      }
      return actualChips;
    }
  }
}
