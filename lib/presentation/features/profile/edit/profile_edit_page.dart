import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/action/action_list_item.dart';
import 'package:koreaislam/presentation/widgets/app_bar/default_app_bar.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_filled_text_field.dart';
import 'package:koreaislam/presentation/widgets/image/network_circle_image_widget.dart';
import 'package:koreaislam/utils/validator/not_empty_validator.dart';

import 'profile_edit_cubit.dart';

@RoutePage()
class ProfileEditPage
    extends BasePage<ProfileEditCubit, ProfileEditState, ProfileEditEvent> {
  ProfileEditPage({super.key});

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void onEventEmitted(BuildContext context, ProfileEditEvent event) {
    switch (event.type) {
      case OnEditingDataPrepared():
        _firstNameController.text =
            (event.type as OnEditingDataPrepared).firstName;
        _lastNameController.text =
            (event.type as OnEditingDataPrepared).lastName;
        break;
      case OnEditStarted():
        showProgressDialog(context);
        break;
      case OnEditFinished():
        hideProgressBarDialog(context);
        break;
      case OnEditFailed():
        hideProgressBarDialog(context);
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, ProfileEditState state) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: Strings.profileEditTitle,
        backgroundColor: context.appBarColor,
        onBackPressed: () => context.router.maybePop(),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.pageBackgroundColor,
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, ProfileEditState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Form(
        key: _formKey,
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24),
                  _ProfileEditUserImage(
                    state: state,
                    onImageTap: () {
                      if (state.isCompressing) return;
                      HapticFeedback.heavyImpact();
                      _showPhotoPickerBottomSheet(context);
                    },
                  ),
                  SizedBox(height: 24),
                  _buildFirstNameField(state, context),
                  SizedBox(height: 12),
                  _buildLastNameField(state, context),
                  SizedBox(height: 16),
                  MaterialElevatedButton(
                    text: Strings.commonSave,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit(context).updateProfile();
                      }
                    },
                    loading: state.isRequestSending,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameField(ProfileEditState state, BuildContext context) {
    return MaterialFilledTextField(
      hint: Strings.commonFirstName,
      maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      controller: _firstNameController,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) => NotEmptyValidator.validate(value),
      onChanged: (value) {
        cubit(context).setFirstName(value);
      },
    );
  }

  Widget _buildLastNameField(ProfileEditState state, BuildContext context) {
    return MaterialFilledTextField(
      hint: Strings.commonLastName,
      maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      controller: _lastNameController,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) => NotEmptyValidator.validate(value),
      onChanged: (value) {
        cubit(context).setLastName(value);
      },
    );
  }

  void _showPhotoPickerBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Material(
          child: Container(
            decoration: BoxDecoration(
              color: context.bottomSheetColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                BottomSheetTitle(title: Strings.addImageActionTitle),
                SizedBox(height: 16),
                ActionListItem(
                  item: "",
                  title: Strings.addImageActionPickImage,
                  icon: Assets.images.component.profileEditPagePhotoPick,
                  iconTintColor: context.iconPrimary,
                  onClicked: (item) {
                    Navigator.pop(context);
                    cubit(context).pickPhoto();
                  },
                ),
                SizedBox(height: 64),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileEditUserImage extends StatelessWidget {
  const _ProfileEditUserImage({
    required this.state,
    required this.onImageTap,
  });

  final ProfileEditState state;
  final VoidCallback onImageTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 128,
          height: 128,
        ),
        // Show compressing progress indicator
        if (state.isCompressing)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 128,
                height: 128,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colorAccent,
                ),
              ),
            ),
          ),
        // Show current photo from server
        if (state.showCurrentPhoto)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: NetworkCircleImageWidget(
                width: 120,
                height: 120,
                imageUrl: state.profilePhotoUrl,
              ),
            ),
          ),
        // Show selected photo from local file
        if (state.showSelectedPhoto)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.file(
                  File(state.newProfilePhoto!.localFilePath!),
                  fit: BoxFit.cover,
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        // Show placeholder if no photo
        if (state.showPlaceholder)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: context.inputBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.inputStrokeColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Assets.images.component.profileEditPagePlaceHolderCircle
                    .svg(
                  height: 120,
                  width: 120,
                  color: Color(0xFFA3A3A3),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(
                minHeight: 64,
                minWidth: 64,
              ),
              decoration: BoxDecoration(
                color: context.backgroundGreyColor.withOpacity(.3),
                borderRadius: BorderRadius.circular(60),
              ),
              padding: EdgeInsets.all(12),
              child: InkWell(
                onTap: onImageTap,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Assets.images.component.profileEditPagePhotoAdd.svg(
                    width: 24,
                    height: 24,
                    color: Colors.white.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
