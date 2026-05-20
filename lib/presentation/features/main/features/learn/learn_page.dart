import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/terms_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/learn/term_detail_sheet.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'learn_cubit.dart';

@RoutePage()
class LearnPage extends BasePage<LearnCubit, LearnState, LearnEvent> {
  const LearnPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, LearnState state) {
    return Scaffold(
      backgroundColor: context.noor.neutral,
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
                Text(Strings.learnQaLabel, style: context.noor.tEyebrow),
                const SizedBox(height: 6),
                Text(Strings.learnTitle, style: context.noor.tDisplay),
                const SizedBox(height: 14),
                _TabSwitcher(
                  tab: state.tab,
                  onChanged: (t) => cubit(context).selectTab(t),
                ),
                const SizedBox(height: 14),
                if (state.tab == LearnTab.questions)
                  _QuestionsView(
                    state: state,
                    onCategoryTap: (id) =>
                        cubit(context).selectCategory(id),
                    onSearchChanged: (q) =>
                        cubit(context).updateSearchQuery(q),
                  )
                else
                  _TermsView(
                    selected: state.termCategory,
                    onCategoryTap: (c) =>
                        cubit(context).selectTermCategory(c),
                  ),
              ],
            ),
            if (state.tab == LearnTab.questions)
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
}

// ---------------------------------------------------------------------------
// Tab switcher — pill segmented control between Q&A and Atamalar.
// ---------------------------------------------------------------------------

class _TabSwitcher extends StatelessWidget {
  final LearnTab tab;
  final ValueChanged<LearnTab> onChanged;

  const _TabSwitcher({required this.tab, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final entries = [
      (LearnTab.questions, Strings.learnTabQuestions),
      (LearnTab.terms, Strings.learnTabTerms),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: n.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: n.line, width: 0.5),
      ),
      child: Row(
        children: [
          for (final entry in entries)
            Expanded(
              child: _TabButton(
                label: entry.$2,
                selected: tab == entry.$1,
                onTap: () => onChanged(entry.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: selected ? n.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              color: selected ? Colors.white : n.inkMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Q&A view — search + category chips + question tiles. Mostly preserved
// from the previous implementation, repacked into a single widget.
// ---------------------------------------------------------------------------

class _QuestionsView extends StatelessWidget {
  final LearnState state;
  final ValueChanged<String> onCategoryTap;
  final ValueChanged<String> onSearchChanged;

  const _QuestionsView({
    required this.state,
    required this.onCategoryTap,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = _filterQuestions(
      IslamicMockData.learnQuestions,
      state.selectedCategoryId,
      state.searchQuery,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SearchField(
          initialValue: state.searchQuery,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 16),
        _CategoryChipsRow(
          selectedId: state.selectedCategoryId,
          onSelected: onCategoryTap,
        ),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          const _EmptyState()
        else
          for (int i = 0; i < filtered.length; i++)
            Column(
              children: [
                _QuestionTile(question: filtered[i]),
                if (i < filtered.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: context.noor.line,
                  ),
              ],
            ),
      ],
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
        color: context.noor.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.noor.line, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: context.noor.inkSoft,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: context.noor.tBody,
              decoration: InputDecoration(
                hintText: Strings.learnSearchHint,
                hintStyle: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: context.noor.inkSoft,
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
          return _ChipButton(
            label: cat.label,
            isSelected: isSelected,
            onTap: () => onSelected(cat.id),
          );
        },
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChipButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? context.noor.primary : Colors.transparent;
    final fg = isSelected ? Colors.white : context.noor.ink;
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
              color: isSelected ? context.noor.primary : context.noor.line,
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
                  style: context.noor.tCaption,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              question.title,
              style: TextStyle(
                fontFamily: IslamicDesignTokens.fontDisplay,
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: context.noor.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${Strings.learnAnswersCount('${question.answersCount}')} →',
              style: TextStyle(
                fontFamily: IslamicDesignTokens.fontBody,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.noor.primary,
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
        color: context.noor.neutralSage,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: IslamicDesignTokens.fontBody,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: context.noor.inkMuted,
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
        color: context.noor.danger.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        Strings.learnNewAnswerBadge,
        style: TextStyle(
          fontFamily: IslamicDesignTokens.fontBody,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: context.noor.danger,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _AskQuestionFab extends StatelessWidget {
  final VoidCallback onTap;

  const _AskQuestionFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.noor.ink,
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
                color: context.noor.ink.withOpacity(0.18),
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
          Icon(
            Icons.search_off_rounded,
            color: context.noor.inkSoft,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            Strings.learnEmpty,
            style: context.noor.tBodySm,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Atamalar view — category filter chips + tap-through term list.
// ---------------------------------------------------------------------------

class _TermsView extends StatelessWidget {
  final TermCategory selected;
  final ValueChanged<TermCategory> onCategoryTap;

  const _TermsView({required this.selected, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final localeCode = context.locale.languageCode;
    final filtered = selected == TermCategory.all
        ? TermsMockData.all
        : TermsMockData.all
            .where((t) => t.category == selected)
            .toList();
    final n = context.noor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: TermsMockData.filterOrder.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = TermsMockData.filterOrder[i];
              return _TermCategoryChip(
                label: _categoryLabel(cat),
                isSelected: cat == selected,
                onTap: () => onCategoryTap(cat),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < filtered.length; i++) ...[
          _TermRow(
            term: filtered[i],
            localeCode: localeCode,
            onTap: () => showTermDetailSheet(context, termId: filtered[i].id),
          ),
          if (i < filtered.length - 1)
            Divider(height: 1, thickness: 0.5, color: n.line),
        ],
      ],
    );
  }
}

class _TermCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TermCategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final bg = isSelected ? n.primary : Colors.transparent;
    final fg = isSelected ? Colors.white : n.inkMuted;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(IslamicDesignTokens.radiusPill),
            border: Border.all(
              color: isSelected ? n.primary : n.line,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              color: fg,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _TermRow extends StatelessWidget {
  final TermMock term;
  final String localeCode;
  final VoidCallback onTap;

  const _TermRow({
    required this.term,
    required this.localeCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final localized = term.localized(localeCode);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: n.primaryWash,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: n.secondary.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                term.arabic,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontArabic,
                  color: n.primary,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localized.name,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      color: n.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    localized.short,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontBody,
                      color: n.inkSoft,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: n.inkSoft,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

String _categoryLabel(TermCategory category) {
  switch (category) {
    case TermCategory.all:
      return Strings.termCategoryAll;
    case TermCategory.fiqh:
      return Strings.termCategoryFiqh;
    case TermCategory.ibodat:
      return Strings.termCategoryIbodat;
  }
}
