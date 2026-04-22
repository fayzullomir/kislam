import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/language/change/change_language_page.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_app_bar.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/features/theme_mode/change_theme_mode_page.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/widgets/image/network_circle_image_widget.dart';

import 'profile_cubit.dart';

@RoutePage()
class ProfilePage extends BasePage<ProfileCubit, ProfileState, ProfileEvent> {
  const ProfilePage({super.key});

  @override
  Widget onWidgetBuild(BuildContext context, ProfileState state) {
    return Scaffold(
      backgroundColor: IslamicDesignTokens.background,
      appBar: const IslamicAppBar(title: IslamicMockData.appTitle),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.isAuthorized) ...[
              _ProfileHeader(
                state: state,
                onTap: () => context.router.push(ProfileEditRoute()),
              ),
              const SizedBox(height: 24),
            ],
            _ProfileSection(
              title: Strings.profileSettingsBlock,
              items: [
                _ProfileItem(
                  icon: Icons.language_rounded,
                  label: Strings.profileChangeLanguage,
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ChangeLanguagePage(),
                    );
                  },
                ),
                _ProfileItem(
                  icon: Icons.dark_mode_outlined,
                  label: Strings.profileThemes,
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ChangeThemeModePage(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ProfileSection(
              title: Strings.profileControlBlock,
              items: state.isAuthorized
                  ? [
                      _ProfileItem(
                        icon: Icons.devices_rounded,
                        label: Strings.profileActiveSessions,
                        onTap: () =>
                            context.router.push(ActiveSessionListRoute()),
                      ),
                      _ProfileItem(
                        icon: Icons.delete_outline_rounded,
                        label: Strings.profileDeleteAccount,
                        danger: true,
                        onTap: () {
                          showYesNoBottomSheet(
                            context,
                            title: Strings
                                .profileDeleteAccountConfirmationTitle,
                            message: Strings
                                .profileDeleteAccountConfirmationMessage,
                            noTitle: Strings.commonNo,
                            onNoClicked: () {},
                            yesTitle: Strings.commonYes,
                            onYesClicked: () async {
                              cubit(context).launchDeleteAccountUrl();
                            },
                          );
                        },
                      ),
                      _ProfileItem(
                        icon: Icons.logout_rounded,
                        label: Strings.profileLogout,
                        danger: true,
                        onTap: () {
                          showYesNoBottomSheet(
                            context,
                            title: Strings.profileLogoutTitle,
                            message: Strings.profileLogoutDescription,
                            noTitle: Strings.commonNo,
                            onNoClicked: () {},
                            yesTitle: Strings.commonYes,
                            onYesClicked: () async {
                              await cubit(context).logOut();
                            },
                          );
                        },
                      ),
                    ]
                  : [
                      _ProfileItem(
                        icon: Icons.login_rounded,
                        label: Strings.profileSignIn,
                        onTap: () {},
                      ),
                    ],
            ),
            const SizedBox(height: 24),
            const _AppVersionBlock(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileState state;
  final VoidCallback onTap;

  const _ProfileHeader({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: IslamicDesignTokens.surface,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              NetworkCircleImageWidget(
                imageUrl: state.profilePhotoUrl,
                width: 60,
                height: 60,
                border: BorderSide(
                  color: IslamicDesignTokens.divider,
                  width: 1.2,
                ),
                placeHolderImage:
                    Assets.images.component.placeHolderCircle.svg(
                  width: 40,
                  height: 40,
                  color: IslamicDesignTokens.textMuted,
                ),
                errorImage: Assets.images.component.placeHolderCircle.svg(
                  width: 40,
                  height: 40,
                  color: IslamicDesignTokens.textMuted,
                ),
                contentPadding: const EdgeInsets.all(1.5),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: IslamicDesignTokens.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.phoneNumber.formatted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: IslamicDesignTokens.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: IslamicDesignTokens.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: IslamicDesignTokens.primary,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: IslamicDesignTokens.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: IslamicDesignTokens.surface,
            borderRadius:
                BorderRadius.circular(IslamicDesignTokens.radiusLg),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  items[i],
                  if (!isLast)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: IslamicDesignTokens.divider,
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        danger ? IslamicDesignTokens.dangerRed : IslamicDesignTokens.primary;
    final iconBg = danger
        ? IslamicDesignTokens.dangerRed.withOpacity(0.12)
        : IslamicDesignTokens.primarySoft;
    final textColor = danger
        ? IslamicDesignTokens.dangerRed
        : IslamicDesignTokens.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: IslamicDesignTokens.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppVersionBlock extends StatelessWidget {
  const _AppVersionBlock();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: IslamicDesignTokens.primary,
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return Center(
            child: Text(
              '${snapshot.data?.version} (${snapshot.data?.buildNumber})',
              style: const TextStyle(
                color: IslamicDesignTokens.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
