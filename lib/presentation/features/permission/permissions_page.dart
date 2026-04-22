import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/permission/permission_page_data.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_container.dart';

import 'permissions_cubit.dart';

@RoutePage()
class PermissionsPage
    extends BasePage<PermissionsCubit, PermissionsState, PermissionsEvent> {
  PermissionsPage({super.key});

  final PageController _pageController = PageController();

  @override
  void onEventEmitted(BuildContext context, PermissionsEvent event) {
    switch (event.type) {
      case PermissionsEventType.onOpenNextPermission:
        _pageController.nextPage(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
        break;
      case PermissionsEventType.onOpenSystemSettings:
        _pageController.nextPage(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
        break;
      case PermissionsEventType.onOpenLoginPage:
        context.router.replaceAll([MainRoute()]);
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, PermissionsState state) {
    return Scaffold(
      backgroundColor: context.pageBackgroundColor,
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, PermissionsState state) {
    return Column(
      children: [
        _PermissionsPageView(
          pageController: _pageController,
          permissions: state.permissions,
          onPageChanged: (index) {
            cubit(context).setPageIndex(index);
          },
        ),
        _PermissionsBottomAction(
          onPressed: () {
            HapticFeedback.lightImpact();
            cubit(context).tryRequestPermission();
          },
        ),
      ],
    );
  }
}

class _PermissionsPageView extends StatelessWidget {
  const _PermissionsPageView({
    required this.pageController,
    required this.permissions,
    required this.onPageChanged,
  });

  final PageController pageController;
  final List<PermissionPageData> permissions;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: pageController,
        children: permissions
            .map((e) => _PermissionsPageItem(permissionData: e))
            .toList(),
        onPageChanged: onPageChanged,
      ),
    );
  }
}

class _PermissionsPageItem extends StatelessWidget {
  const _PermissionsPageItem({required this.permissionData});

  final PermissionPageData permissionData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: permissionData.image.svg(width: 126, height: 126),
          ),
          SizedBox(height: 16),
          permissionData.title
              .s(20)
              .w(600)
              .c(context.textPrimary)
              .copyWith(textAlign: TextAlign.center),
          SizedBox(height: 16),
          permissionData.message
              .s(14)
              .w(400)
              .c(context.textPrimary)
              .copyWith(textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _PermissionsBottomAction extends StatelessWidget {
  const _PermissionsBottomAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 64,
      ),
      child: Column(
        children: [
          ResponsiveContainer(
            child: MaterialElevatedButton(
              text: Strings.commonContinue,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
