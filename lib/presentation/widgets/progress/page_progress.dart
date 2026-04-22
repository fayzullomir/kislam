import 'package:flutter/material.dart';

class PageProgressBar extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  const PageProgressBar({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(pageCount, (index) {
        final isPassed = index <= currentPage;

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            height: 3,
            decoration: BoxDecoration(
              color: isPassed ? Colors.green : Color(0xFFF2F4FB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
