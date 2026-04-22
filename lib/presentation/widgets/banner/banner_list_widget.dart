import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/domain/models/banner/banner_image.dart';
import 'package:koreaislam/presentation/widgets/banner/banner_widget.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_builder.dart';

class BannerListWidget extends StatelessWidget {
  final List<BannerImage> banners;

  const BannerListWidget({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          height: 120,
          viewportFraction: 1,
        ),
        items: banners.map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.only(
                  left: 14,
                  top: 20,
                  right: 14,
                  bottom: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: BannerWidget(imageUrl: banner.imageUrl),
                ),
              );
            },
          );
        }).toList(),
      ),
      tablet: (context) => CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          height: 120,
          viewportFraction: 0.4,
        ),
        items: banners.map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.fromLTRB(4, 20, 4, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: BannerWidget(imageUrl: banner.imageUrl),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
