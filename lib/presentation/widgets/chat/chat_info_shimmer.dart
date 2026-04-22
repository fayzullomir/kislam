import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_container_widget.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_item_widget.dart';

class ChatInfoShimmer extends StatelessWidget {
  const ChatInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerContainerWidget(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              _buildChatImage(),
              SizedBox(width: 12),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatName(context),
                    SizedBox(height: 6),
                    _buildLastMessage(context),
                    SizedBox(height: 4),
                    _buildLastMessageTime(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatImage() {
    return ShimmerItemWidget(
      width: 56,
      height: 56,
      borderRadius: BorderRadius.circular(56),
    );
  }

  Widget _buildChatName(BuildContext context) {
    return ShimmerItemWidget(height: 14);
  }

  Widget _buildLastMessage(BuildContext context) {
    return ShimmerItemWidget(height: 14);
  }

  Widget _buildLastMessageTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [ShimmerItemWidget(width: 80, height: 14)],
    );
  }
}
