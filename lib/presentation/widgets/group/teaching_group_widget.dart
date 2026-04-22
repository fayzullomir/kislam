import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/domain/models/group/teaching_group.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/avatars/list_avatars.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:flutter/material.dart';

class TeachingGroupWidget extends StatelessWidget {
  final TeachingGroup group;

  const TeachingGroupWidget({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        // context.router.push(EmployeeChildrenDetailRoute(group: group));
        },
      child: SizedBox(
        height: 106,
        child: MaterialCard(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      group.group.name.s(14).w(500).copyWith(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      "Jami o’quvchilar: ${group.students.length}"
                          .s(12)
                          .w(400)
                          .c(context.textSecondary),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(child: ListAvatars(photosPath: group.students.map((e)=>e.photoPath).toList())),
                          Icon(Icons.arrow_forward_sharp,
                              size: 22, color:context.iconPrimary),
                        ],
                      )
                    ]))),
      ),
    );
  }



}
