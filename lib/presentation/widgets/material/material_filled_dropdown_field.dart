import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class MaterialFilledDropdownField extends StatelessWidget {
  final double height;
  final String value;
  final String hint;
  final Function() onTap;
  final AutovalidateMode? autoValidateMode;
  final String? Function(String? text)? validator;

  MaterialFilledDropdownField({
    super.key,
    this.height = 50,
    this.value = "",
    required this.hint,
    required this.onTap,
    this.autoValidateMode,
    this.validator,
  });

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    controller.text = value;
    return FormField<String>(
      autovalidateMode: autoValidateMode,
      initialValue: value,
      validator: (v) {
        return validator != null ? validator!(value) : null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: isRtl ? 0 : 16,
                right: isRtl ? 16 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: context.inputBackgroundColor,
                border: Border.all(
                  color: context.inputStrokeColor,
                  width: context.isDarkMode ? 0.8 : 0.8,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              height: 64,
              child: InkWell(
                onTap: () => onTap(),
                child: Center(
                  child: TextFormField(
                    controller: controller,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    autovalidateMode: autoValidateMode,
                    onTap: () {
                      // cubit(context).updatePage();
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                    // maxLength: widget.maxLength,
                    readOnly: true,
                    enabled: false,
                    enableSuggestions: true,
                    cursorColor: StaticColors.colorPrimary,
                    decoration: InputDecoration(
                      hintText: hint,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                      labelText: hint,
                      labelStyle: TextStyle(
                        color: Color(0xFF848282),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      isDense: false,
                      prefixStyle: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIconColor:
                          Theme.of(context).colorScheme.onSecondary,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Assets.images.materialFilledDropdownFieldDropdown
                            .svg(),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4, right: 12),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
