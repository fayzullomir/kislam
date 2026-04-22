import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({super.key, required this.isFullScreen});

  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[300],
              strokeWidth: 3,
              color: context.colorAccent,
            ),
          )
        : SizedBox(
            height: 160,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[300],
                strokeWidth: 3,
                color: context.colorAccent,
              ),
            ),
          );
  }
}
