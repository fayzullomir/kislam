import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class MaterialFilledTextField extends StatefulWidget {
  final double? height;

  final bool floatingLabel;
  final String? hint;

  final Iterable<String>? autofillHints;
  final bool? enableSuggestions;

  final TextInputType? inputType;
  final TextInputType? keyboardType;

  final TextEditingController? controller;
  final bool obscureText;
  final bool clearText;
  final bool readOnly;
  final bool enabled;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String? prefixText;

  final TextCapitalization? textCapitalization;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  final Function(String text)? onChanged;
  final AutovalidateMode? autoValidateMode;
  final String? Function(String? text)? validator;

  final Widget? leftIcon;
  final Widget? rightIcon;

  final FocusNode? focusNode;

  final TextDirection? textDirection;

  const MaterialFilledTextField({
    Key? key,
    this.height = 64,
    this.floatingLabel = true,
    this.hint,
    this.autofillHints,
    this.enableSuggestions,
    this.inputType,
    this.keyboardType,
    this.controller,
    this.obscureText = false,
    this.clearText = false,
    this.readOnly = false,
    this.enabled = true,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.autoValidateMode,
    this.validator,
    this.leftIcon,
    this.rightIcon,
    this.focusNode,
    this.prefixText,
    this.textDirection,
  }) : super(key: key);

  @override
  State<MaterialFilledTextField> createState() => _MaterialFilledTextFieldState();
}

class _MaterialFilledTextFieldState extends State<MaterialFilledTextField> {
  late FocusNode _focusNode;
  bool _passwordVisible = false;
  String? _errorText;
  int _currentLength = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _passwordVisible = widget.obscureText;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() => _currentLength = _controller.text.length);
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextDirection =
        widget.textDirection ?? Directionality.of(context);
    final isRtl = effectiveTextDirection == TextDirection.rtl;

    return Directionality(
      textDirection: effectiveTextDirection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ListenableBuilder - faqat border'ni rebuild qiladi, setState chaqirmaydi
          ListenableBuilder(
            listenable: _focusNode,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.only(left: 4, right: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.inputBackgroundColor,
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? context.inputStrokeActiveColor
                        : context.inputStrokeColor,
                    width: _focusNode.hasFocus ? 1.5 : 0.5,
                  ),
                ),
                height: widget.height,
                child: child,
              );
            },
            child: Center(
              child: TextFormField(
                autofocus: false,
                focusNode: _focusNode,
                validator: (value) {
                  if (widget.validator != null) {
                    final error = widget.validator!(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _errorText != error) {
                        setState(() => _errorText = error);
                      }
                    });
                    return error;
                  }
                  return null;
                },
                autofillHints: widget.autofillHints,
                autovalidateMode: widget.autoValidateMode,
                onChanged: widget.onChanged,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                controller: _controller,
                keyboardType: widget.keyboardType,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                readOnly: widget.readOnly,
                enabled: widget.enabled,
                enableSuggestions: widget.enableSuggestions ?? true,
                textInputAction: widget.textInputAction,
                inputFormatters: widget.inputFormatters,
                cursorColor: StaticColors.colorAccent,
                textCapitalization:
                    widget.textCapitalization ?? TextCapitalization.none,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(height: 0.01, fontSize: 0.001),
                  hintText: widget.floatingLabel ? null : widget.hint,
                  fillColor: Colors.transparent,
                  prefixText: widget.prefixText,
                  prefixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: context.textSecondary,
                  ),
                  filled: true,
                  labelText: widget.floatingLabel ? widget.hint : null,
                  labelStyle: const TextStyle(color: Color(0xFF848282)),
                  prefixIcon: isRtl ? _buildSuffixIcon() : _buildPrefixIcon(),
                  suffixIcon: isRtl ? _buildPrefixIcon() : _buildSuffixIcon(),
                  border: InputBorder.none,
                ),
                obscureText: _passwordVisible,
                buildCounter: (
                  _, {
                  required currentLength,
                  maxLength,
                  required isFocused,
                }) =>
                    null,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildValidationError() ?? const Spacer(),
              if (widget.maxLength != null) ..._buildCounterText(context),
            ],
          )
        ],
      ),
    );
  }

  Widget? _buildValidationError() {
    if (_errorText == null || _errorText!.isEmpty) return null;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 2, right: 12),
        child: _errorText!.s(10).c(Colors.red).copyWith(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  List<Widget> _buildCounterText(BuildContext context) {
    return [
      SizedBox(width: 2),
      "$_currentLength/${widget.maxLength}".s(12).c(context.textPrimary).w(400),
      const SizedBox(width: 12),
    ];
  }

  Widget? _buildPrefixIcon() {
    if (widget.leftIcon == null) return null;
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 3, bottom: 10, left: 3),
      child: widget.leftIcon,
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return InkWell(
        onTap: () => setState(() => _passwordVisible = !_passwordVisible),
        child: Icon(
          _passwordVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: const Color(0xFFB4B1B1),
        ),
      );
    }
    if (widget.clearText) {
      return InkWell(
        onTap: () {
          _controller.clear();
          setState(() => _errorText = null);
        },
        child: const Icon(Icons.clear, color: Color(0xFFB4B1B1)),
      );
    }
    if (widget.rightIcon == null) return null;
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 3, right: 3),
      child: widget.rightIcon,
    );
  }
}
