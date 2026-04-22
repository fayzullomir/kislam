
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class ChartsError extends StatelessWidget{
  const ChartsError({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 64,
      width: 64,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(4),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(360)),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(4),
              height: 44.8,
              width: 44.8,
              decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(360)),
            ),
          )
        ],
      ),
    );
  }

}