import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final double size;

  const MaterialIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = 42,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      borderRadius: BorderRadius.circular(64),
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(64),
        ),
        child: icon,
      ),
    );
  }
}
