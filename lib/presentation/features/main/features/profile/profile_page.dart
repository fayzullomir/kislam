import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/data/datasource/preference/calculation_method_preferences.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/data/datasource/preference/quran_translation_preferences.dart';
import 'package:koreaislam/data/datasource/preference/theme_mode_preferences.dart';
import 'package:koreaislam/domain/models/calculation_method/calculation_method.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/domain/models/location/user_location.dart';
import 'package:koreaislam/domain/models/madhab/madhab.dart';
import 'package:koreaislam/domain/models/quran/quran_translation.dart';
import 'package:koreaislam/domain/models/theme/app_theme_mode.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/features/calculation_method/calculation_method_sheet.dart';
import 'package:koreaislam/presentation/features/language/change/change_language_page.dart';
import 'package:koreaislam/presentation/features/madhab/madhab_sheet.dart';
import 'package:koreaislam/presentation/features/quran/translation/quran_translation_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/profile/notification_settings_sheet.dart';
import 'package:koreaislam/presentation/features/theme_mode/change_theme_mode_page.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/widgets/image/network_circle_image_widget.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'profile_cubit.dart';

@RoutePage()
class ProfilePage extends BasePage<ProfileCubit, ProfileState, ProfileEvent> {
  const ProfilePage({super.key});

  @override
  Widget onWidgetBuild(BuildContext context, ProfileState state) {
    return Scaffold(
      backgroundColor: context.noor.neutral,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.isAuthorized) ...[
                _ProfileHeader(
                  state: state,
                  onTap: () => context.router.push(ProfileEditRoute()),
                ),
                const SizedBox(height: 28),
              ],

              // ----- Preferences (madhab + calc method + notifications) -----
              _SectionLabel(label: Strings.profileSectionPreferences),
              _SettingsCard(rows: [
                ValueListenableBuilder<Madhab>(
                  valueListenable: getIt<MadhabPreferences>().notifier,
                  builder: (_, madhab, __) => _ValueRow(
                    title: Strings.profileMadhab,
                    subtitle: Strings.profileMadhabSubtitle,
                    value: madhab.localizedName,
                    onTap: () => _openMadhabSheet(context),
                  ),
                ),
                const _CardDivider(),
                ValueListenableBuilder<CalculationMethod>(
                  valueListenable:
                      getIt<CalculationMethodPreferences>().notifier,
                  builder: (_, method, __) => _ValueRow(
                    title: Strings.profileCalculationMethod,
                    subtitle: Strings.profileCalculationMethodSubtitle,
                    value: method.localizedName,
                    onTap: () => _openCalculationMethodSheet(context),
                  ),
                ),
                const _CardDivider(),
                _ValueRow(
                  title: Strings.profileNotifications,
                  subtitle: Strings.profileNotificationsSubtitle,
                  value: Strings.profileNotificationsValueOn,
                  onTap: () => _openNotificationSheet(context),
                ),
              ]),

              const SizedBox(height: 24),

              // ----- Language & Location -----
              _SectionLabel(label: Strings.profileSectionLanguageLocation),
              _SettingsCard(rows: [
                ValueListenableBuilder<QuranTranslation>(
                  valueListenable: getIt<QuranTranslationPreferences>().notifier,
                  builder: (_, translation, __) => _ValueRow(
                    title: Strings.profileQuranTranslation,
                    subtitle: Strings.profileQuranTranslationSubtitle,
                    value: translation.translatorName,
                    onTap: () => _openQuranTranslationSheet(context),
                  ),
                ),
                const _CardDivider(),
                ValueListenableBuilder<UserLocation>(
                  valueListenable: getIt<LocationPreferences>().notifier,
                  builder: (_, location, __) => _ValueRow(
                    title: Strings.profileLocation,
                    subtitle: Strings.profileLocationSubtitle,
                    value: location.isSet
                        ? location.displayLabel
                        : IslamicMockData.profileLocationValue,
                    onTap: () => context.router.push(LocationSelectionRoute()),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // ----- Personalization (app language + themes) -----
              _SectionLabel(label: Strings.profileSectionPersonalization),
              _SettingsCard(rows: [
                _ValueRow(
                  title: Strings.profileAppLanguage,
                  subtitle: Strings.profileAppLanguageSubtitle,
                  value: _currentLanguageLabel(context),
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ChangeLanguagePage(),
                    );
                  },
                ),
                const _CardDivider(),
                _ValueRow(
                  title: Strings.profileThemes,
                  subtitle: Strings.profileThemesSubtitle,
                  value: _currentThemeLabel(),
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ChangeThemeModePage(),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // ----- Account -----
              _SectionLabel(label: Strings.profileSectionAccount),
              _SettingsCard(
                rows: state.isAuthorized
                    ? _authorizedAccountRows(context)
                    : _anonymousAccountRows(context),
              ),

              const SizedBox(height: 28),
              const _AppVersionBlock(),
            ],
          ),
        ),
      ),
    );
  }

  void _openNotificationSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: false,
      builder: (_) => const NotificationSettingsSheet(),
    );
  }

  void _openMadhabSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: false,
      builder: (_) => const MadhabSheet(),
    );
  }

  void _openCalculationMethodSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: false,
      builder: (_) => const CalculationMethodSheet(),
    );
  }

  void _openQuranTranslationSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: false,
      builder: (_) => const QuranTranslationSheet(),
    );
  }

  /// Resolves the current EasyLocalization locale back to a [Language]
  /// and returns its localized display name ("English", "O'zbekcha", …).
  /// Re-evaluated on every rebuild — `MaterialApp.router` rebuilds on
  /// locale change so the label updates as soon as the picker closes.
  String _currentLanguageLabel(BuildContext context) {
    return Language.values
        .firstWhere(
          (l) => l.locale == context.locale,
          orElse: () => Language.defaultLanguage,
        )
        .localizedName;
  }

  /// Reads the saved app theme mode and returns its localized label —
  /// "Light mode", "Dark mode", or "Same as system". Re-evaluated on
  /// every rebuild, so flipping the theme inside ChangeThemeModePage
  /// refreshes the row label as soon as the bottom sheet closes.
  String _currentThemeLabel() {
    final mode = getIt<ThemeModePreferences>().appThemeMode;
    switch (mode) {
      case AppThemeMode.darkMode:
        return Strings.themeModeDarkMode;
      case AppThemeMode.lightMode:
        return Strings.themeModeLightMode;
      case AppThemeMode.followSystem:
        return Strings.themeModeFollowSystem;
    }
  }

  List<Widget> _authorizedAccountRows(BuildContext context) {
    return [
      _IconRow(
        icon: Icons.devices_rounded,
        label: Strings.profileActiveSessions,
        onTap: () => context.router.push(ActiveSessionListRoute()),
      ),
      const _CardDivider(),
      _IconRow(
        icon: Icons.delete_outline_rounded,
        label: Strings.profileDeleteAccount,
        danger: true,
        onTap: () {
          showYesNoBottomSheet(
            context,
            title: Strings.profileDeleteAccountConfirmationTitle,
            message: Strings.profileDeleteAccountConfirmationMessage,
            noTitle: Strings.commonNo,
            onNoClicked: () {},
            yesTitle: Strings.commonYes,
            onYesClicked: () async {
              cubit(context).launchDeleteAccountUrl();
            },
          );
        },
      ),
      const _CardDivider(),
      _IconRow(
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
    ];
  }

  List<Widget> _anonymousAccountRows(BuildContext context) {
    return [
      _IconRow(
        icon: Icons.login_rounded,
        label: Strings.profileSignIn,
        // Sign-in flow is intentionally a no-op for now — wire it up once
        // the auth screens are ready.
        onTap: () {},
      ),
    ];
  }
}

// ===========================================================================
// Building blocks
// ===========================================================================

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(label, style: context.noor.tEyebrow),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> rows;

  const _SettingsCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.noor.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Divider(
        height: 1,
        thickness: 1,
        color: context.noor.line,
      ),
    );
  }
}

/// Title + subtitle on the left, current value + chevron on the right.
/// Mirrors the new design's "App language → English" pattern.
class _ValueRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final VoidCallback onTap;

  const _ValueRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.noor.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: context.noor.tCaption),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Text(
                value,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: context.noor.inkMuted,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: context.noor.inkSoft,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Legacy-style row with a colored icon square + label + chevron. Used
/// for action rows (Themes, Sign In, Active sessions, Logout, …) where
/// there is no value to show.
class _IconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _IconRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        danger ? context.noor.danger : context.noor.primary;
    final iconBg = danger
        ? context.noor.danger.withOpacity(0.10)
        : context.noor.primaryWash;
    final textColor =
        danger ? context.noor.danger : context.noor.ink;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontDisplay,
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.noor.inkSoft,
              size: 20,
            ),
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
      color: context.noor.surface,
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
                  color: context.noor.line,
                  width: 1.2,
                ),
                placeHolderImage:
                    Assets.images.profilePagePlaceHolderCircle.svg(
                  width: 40,
                  height: 40,
                  color: context.noor.inkSoft,
                ),
                errorImage:
                    Assets.images.profilePagePlaceHolderCircle.svg(
                  width: 40,
                  height: 40,
                  color: context.noor.inkSoft,
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
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontDisplay,
                        color: context.noor.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.phoneNumber.formatted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.noor.tBodySm,
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.noor.primaryWash,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.noor.primary,
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

class _AppVersionBlock extends StatelessWidget {
  const _AppVersionBlock();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: context.noor.primary,
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return Center(
            child: Text(
              '${snapshot.data?.version} (${snapshot.data?.buildNumber})',
              style: context.noor.tCaption,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
