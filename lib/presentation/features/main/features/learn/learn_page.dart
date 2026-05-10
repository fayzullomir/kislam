import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'learn_cubit.dart';

@RoutePage()
class LearnPage extends BasePage<LearnCubit, LearnState, LearnEvent> {
  const LearnPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, LearnState state) {
    final filtered = _filterQuestions(
      IslamicMockData.learnQuestions,
      state.selectedCategoryId,
      state.searchQuery,
    );

    return Scaffold(
      backgroundColor: IslamicDesignTokens.neutral,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              children: [
                Text(Strings.learnQaLabel,
                    style: IslamicDesignTokens.tEyebrow),
                const SizedBox(height: 6),
                Text(Strings.learnTitle,
                    style: IslamicDesignTokens.tDisplay),
                const SizedBox(height: 18),
                _SearchField(
                  initialValue: state.searchQuery,
                  onChanged: (v) => cubit(context).updateSearchQuery(v),
                ),
                const SizedBox(height: 16),
                _CategoryChipsRow(
                  selectedId: state.selectedCategoryId,
                  onSelected: (id) => cubit(context).selectCategory(id),
                ),
                const SizedBox(height: 8),
                if (filtered.isEmpty)
                  const _EmptyState()
                else
                  ...List.generate(filtered.length, (i) {
                    final isLast = i == filtered.length - 1;
                    return Column(
                      children: [
                        _QuestionTile(question: filtered[i]),
                        if (!isLast)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: IslamicDesignTokens.line,
                          ),
                      ],
                    );
                  }),
              ],
            ),
            // Floating "Ask a question" pill — bottom-right.
            Positioned(
              right: 20,
              bottom: 20,
              child: _AskQuestionFab(onTap: () {
                // TODO(phase-5): open Ask a question composer.
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<LearnQuestionMock> _filterQuestions(
    List<LearnQuestionMock> source,
    String categoryId,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    return source.where((item) {
      final byCategory =
          categoryId == 'all' || item.categoryId == categoryId;
      final bySearch = q.isEmpty || item.title.toLowerCase().contains(q);
      return byCategory && bySearch;
    }).toList();
  }
}

// ---------------------------------------------------------------------------
// Search field — white background, hairline border, leading magnifying glass.
// ---------------------------------------------------------------------------

class _SearchField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.initialValue, required this.onChanged});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IslamicDesignTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: IslamicDesignTokens.line, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: IslamicDesignTokens.inkSoft,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: IslamicDesignTokens.tBody,
              decoration: InputDecoration(
                hintText: Strings.learnSearchHint,
                hintStyle: const TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: IslamicDesignTokens.inkSoft,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Horizontal scrolling category chips. Selected one is filled green.
// ---------------------------------------------------------------------------

class _CategoryChipsRow extends StatelessWidget {
  final String selectedId;
  final ValueChanged<String> onSelected;

  const _CategoryChipsRow({
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: IslamicMockData.learnCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = IslamicMockData.learnCategories[i];
          final isSelected = cat.id == selectedId;
          return _CategoryChip(
            label: cat.label,
            isSelected: isSelected,
            onTap: () => onSelected(cat.id),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected
        ? IslamicDesignTokens.primary
        : Colors.transparent;
    final fg = isSelected ? Colors.white : IslamicDesignTokens.ink;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(IslamicDesignTokens.radiusPill),
            border: Border.all(
              color: isSelected
                  ? IslamicDesignTokens.primary
                  : IslamicDesignTokens.line,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Question tile — divider-separated rows with category chip + optional
// "NEW ANSWER" pill, the question itself, and an "answers →" link.
// ---------------------------------------------------------------------------

class _QuestionTile extends StatelessWidget {
  final LearnQuestionMock question;

  const _QuestionTile({required this.question});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO(phase-5): push question detail.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CategoryBadge(label: question.categoryLabel),
                if (question.isNewAnswer) ...[
                  const SizedBox(width: 8),
                  const _NewAnswerBadge(),
                ],
                const Spacer(),
                Text(
                  question.timestamp,
                  style: IslamicDesignTokens.tCaption,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              question.title,
              style: const TextStyle(
                fontFamily: IslamicDesignTokens.fontDisplay,
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: IslamicDesignTokens.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${Strings.learnAnswersCount('${question.answersCount}')} →',
              style: const TextStyle(
                fontFamily: IslamicDesignTokens.fontBody,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IslamicDesignTokens.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;

  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.neutralSage,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: IslamicDesignTokens.fontBody,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: IslamicDesignTokens.inkMuted,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _NewAnswerBadge extends StatelessWidget {
  const _NewAnswerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.danger.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        Strings.learnNewAnswerBadge,
        style: const TextStyle(
          fontFamily: IslamicDesignTokens.fontBody,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: IslamicDesignTokens.danger,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Floating "+ Ask a question" pill.
// ---------------------------------------------------------------------------

class _AskQuestionFab extends StatelessWidget {
  final VoidCallback onTap;

  const _AskQuestionFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: IslamicDesignTokens.ink,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(IslamicDesignTokens.radiusPill),
            boxShadow: [
              BoxShadow(
                color: IslamicDesignTokens.ink.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                Strings.learnAskQuestion,
                style: const TextStyle(
                  fontFamily: IslamicDesignTokens.fontDisplay,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: IslamicDesignTokens.inkSoft,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            Strings.learnEmpty,
            style: IslamicDesignTokens.tBodySm,
          ),
        ],
      ),
    );
  }
}
