import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/date_extensions.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/domain/models/notification/app_notification.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';

class AppNotificationWidget extends StatelessWidget {
  final AppNotification notification;

  const AppNotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {},
      child: MaterialCard(
          padding: EdgeInsets.all(14),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: context.dateListGradient,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Assets.images.component.notification
                          .svg(width: 14, height: 14, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        notification.title.s(14).w(500),
                        const SizedBox(height: 6),
                        notification.createdAt
                            .toDateString()
                            .s(12)
                            .w(400)
                            .c(context.textSecondary),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              notification.body
                  .s(14)
                  .w(400)
                  .c(context.textSecondary)
                  .copyWith(maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          )),
    );
  }
}
