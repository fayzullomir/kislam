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
