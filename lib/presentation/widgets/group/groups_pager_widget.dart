import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/domain/models/group/teaching_group.dart';
import 'package:koreaislam/presentation/widgets/group/teaching_group_shimmer.dart';
import 'package:koreaislam/presentation/widgets/group/teaching_group_widget.dart';
import 'package:koreaislam/presentation/widgets/state/loader_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GroupsPagerWidget extends StatelessWidget {
  final List<TeachingGroup> groups;
  final LoadingState state;

  const GroupsPagerWidget({super.key,  required this.state, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        LoaderStateWidget(
          loadingState: state,
          successBody: _buildSuccess(),
          loadingBody: _buildLoading(),
        ),
      ],
    );
  }


  Widget _buildSuccess(){
    PageController controller = PageController(
        viewportFraction: 0.90
    );
    return  SizedBox(
      height: 106,
        child:PageView.builder(
          controller: controller,
          padEnds: false,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.only(
                    left: 20
                ), // между страницами
                child:  TeachingGroupWidget(
                  group: groups[index],
                )

            );
          },
        )
    );
  }

  Widget _buildLoading(){
    PageController controller = PageController(
        viewportFraction: 0.90
    );
    return  SizedBox(
        height: 106,
        child:PageView.builder(
          controller: controller,
          padEnds: false,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 33,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.only(
                    left: 20
                ),
                child:  TeachingGroupShimmer()

            );
          },
        )
    );
  }


}
