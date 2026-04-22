import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/domain/models/group/teaching_group.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/presentation/widgets/image/network_circle_image_widget.dart';
import 'package:flutter/cupertino.dart';

class StudentWidget extends StatelessWidget{
  final Student student;

  const StudentWidget({super.key, required this.student});
  @override
  Widget build(BuildContext context) {
    return MaterialCard(
        borderRadius: BorderRadius.circular(6),
        child: Padding(
        padding: const EdgeInsets.all(10),
    child:Row(
      children: [
        NetworkCircleImageWidget(
            imageUrl: student.photoPath,
            width: 40,
            height: 40
        ),
        SizedBox(width: 8),
        "${student.lastName} ${student.lastName}".s(14).w(500).c(context.textPrimary)

      ],
    )
        ));
  }

}