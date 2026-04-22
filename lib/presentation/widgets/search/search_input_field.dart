import 'dart:async';

import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class SearchInputField extends StatefulWidget {
  final String? initialQuery;
  final String hintText;
  final Function(String? query) onQueryChanged;
  final double? height;
  final EdgeInsetsGeometry? margin;

  const SearchInputField({
    super.key,
    this.initialQuery,
    required this.hintText,
    required this.onQueryChanged,
    this.height,
    this.margin,
  });

  @override
  _SearchInputFieldState createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  final _controller = TextEditingController();
  Timer? _debounceTimer;
  bool _showClearIcon = false; // Track whether to show clear icon

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateClearIconVisibility);
    _controller.text = widget.initialQuery ?? '';
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_updateClearIconVisibility);
    _controller.dispose();
    super.dispose();
  }

  void _updateClearIconVisibility() {
    setState(() {
      _showClearIcon = _controller.text.isNotEmpty;
    });
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      if (mounted) widget.onQueryChanged(query);
    });
  }

  void _clearText() {
    _controller.clear();
    _onSearchChanged('');
    setState(() {
      _showClearIcon = false; // Hide clear icon after clearing text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.margin,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: context.textPrimaryInverse.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Assets.images.component.searchBar
              .svg(width: 16, height: 16, color: context.textHint),
          SizedBox(width: 6),
          Expanded(
            child: TextField(
              autofocus: false,
              controller: _controller,
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                _onSearchChanged(value);
                FocusScope.of(context).unfocus(); // Dismiss keyboard
              },
              textInputAction: TextInputAction.search,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: context.inputTextColor,
                fontSize: 14,
              ),
              decoration: InputDecoration.collapsed(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: context.textHint,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          _showClearIcon
              ? Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _clearText,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Assets.images.component.inputClear.svg(),
                      ),
                    ),
                  ),
                )
              : SizedBox(width: 24, height: 24),
        ],
      ),
    );
  }
}
