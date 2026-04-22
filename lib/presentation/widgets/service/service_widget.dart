import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/domain/models/service/service_type.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

class ServiceWidget extends StatelessWidget {
  final ServiceType service;
  final Function(ServiceType service) onClicked;

  const ServiceWidget({
    super.key,
    required this.service,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => onClicked(service),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            top: 20,
            right: 12,
            bottom: 16,
          ),
          child: Row(
            children: [
              _buildIcon(context),
              SizedBox(width: 12),
              _buildNameAndDesc(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: service.serviceIcon.svg(
        width: 32,
        height: 32,
        color: context.iconAccent,
      ),
    );
  }

  Widget _buildNameAndDesc(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          service.localizedName
              .s(16)
              .w(600)
              .c(context.textPrimary)
              .copyWith(maxLines: 3, overflow: TextOverflow.ellipsis),
          SizedBox(height: 8),
          service.localizedDesc
              .s(12)
              .w(400)
              .c(context.textPrimary)
              .copyWith(maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
