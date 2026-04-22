import 'dart:ui';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateCalendarDialog extends StatefulWidget {
  final DateTime focusedDay;
  final Function(DateTime) onSelectedDay;


  const DateCalendarDialog({super.key, required this.onSelectedDay, required this.focusedDay});
  @override
  _DateCalendarState createState() => _DateCalendarState();
}

class _DateCalendarState extends State<DateCalendarDialog> {
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: MaterialCard(
            borderRadius: BorderRadius.circular(14),
          color: isDark?Color(0xFF28352F):Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TableCalendar(
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    titleTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    )
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      gradient: context.dateListGradient,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),

                    ),
                    selectedDecoration: BoxDecoration(
                      gradient: context.dateListGradient,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    todayTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha:0.54)
                    ),
                    selectedTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha:0.54)
                    )
                  ),
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: widget.focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                    });
                    widget.onSelectedDay(selected);
                  },
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Месяц'
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
