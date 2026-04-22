
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {

  final String title;
  final String subTitle;
  final Widget icon;
  final Color iconColor;
  final Function() onClick;

  const InfoCard({super.key, required this.title, required this.subTitle, required this.icon, required this.iconColor, required this.onClick});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onClick,
        child: MaterialCard(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Center(child: icon),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title.s(10).w(400).copyWith(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subTitle.s(16).w(600).copyWith(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ]
                    ),
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }

}