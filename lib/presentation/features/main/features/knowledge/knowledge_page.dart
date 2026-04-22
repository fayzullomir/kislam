import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_app_bar.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'knowledge_cubit.dart';

@RoutePage()
class KnowledgePage
    extends BasePage<KnowledgeCubit, KnowledgeState, KnowledgeEvent> {
  const KnowledgePage({super.key});

  @override
  Widget onWidgetBuild(BuildContext context, KnowledgeState state) {
    return _KnowledgeView();
  }
}

class _KnowledgeView extends StatefulWidget {
  const _KnowledgeView();

  @override
  State<_KnowledgeView> createState() => _KnowledgeViewState();
}

class _KnowledgeViewState extends State<_KnowledgeView> {
  String _selectedCategoryId = IslamicMockData.knowledgeCategories.first.id;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<KnowledgeArticleMock> get _filteredArticles {
    final query = _searchController.text.trim().toLowerCase();
    return IslamicMockData.knowledgeArticles.where((article) {
      final matchesCategory = _selectedCategoryId == 'all' ||
          article.categoryId == _selectedCategoryId;
      final matchesQuery = query.isEmpty ||
          article.title.toLowerCase().contains(query) ||
          article.description.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IslamicDesignTokens.background,
      appBar: const IslamicAppBar(title: IslamicMockData.appTitle),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _KnowledgeHeader(),
          const SizedBox(height: 24),
          _CategoryChips(
            selectedId: _selectedCategoryId,
            onSelected: (id) => setState(() => _selectedCategoryId = id),
          ),
          const SizedBox(height: 20),
          _SearchField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          ..._filteredArticles.map(
            (article) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ArticleCard(article: article),
            ),
          ),
          if (_filteredArticles.isEmpty) _EmptyArticles(),
        ],
      ),
    );
  }
}

class _KnowledgeHeader extends StatelessWidget {
  const _KnowledgeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: IslamicDesignTokens.accentPill,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            Strings.knowledgeBase,
            style: const TextStyle(
              color: IslamicDesignTokens.accent,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          Strings.knowledgeHeaderTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: IslamicDesignTokens.primary,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            Strings.knowledgeHeaderDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: IslamicDesignTokens.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final String selectedId;
  final ValueChanged<String> onSelected;

  const _CategoryChips({
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: IslamicMockData.knowledgeCategories.map((category) {
          final isSelected = category.id == selectedId;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Material(
              color: isSelected
                  ? IslamicDesignTokens.primary
                  : IslamicDesignTokens.surfaceMuted,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () => onSelected(category.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Text(
                    category.label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : IslamicDesignTokens.textPrimary,
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IslamicDesignTokens.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: IslamicDesignTokens.textMuted,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                color: IslamicDesignTokens.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: Strings.knowledgeSearchHint,
                hintStyle: const TextStyle(
                  color: IslamicDesignTokens.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final KnowledgeArticleMock article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: IslamicDesignTokens.surface,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: article.iconBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      article.icon,
                      color: IslamicDesignTokens.primary,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    article.categoryLabel,
                    style: const TextStyle(
                      color: IslamicDesignTokens.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                article.title,
                style: const TextStyle(
                  color: IslamicDesignTokens.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.description,
                style: const TextStyle(
                  color: IslamicDesignTokens.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyArticles extends StatelessWidget {
  const _EmptyArticles();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.surface,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: IslamicDesignTokens.textMuted,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            Strings.knowledgeEmptyMessage,
            style: const TextStyle(
              color: IslamicDesignTokens.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
