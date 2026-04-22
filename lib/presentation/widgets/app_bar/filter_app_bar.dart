import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';

class FilterChipItem<T> {
  final T value;
  final String label;

  const FilterChipItem({required this.value, required this.label});
}

class FilterAppBar<T> extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final Color? textColor;
  final Color backgroundColor;
  final List<FilterChipItem<T>> filters;
  final T selectedFilter;
  final ValueChanged<T> onFilterSelected;

  const FilterAppBar({
    super.key,
    required this.titleText,
    this.textColor,
    this.backgroundColor = Colors.transparent,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(appBarHeight + (filters.isEmpty ? 0 : 50));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      systemOverlayStyle: context.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: appBarHeight,
      title: titleText.s(18).w(500).c(textColor ?? context.textPrimary),
      bottom: filters.isEmpty
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = filter.value == selectedFilter;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(filter.label),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? context.isDarkMode
                                ? Color(0xFFFFFFFF)
                                : Color(0xFFFFFFFF)
                            : context.isDarkMode
                                ? Color(0xFFD1D5DB)
                                : Color(0xFF374151),
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      backgroundColor: context.isDarkMode
                          ? Color(0xFF717171)
                          : Color(0xFFF1F1F1),
                      selectedColor: context.isDarkMode
                          ? Color(0xFF3B82F6)
                          : Color(0xFF2563EB),
                      checkmarkColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      onSelected: (_) => onFilterSelected(filter.value),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
