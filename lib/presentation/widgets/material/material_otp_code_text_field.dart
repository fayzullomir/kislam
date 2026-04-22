import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';

class MaterialOtpCodeTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const MaterialOtpCodeTextField(
      {super.key, required this.controller, required this.onChanged});

  @override
  State<MaterialOtpCodeTextField> createState() => _MaterialOtpCodeTextFieldState();
}

class _MaterialOtpCodeTextFieldState extends State<MaterialOtpCodeTextField> {
  late FocusNode _focusNode;
  int clicked = -1;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Stack(
        children: [
          Row(
            children: List.generate(6, (i) {
              final isFilled = i < text.length;
              final digit = isFilled ? text[i] : null;
              return Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        clicked = clicked == 0 ? 1 : 0;
                        FocusScope.of(context).requestFocus(_focusNode);
                      });
                    },
                    child: TextBox(
                      number: digit,
                      isCurrent: i == text.length,
                      isFilled: i <= text.length - 1,
                    ),
                  ),
                ),
              );
            }),
          ),
          Opacity(
            opacity: 0,
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (_) {
                widget.onChanged(_);
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final String? number;
  final bool isCurrent;
  final bool isFilled;

  const TextBox({
    super.key,
    this.number,
    this.isCurrent = false,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    Color currentBorderColor = StaticColors.colorAccent;
    Color emptyBorderColor = const Color(0xFFCCCCCC);

    var isBoxFill = isCurrent || isFilled;
    return Container(
      height: 56,
      width: 46,
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        color: isBoxFill
            ? currentBorderColor.withValues(alpha: 0.2)
            : emptyBorderColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBoxFill ? currentBorderColor : emptyBorderColor,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        number ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white, // Basic100
        ),
      ),
    );
  }
}
