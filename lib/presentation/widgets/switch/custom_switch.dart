import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSwitch extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  CustomSwitch({required this.isChecked, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    var switchColor = widget.isChecked ? Color(0xFF5C6AC4) : Color(0xFFAEB2CD);

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isChecked);
        HapticFeedback.selectionClick();
      },
      child: Container(
        width: 55,
        height: 31,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: switchColor.withAlpha(30),
          border: Border.all(
            width: 2,
            color: switchColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          // Space between the thumb and the track
          child: AnimatedAlign(
            alignment:
                widget.isChecked ? Alignment.centerRight : Alignment.centerLeft,
            duration: Duration(milliseconds: 180),
            curve: Curves.easeIn,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: switchColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
