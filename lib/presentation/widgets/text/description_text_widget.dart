import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class DescriptionTextWidget extends StatelessWidget {
  final String text;
  final int maxLines;
  final EdgeInsets? padding;

  const DescriptionTextWidget({
    super.key,
    required this.text,
    this.maxLines = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: text
                .s(10)
                .w(400)
                .c(context.textPrimary)
                .copyWith(maxLines: maxLines, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
