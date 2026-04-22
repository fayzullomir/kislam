import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/chat/chat_info_shimmer.dart';

class ChatInfoListShimmer extends StatelessWidget {
  const ChatInfoListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildVerticalShimmerList(context);
  }

  Widget _buildVerticalShimmerList(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => ChatInfoShimmer(),
      separatorBuilder: (BuildContext c, int index) => SizedBox(height: 8),
    );
  }
}
