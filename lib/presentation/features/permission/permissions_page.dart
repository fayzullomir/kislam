import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/permission/permission_page_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'permissions_cubit.dart';

/// Permission flow — two pages (notifications, location). Same Noor styling
/// as the surrounding madhab / location pages: warm neutral
/// canvas, eyebrow → display title → muted body, primary green CTA.
@RoutePage()
class PermissionsPage
    extends BasePage<PermissionsCubit, PermissionsState, PermissionsEvent> {
  PermissionsPage({super.key});

  final PageController _pageController = PageController();

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).checkAutoStartAvailability();
  }

  @override
  void onEventEmitted(BuildContext context, PermissionsEvent event) {
    switch (event.type) {
      case PermissionsEventType.onOpenNextPermission:
        _pageController.nextPage(
          duration: IslamicDesignTokens.durBase,
          curve: IslamicDesignTokens.easeNoor,
        );
        break;
      case PermissionsEventType.onOpenLoginPage:
        // After permissions, continue the first-run flow with madhab and
        // location pickers (location permission is already requested above).
        context.router.replaceAll([MadhabSelectionRoute()]);
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, PermissionsState state) {
    return Scaffold(
      backgroundColor: context.noor.neutral,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => cubit(context).setPageIndex(i),
                children: state.permissions
                    .map((p) => _PermissionStep(data: p))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PrimaryButton(
                    label: Strings.commonContinue,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      cubit(context).tryRequestPermission();
                    },
                  ),
                  if (state.currentPermission.customAction != null) ...[
                    const SizedBox(height: 8),
                    _SkipButton(
                      label: Strings.permissionSkip,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        cubit(context).skip();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Step — eyebrow → icon chip → title → body
// ===========================================================================

class _PermissionStep extends StatelessWidget {
  final PermissionPageData data;

  const _PermissionStep({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconChip(icon: data.icon),
          const SizedBox(height: 32),
          Text(
            data.eyebrow,
            textAlign: TextAlign.center,
            style: context.noor.tEyebrow,
          ),
          const SizedBox(height: 8),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: context.noor.tDisplay,
          ),
          const SizedBox(height: 12),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: context.noor.tBody.copyWith(
              color: context.noor.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Icon chip — soft primary wash circle, primary-colored Material icon.
// Mirrors the chip-on-card vocabulary used by GpsCard / ManualCard.
// ===========================================================================

class _IconChip extends StatelessWidget {
  final IconData icon;

  const _IconChip({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: context.noor.primaryWash,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 40,
        color: context.noor.primary,
      ),
    );
  }
}

// ===========================================================================
// Primary button — same shape/size as MadhabSelectionPage._PrimaryButton.
// ===========================================================================

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.noor.primary,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Skip button — muted text-only action under the primary CTA, shown only
// on the optional autostart step so the user can move on without opening
// the OEM settings page.
// ===========================================================================

class _SkipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SkipButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.noor.tBody.copyWith(
              color: context.noor.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
