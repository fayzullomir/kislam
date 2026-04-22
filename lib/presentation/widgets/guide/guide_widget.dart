import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/domain/models/guide/guide_category.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';

class GuideWidget extends StatelessWidget {
  final GuideCategory guide;
  final Function(GuideCategory guide) onClicked;

  const GuideWidget({
    super.key,
    required this.guide,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => onClicked(guide),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              _buildIcon(context),
              SizedBox(width: 12),
              _buildLabel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: guide.icon.svg(
        width: 28,
        height: 28,
        color: context.colorAccent,
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Flexible(
      child: guide.name
          .s(16)
          .w(500)
          .c(context.textPrimary)
          .copyWith(maxLines: 3, overflow: TextOverflow.ellipsis),
    );
  }
}
