import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../image/network_rounded_image_widget.dart';

class ListAvatars extends StatelessWidget{

  final List<String?> photosPath;
  final bool isInverse;

  const ListAvatars({super.key, required this.photosPath, this.isInverse=false});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: Stack(
        children: [
          ...List.generate(photosPath.length>6?6:photosPath.length, (index) {
            double left = index == 0 ? 0 : (index * 18);
            return isInverse?
            Positioned(
              right: index == 0 ? 0 : left,
              child: index==5?_buildChildCount(context,photosPath.length-5):_buildAvatar(context,photosPath[index]),
            ):
            Positioned(
              left: index == 0 ? 0 : left,
              child: index==5?_buildChildCount(context,photosPath.length-5):_buildAvatar(context,photosPath[index]),
            );
          })
        ],
      ),
    );
  }


  Widget _buildAvatar(BuildContext context,String? imgPath) {

    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isDarkMode?Color(0xFF313F34):Color(0xFFF8F8F8),
      ),
      child: NetworkRoundedImageWidget(
        imageUrl: imgPath??"",
        width: 30,
        height: 30,
      ),
    );
  }

  Widget _buildChildCount(BuildContext context,int count) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isDarkMode?Color(0xFF313F34):Color(0xFFEAEAEA),
        ),
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: isDarkMode?Color(0xFF313F34):Color(0xFFFFFFFF),
          ),
          child: Center(child: "+$count".s(10).c(!isDarkMode?context.textSecondary:Color(
              0x73989898)).w(500)),
        ));
  }

}