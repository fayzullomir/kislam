import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
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
    Permission permission = states.currentPermission.permission;

    final status = await permission.status;
    final isLastPermission = states.isLastPermissionShown;

    if (status.isPermanentlyDenied) {
      emitEvent(PermissionsEvent(PermissionsEventType.onOpenSystemSettings));
      return;
    }

    if (!status.isGranted) {
      await permission.request();
    }

    if (isLastPermission) {
      emitEvent(PermissionsEvent(PermissionsEventType.onOpenLoginPage));
    } else {
      emitEvent(PermissionsEvent(PermissionsEventType.onOpenNextPermission));
    }
  }
}
