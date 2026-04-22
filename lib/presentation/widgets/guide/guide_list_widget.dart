import 'package:flutter/material.dart';
import 'package:koreaislam/domain/models/guide/guide_category.dart';
import 'package:koreaislam/presentation/widgets/guide/guide_widget.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_builder.dart';

class GuideListWidget extends StatelessWidget {
  final List<GuideCategory> guideCategories;
  final Function(GuideCategory guide) onGuideClicked;

  const GuideListWidget({
    super.key,
    required this.guideCategories,
    required this.onGuideClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 48),
        itemCount: guideCategories.length,
        itemBuilder: (BuildContext buildContext, int index) {
          final item = guideCategories[index];
          return GuideWidget(
            guide: item,
            onClicked: (guide) => onGuideClicked(guide),
          );
        },
        separatorBuilder: (BuildContext c, int index) => SizedBox(height: 8),
      ),
      tablet: (context) => GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 48),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 70,
        ),
        itemCount: guideCategories.length,
        itemBuilder: (BuildContext buildContext, int index) {
          final item = guideCategories[index];
          return GuideWidget(
            guide: item,
            onClicked: (guide) => onGuideClicked(guide),
          );
        },
      ),
    );
  }
}
