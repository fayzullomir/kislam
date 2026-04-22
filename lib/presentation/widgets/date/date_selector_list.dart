import 'package:koreaislam/core/extensions/date_extensions.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DateSelectorList extends StatefulWidget {
  final DateTime? startDate;
  final DateTime selectedDate;
  final int count;
  final bool isRepeatClick;
  final Function(DateTime) onDateSelected;

  const DateSelectorList({
    Key? key,
    this.startDate,
    required this.selectedDate,
    required this.count,
    required this.onDateSelected,
    this.isRepeatClick = false,
  }) : super(key: key);

  @override
  _DateSelectorListState createState() => _DateSelectorListState();
}

class _DateSelectorListState extends State<DateSelectorList> {
  late List<DateTime> dateList;
  late DateTime selectedDate;
  late bool isRepeatClick;
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolled = false;

  final double itemWidth = 46;
  final double spacing = 8;
  final double listPadding = 16;

  @override
  void initState() {
    super.initState();
    _generateDateList();
    selectedDate = widget.selectedDate;
    isRepeatClick = widget.isRepeatClick;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _generateDateList() {
    dateList = List.generate(
      widget.count,
      (index) {
        return (widget.startDate ?? DateTime.now())
            .subtract(Duration(days: index));
      },
    );
  }

  void _scrollToSelectedDate() {
    if (_hasScrolled || dateList.isEmpty) return;
    try {
      int initialIndex =
          dateList.indexWhere((date) => date.isSameDay(widget.selectedDate));
      if (initialIndex != -1) {
        _scrollToIndex(initialIndex);
        _hasScrolled = true;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  void _scrollToIndex(int index) {
    try {
      double viewportWidth = MediaQuery.of(context).size.width;
      double itemTotalWidth = itemWidth + spacing;
      double centerOffset =
          (index * itemTotalWidth) + (itemWidth / 2) - (viewportWidth / 2);

      _scrollController.animateTo(
        centerOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String language = Localizations.localeOf(context).languageCode;

    return VisibilityDetector(
      key: Key("key_date_selector_list"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0) {
          _hasScrolled = false;
          _scrollToSelectedDate();
        }
      },
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: dateList.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (buildContext, index) {
            var item = dateList[index];
            bool isSelected = item.isSameDay(widget.selectedDate);
            return InkWell(
              onTap: () {
                if (selectedDate.day != item.day || isRepeatClick) {
                  setState(() {
                    selectedDate = item;
                  });
                  widget.onDateSelected(item);
                  HapticFeedback.lightImpact();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 46,
                height: 48,
                decoration: BoxDecoration(
                  color: (!isSelected)
                      ? Color(0xFFFFFFFF).withAlpha((255 * .13).round())
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x21FFFFFF), width: 1),
                  gradient: isSelected ? context.dateListGradient : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DateFormat('EE', language)
                        .format(item)
                        .substring(0, 2)
                        .capitalizedName
                        .s(14)
                        .w(500)
                        .c(isSelected?Colors.white:context.textPrimary),
                    DateFormat('dd')
                        .format(item)
                        .s(14)
                        .w(500)
                        .c(isSelected?Colors.white:context.textPrimary),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(width: 8),
        ),
      ),
    );
  }
}
