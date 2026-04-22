import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/article/published_article_shimmer.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_builder.dart';

class PublishedArticleListShimmer extends StatelessWidget {
  final Axis axis;

  // Private constructor
  const PublishedArticleListShimmer._({
    super.key,
    required this.axis,
  });

  // ✅ Named constructor - Vertical
  const PublishedArticleListShimmer.vertical({Key? key})
      : this._(
          key: key,
          axis: Axis.vertical,
        );

  // ✅ Named constructor - Horizontal
  const PublishedArticleListShimmer.horizontal({Key? key})
      : this._(
          key: key,
          axis: Axis.horizontal,
        );

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return _buildHorizontalShimmerList(context);
    } else {
      return _buildVerticalShimmerList(context);
    }
  }

  Widget _buildHorizontalShimmerList(BuildContext context) {
    return SizedBox(
      height: 185,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: axis,
        itemCount: 3,
        padding: EdgeInsets.only(left: 12, right: 12),
        itemBuilder: (context, index) {
          return PublishedArticleShimmer.horizontal();
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 8);
        },
      ),
    );
  }

  Widget _buildVerticalShimmerList(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => ListView.separated(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.only(left: 12, top: 16, right: 12),
        scrollDirection: axis,
        shrinkWrap: true,
        itemCount: 12,
        itemBuilder: (context, index) {
          return PublishedArticleShimmer.vertical();
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8);
        },
      ),
      tablet: (context)=> GridView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 210,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return PublishedArticleShimmer.vertical();
        },
      )
    );
  }
}
