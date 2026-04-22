import 'dart:ui';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:flutter/material.dart';


class HourSelectorDialog extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(DateTime) onTimeSelected;
  final bool isAddBg;

  const HourSelectorDialog({
    super.key,
    required this.initialDateTime,
    required this.onTimeSelected,
    this.isAddBg = false,
  });

  @override
  State<HourSelectorDialog> createState() => _HourSelectorDialogState();
}

class _HourSelectorDialogState extends State<HourSelectorDialog> {
  late int selectedHour;
  late int selectedMinute;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialDateTime.hour;
    selectedMinute = widget.initialDateTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: widget.isAddBg ? const Color(0xFF28352F) : Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: MaterialCard(
        color: isDark?Color(0xFF28352F):Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Strings.calendarSelectTime.s(16).w(600).c(context.textPrimary),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPicker(
                    context,
                    label: Strings.calendarHours,
                    value: selectedHour,
                    max: 23,
                    onChanged: (val) => setState(() => selectedHour = val),
                  ),
                   SizedBox(width: 16),
                  _buildPicker(
                    context,
                    label: Strings.calendarMinutes,
                    value: selectedMinute,
                    max: 59,
                    onChanged: (val) => setState(() => selectedMinute = val),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              MaterialElevatedButton(
                onPressed: () {
                  final result = DateTime(
                    widget.initialDateTime.year,
                    widget.initialDateTime.month,
                    widget.initialDateTime.day,
                    selectedHour,
                    selectedMinute,
                  );
                  widget.onTimeSelected(result);
                  Navigator.pop(context);
                },
                text: Strings.commonSelect,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPicker(BuildContext context,{
    required String label,
    required int value,
    required int max,
    required void Function(int) onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style:  TextStyle(color: context.textPrimary, fontSize: 14),
        ),
        SizedBox(
          height: 120,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(initialItem: value),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style:  TextStyle(color: context.textPrimary, fontSize: 20,fontWeight: FontWeight.w700),
                ),
              ),
              childCount: max + 1,
            ),
          ),
        ),
      ],
    );
  }
}
