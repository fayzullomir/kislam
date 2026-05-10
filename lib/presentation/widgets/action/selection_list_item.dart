import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class SelectionListItem extends StatelessWidget {
  final dynamic item;
  final String title;
  final String? desc;
  final SvgGenImage? icon;
  final bool selected;
  final bool enabled;
  final Function(dynamic item) onClicked;
  final EdgeInsets padding;
  final EdgeInsets contentPadding;
  final BorderRadius borderRadius;

  const SelectionListItem({
    super.key,
    required this.item,
    required this.title,
    this.desc,
    this.icon,
    required this.selected,
    this.enabled = true,
    required this.onClicked,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Semantics(
        selected: selected,
        enabled: enabled,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Material(
            color: StaticColors.innerCardColor,
            borderRadius: borderRadius,
            child: InkWell(
              onTap: enabled ? () => _onTap() : null,
              borderRadius: borderRadius,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: contentPadding,
                decoration: BoxDecoration(
                  color: selected
                      ? context.inputStrokeActiveColor.withOpacity(0.05)
                      : Colors.transparent,
                  borderRadius: borderRadius,
                  border: Border.all(
                    width: 1.5,
                    color: selected
                        ? context.inputStrokeActiveColor
                        : context.inputStrokeColor,
                  ),
                ),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      icon!.svg(width: 24, height: 16),
                      SizedBox(width: 12),
                    ],
                    Expanded(child: _buildContent(context)),
                    SizedBox(width: 12),
                    _buildRadioButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title
            .s(16)
            .w(500)
            .c(context.textPrimary)
            .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
        if (desc != null) ...[
          SizedBox(height: 6),
          desc!
              .s(13)
              .w(400)
              .c(context.textSecondary)
              .copyWith(maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ],
    );
  }

  Widget _buildRadioButton() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: selected
          ? Assets.images.component.selectionListItemRadioButtonSelected
              .svg(height: 20, width: 20, key: ValueKey(true))
          : Assets.images.component.selectionListItemRadioButtonUnSelected
              .svg(height: 20, width: 20, key: ValueKey(false)),
    );
  }

  void _onTap() {
    HapticFeedback.selectionClick();
    onClicked(item);
  }
}
