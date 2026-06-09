import 'dart:io';

import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/permission/permission_page_data.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'permissions_cubit.freezed.dart';
part 'permissions_state.dart';

@Injectable()
class PermissionsCubit extends BaseCubit<PermissionsState, PermissionsEvent> {
  PermissionsCubit() : super(PermissionsState());

  void setPageIndex(int pageIndex) {
    updateState((state) => state.copyWith(currentPageIndex: pageIndex));
  }

  /// Manufacturers that ship an aggressive OEM "autostart" manager which
  /// kills background apps after reboot, so the dedicated autostart screen
  /// is genuinely useful (this matches the screen copy: "Xiaomi, Huawei,
  /// Oppo и подобных"). Samsung and Realme are deliberately excluded — the
  /// plugin reports them as "available", but their intent only opens the
  /// battery settings page, which the separate battery step already covers.
  static const _autoStartBrands = {
    'xiaomi',
    'redmi',
    'poco',
    'huawei',
    'honor',
    'oppo',
    'vivo',
    'oneplus',
    'meizu',
    'asus',
    'letv',
    'infinix',
    'tecno',
    'itel',
    'nokia',
    'lenovo',
    'zte',
    'nubia',
    'htc',
  };

  /// Resolves whether the autostart onboarding step should be shown. It is
  /// shown only when the device is one of the aggressive OEM brands
  /// ([_autoStartBrands]) AND the OEM's autostart settings page actually
  /// resolves. On stock Android, Samsung, and unsupported brands the step
  /// is skipped so users never see an irrelevant / dead-end screen.
  /// Runs once when the page is created.
  Future<void> checkAutoStartAvailability() async {
    if (!Platform.isAndroid) return;
    try {
      final available = await isAutoStartAvailable;
      final manufacturer =
          (await getDeviceManufacturer())?.toLowerCase().trim();
      final shouldShow =
          available == true && _autoStartBrands.contains(manufacturer);
      updateState(
        (state) => state.copyWith(isAutoStartAvailable: shouldShow),
      );
    } catch (e, s) {
      AppLog.e('❌ checkAutoStartAvailability failed', error: e, stackTrace: s);
    }
  }

  /// Skips the current step without running its action (used by the
  /// optional autostart screen) and moves on in the flow.
  void skip() {
    _emitNavigation(states.isLastPermissionShown);
  }

  Future<void> tryRequestPermission() async {
    final data = states.currentPermission;
    final isLastPermission = states.isLastPermissionShown;

    // Steps without a [Permission] (e.g. the OEM autostart screen) run a
    // custom side-effect and immediately move on — there's no granted /
    // denied state to inspect because Android doesn't expose one.
    if (data.permission == null) {
      await data.customAction?.call();
      _emitNavigation(isLastPermission);
      return;
    }

    final permission = data.permission!;
    final status = await permission.status;

    if (status.isPermanentlyDenied) {
      emitEvent(PermissionsEvent(PermissionsEventType.onOpenSystemSettings));
      return;
    }

    if (!status.isGranted) {
      await permission.request();
    }

    _emitNavigation(isLastPermission);
  }

  void _emitNavigation(bool isLastPermission) {
    if (isLastPermission) {
      emitEvent(PermissionsEvent(PermissionsEventType.onOpenLoginPage));
    } else {
      emitEvent(PermissionsEvent(PermissionsEventType.onOpenNextPermission));
    }
  }
}
