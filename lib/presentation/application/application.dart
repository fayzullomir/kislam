import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/core/handler/stream_subscriptions.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/fcm_token_preferences.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/data/datasource/preference/temporarily_data_holder.dart';
import 'package:koreaislam/data/datasource/preference/theme_mode_preferences.dart';
import 'package:koreaislam/data/repositories/auth/session_repository.dart';
import 'package:koreaislam/data/repositories/notification/notification_repository.dart';
import 'package:koreaislam/domain/channels/app_theme_mode_channel.dart';
import 'package:koreaislam/domain/channels/login_event_channel.dart';
import 'package:koreaislam/domain/channels/logout_event_channel.dart';
import 'package:koreaislam/domain/models/logout_event/logout_event_type.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/application/services/fcm/firebase_notification_handler.dart';
import 'package:koreaislam/presentation/application/services/fcm/firebase_notification_service.dart';
import 'package:koreaislam/presentation/features/auth/sign_in/sign_in_launch_type.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/router/auto_router_extensions.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/support/state_message/state_message.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_manager.dart';
import 'package:koreaislam/presentation/support/state_message/state_snack_bar_exts.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_outlined_button.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  // Event channels
  final LoginEventChannel _loginEventChannel = getIt.get();
  final LogoutEventChannel _logoutEventChannel = getIt.get();
  final AppThemeModeChannel _appThemeModeChannel = getIt.get();

  // Repositories
  final NotificationRepository _notificationRepository = getIt.get();
  final SessionRepository _sessionRepository = getIt.get();

  // Preferences
  final AppConfigPreferences _appConfigPreferences = getIt.get();
  final FcmTokenPreferences _fcmTokenPreferences = getIt.get();
  final AuthPreferences _authPreferences = getIt.get();
  final ProfilePreferences _profilePreferences = getIt.get();
  final ThemeModePreferences _themeModePreferences = getIt.get();

  // Notification services
  final _notificationService = FirebaseNotificationService();
  final _navigationHandler = FirebaseNotificationHandler();

  // State
  late ThemeMode _themeMode;
  late final AppRouter _appRouter;
  bool _managersInitialized = false;

  // Subscriptions
  final StreamSubscriptions _streamSubscriptions = StreamSubscriptions();

  @override
  void initState() {
    super.initState();

    // Setup event listeners
    _setupStreamSubscriptions();

    // Initialize app router
    _appRouter = AppRouter();

    // Prepare token holder
    _prepareTokenHolder();

    // Initialize notifications
    _initializeNotifications();

    // Setup FCM token management
    _checkAndGetFcmToken();
    _listenFcmTokenRefreshing();
  }

  @override
  void dispose() {
    _streamSubscriptions.cancelAll();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      //
      theme: _configureLightTheme(),
      darkTheme: _configureDarkTheme(),
      themeMode: _themeMode,
      //
      routerConfig: _configureRouterConfig(),
      //
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      //
      builder: (context, child) {
        _initManagersOnce();
        return child ?? const SizedBox.shrink();
      },
    );
  }

  /// Initialize managers only once after first build
  void _initManagersOnce() {
    if (_managersInitialized) return;
    _managersInitialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initManagers();
    });
  }

  void _setupStreamSubscriptions() {
    _streamSubscriptions.cancelAll();

    _streamSubscriptions.add(
      _loginEventChannel.listen((event) async {
        if (!mounted) return;

        AppLog.i("✅ Started checking FCM token after ${event.name}");
        _checkAndGetFcmToken();
      }),
    );

    _themeMode = _themeModePreferences.appThemeMode.themeMode;
    _streamSubscriptions.add(
      _appThemeModeChannel.listen((event) {
        if (!mounted) return;

        setState(() => _themeMode = event.themeMode);
      }),
    );

    _streamSubscriptions.add(
      _logoutEventChannel.listen((event) async {
        if (!mounted) return;

        if (event == LogoutEvent.onTokenExpired ||
            event == LogoutEvent.onLogoutFromUI) {
          _handleLogout();
        }
      }),
    );
  }

  /// Initialize notification services
  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initialize(
        onNotificationTapped: (message) {
          AppLog.d("🔔 Notification tapped, handling navigation");
          _navigationHandler.handleNotification(message);
        },
      );
      AppLog.i("✅ Notifications initialized successfully");
    } catch (e, s) {
      AppLog.e("❌ Error initializing notifications: $e", stackTrace: s);
    }
  }

  /// Configure router
  RouterConfig<Object> _configureRouterConfig() {
    return _appRouter.config(
      deepLinkBuilder: (_) => DeepLink(
        _appConfigPreferences.isLanguageNotSelected
            ? [SetLanguageRoute()]
            : _appConfigPreferences.isIntroNotShown
                ? [IntroRoute()]
                : _authPreferences.isNotAuthorized
                    ? [MainRoute()]
                    : [_profilePreferences.userRole.homePage],
      ),
      navigatorObservers: () => [if (kDebugMode) ChuckerFlutter.navigatorObserver],
    );
  }

  /// Configure light theme
  ThemeData _configureLightTheme() {
    return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: false,
      colorScheme: _getLightModeColorScheme(),
    );
  }

  /// Configure dark theme
  ThemeData _configureDarkTheme() {
    return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: false,
      brightness: Brightness.dark,
      colorScheme: _getDarkModeColorScheme(),
    );
  }

  /// Prepare token holder with current tokens
  void _prepareTokenHolder() {
    TemporarilyDataHolder.fcmToken = _fcmTokenPreferences.fcmToken;
    TemporarilyDataHolder.accessToken = _authPreferences.accessToken;
  }

  /// Check and get FCM token
  Future<void> _checkAndGetFcmToken() async {
    try {
      if (_fcmTokenPreferences.isFcmTokenTaken) {
        if (_fcmTokenPreferences.isFcmTokenNotSent) {
          _activateFcmToken();
        }
        return;
      }

      // Force delete token to get fresh one
      await FirebaseMessaging.instance.deleteToken();

      // Get new FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      AppLog.d("📱 FCM token obtained: $fcmToken");

      if (fcmToken != null) {
        _fcmTokenPreferences.setFcmToken(fcmToken);
        TemporarilyDataHolder.fcmToken = fcmToken;
        _activateFcmToken();
      }
    } catch (e, s) {
      AppLog.e("❌ Error getting FCM token: $e", stackTrace: s);
    }
  }

  /// Listen for FCM token refresh
  Future<void> _listenFcmTokenRefreshing() async {
    try {
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
        AppLog.d("🔄 FCM token refreshed: $fcmToken");
        _fcmTokenPreferences.setFcmToken(fcmToken);
        TemporarilyDataHolder.fcmToken = fcmToken;
        _activateFcmToken();
      });
    } catch (e, s) {
      AppLog.e("❌ Error setting up token refresh listener: $e", stackTrace: s);
    }
  }

  /// Handle user logout by deactivating FCM token and clearing session
  Future<void> _handleLogout() async {
    AppLog.i("👋 User logged out, deactivating FCM token");

    _deactivateFcmToken();
    await _sessionRepository.clearBeforeLogout();

    _sessionRepository
        .logout()
        .initFuture()
        .onStart(() {})
        .onSuccess((data) {
          AppLog.d("application logOut success: ${data.message}");
        })
        .onError((error) {
          AppLog.e("application logOut error: $error");
        })
        .onFinished(() {})
        .executeFuture();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appRouter.root.pushAndPopUntil(
        SignInRoute(launchType: SignInLaunchType.launchFromLogout),
        predicate: (_) => false,
      );
    });
  }

  /// Activate FCM token on backend
  void _activateFcmToken() {
    if (_authPreferences.isNotAuthorized) {
      AppLog.d("⚠️ User not authorized, skipping FCM token activation");
      return;
    }

    _notificationRepository
        .activateFcmToken()
        .initFuture()
        .onStart(() => AppLog.d("📤 Activating FCM token..."))
        .onSuccess((data) => AppLog.i("✅ FCM token activated successfully"))
        .onError((error) => AppLog.e("❌ Error activating FCM token: $error"))
        .onFinished(() => AppLog.d("Finished FCM token activation"))
        .executeFuture();
  }

  /// Deactivate FCM token on backend
  void _deactivateFcmToken() {
    _notificationRepository
        .deactivateFcmToken()
        .initFuture()
        .onStart(() => AppLog.d("Deactivating FCM token..."))
        .onSuccess((data) => AppLog.i("FCM token deactivated successfully"))
        .onError((error) => AppLog.e("Error deactivating FCM token: $error"))
        .onFinished(() => AppLog.d("Finished FCM token deactivation"))
        .executeFuture();
  }

  /// Initialize managers using router's navigator context
  void _initManagers() {
    _initStateMessageManager();
    _initNotificationNavigationHandler();
  }

  /// Initialize notification navigation handler
  void _initNotificationNavigationHandler() {
    final context = _appRouter.navigatorKey.currentContext;
    if (context != null) {
      _navigationHandler.initialize(context);
    }
  }

  /// Initialize state message manager
  void _initStateMessageManager() {
    final stateMessageManager = getIt<StateMessageManager>();

    stateMessageManager.setListeners(
      onShowBottomSheet: (m) {
        final context = _appRouter.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          showStateMessageBottomSheet(context, m);
        }
      },
      onShowSnackBar: (m) {
        final context = _appRouter.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          context.showStateMessageSnackBar(m);
        }
      },
      onShowNotAuthorizedBottomSheet: () {
        final context = _appRouter.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          showNotAuthorizedBottomSheet(
            context,
            title: Strings.notAuthorizedTitle,
            message: Strings.notAuthorizedMessage,
            yesTitle: Strings.notAuthorizedActionSignIn,
            onYesClicked: () {
              context.router.replace(SignInRoute(
                launchType: SignInLaunchType.launchFromAction
              ));
            },
            noTitle: Strings.notAuthorizedActionNotNow,
            onNoClicked: () {},
          );
        }
      },
    );
  }

  /// Light mode color scheme
  ColorScheme _getLightModeColorScheme() {
    return ColorScheme.light().copyWith(
      primary: StaticColors.colorPrimary,
      secondary: const Color(0xFFFFFFFF),
      surface: const Color(0xFFF3F3F3),
      onSurface: const Color(0xFF000000),
      surfaceContainer: const Color(0xFFFFFFFF),
      onSurfaceVariant: const Color(0xFF000000),
    );
  }

  /// Dark mode color scheme
  ColorScheme _getDarkModeColorScheme() {
    return ColorScheme.dark().copyWith(
      primary: StaticColors.colorPrimary,
      secondary: const Color(0xFF000000),
      surface: const Color(0xFF333333),
      onSurface: const Color(0xFFE0E0E0),
      surfaceContainer: const Color(0xFF121212),
      onSurfaceVariant: const Color(0xFFE0E0E0),
    );
  }

  /// Show state message bottom sheet
  void showStateMessageBottomSheet(BuildContext context, StateMessage message) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Material(
          child: Container(
            color: context.bottomSheetColor,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                Center(child: message.titleOrDefault.s(22).w(600)),
                const SizedBox(height: 14),
                message.message.s(16).w(500).copyWith(
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                const SizedBox(height: 32),
                MaterialElevatedButton(
                  text: Strings.closeTitle,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(buildContext);
                  },
                  backgroundColor: context.colors.buttonPrimary,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void showNotAuthorizedBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
    required String yesTitle,
    required Function onYesClicked,
    required String noTitle,
    required Function onNoClicked,
  }) {
    showCupertinoModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Material(
        child: Container(
          color: context.bottomSheetColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12),
              BottomSheetTitle(title: title),
              SizedBox(height: 24),
              Center(
                child: message.s(16).copyWith(textAlign: TextAlign.center),
              ),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: MaterialElevatedButton(
                  text: yesTitle,
                  onPressed: () {
                    onYesClicked();
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: MaterialOutlinedButton(
                  text: noTitle,
                  onPressed: () {
                    onNoClicked();
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
              SizedBox(height: defaultBottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
