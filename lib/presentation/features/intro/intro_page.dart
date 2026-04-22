import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/intro/intro_page_data.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_container.dart';

import 'intro_cubit.dart';

@RoutePage()
class IntroPage extends BasePage<IntroCubit, IntroState, IntroEvent> {
  IntroPage({super.key});

  final PageController _pageController = PageController();

  @override
  void onEventEmitted(BuildContext context, IntroEvent event) {}

  @override
  Widget onWidgetBuild(BuildContext context, IntroState state) {
    return Scaffold(
      backgroundColor: context.pageBackgroundColor,
      body: _buildBody(state, context),
    );
  }

  Widget _buildBody(IntroState state, BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 72),
        _IntroIndicator(
          pageController: _pageController,
          pageCount: state.introPages.length,
        ),
        SizedBox(height: 12),
        _IntroPageView(
          pageController: _pageController,
          introPages: state.introPages,
          onPageChanged: (index) {
            cubit(context).setPageIndex(index);
          },
        ),
        SizedBox(height: 32),
        _IntroBottomAction(
          onPressed: () {
            if (state.isLastPageShown) {
              context.router.replaceAll([PermissionsRoute()]);
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
        SizedBox(height: defaultBottomPadding),
      ],
    );
  }
}

class _IntroIndicator extends StatelessWidget {
  const _IntroIndicator({
    required this.pageController,
    required this.pageCount,
  });

  final PageController pageController;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 8,
            right: 16,
            bottom: 24,
          ),
          child: SmoothPageIndicator(
            controller: pageController,
            count: pageCount,
            effect: WormEffect(
              dotHeight: 4,
              dotWidth: 100,
              activeDotColor: StaticColors.colorAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class _IntroPageView extends StatelessWidget {
  const _IntroPageView({
    required this.pageController,
    required this.introPages,
    required this.onPageChanged,
  });

  final PageController pageController;
  final List<IntroPageData> introPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: pageController,
        children: introPages.map((e) => _IntroPageItem(introData: e)).toList(),
        onPageChanged: onPageChanged,
      ),
    );
  }
}

class _IntroPageItem extends StatelessWidget {
  const _IntroPageItem({required this.introData});

  final IntroPageData introData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: introData.image.svg(),
            ),
          ),
          SizedBox(height: 16),
          introData.title
              .s(20)
              .w(600)
              .c(context.textPrimary)
              .copyWith(textAlign: TextAlign.center),
          SizedBox(height: 16),
          introData.message
              .s(14)
              .w(400)
              .c(context.textPrimary)
              .copyWith(textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _IntroBottomAction extends StatelessWidget {
  const _IntroBottomAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MaterialElevatedButton(
          text: Strings.commonContinue,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
