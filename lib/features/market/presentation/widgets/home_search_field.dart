import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/core/theme/app_palette.dart';
import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';
import 'package:market_app/features/market/presentation/widgets/business_cards.dart';

sealed class SearchSuggestion {
  const SearchSuggestion();
}

class BusinessSuggestion extends SearchSuggestion {
  const BusinessSuggestion(this.business);
  final Business business;
}

class CategorySuggestion extends SearchSuggestion {
  const CategorySuggestion(this.category);
  final MarketCategory category;
}

/// Search field with real-time suggestions and autocomplete.
class HomeSearchField extends StatefulWidget {
  const HomeSearchField({super.key});

  @override
  State<HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends State<HomeSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<SearchSuggestion> _computeSuggestions(
    String query,
    MarketState state,
  ) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return const [];

    final suggestions = <SearchSuggestion>[];

    // 1. Categories matching the query
    for (final category in state.categories) {
      if (category.name != 'Otros' &&
          category.nameEs.toLowerCase().contains(clean)) {
        suggestions.add(CategorySuggestion(category));
        if (suggestions.length >= 2) break;
      }
    }

    // 2. Businesses matching the query
    for (final business in state.businesses) {
      final matchesName = business.name.toLowerCase().contains(clean);
      final matchesDesc =
          business.description?.toLowerCase().contains(clean) ?? false;
      final matchesAddr = business.address.toLowerCase().contains(clean);

      if (matchesName || matchesDesc || matchesAddr) {
        suggestions.add(BusinessSuggestion(business));
        if (suggestions.length >= 6) break;
      }
    }

    return suggestions;
  }

  void _selectSuggestion(SearchSuggestion suggestion) {
    final cubit = context.read<MarketCubit>();
    switch (suggestion) {
      case BusinessSuggestion(:final business):
        _controller.text = business.name;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: business.name.length),
        );
        cubit.search(business.name);
      case CategorySuggestion(:final category):
        _controller.text = category.nameEs;
        cubit.selectCategory(category.id);
        cubit.search('');
    }
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarketCubit>().state;
    final location = state.locationLabel;
    final hint = location.isNotEmpty
        ? '¿Qué buscas hoy en $location?'
        : '¿Qué buscas hoy?';
    final palette = context.palette;

    final query = _controller.text;
    final showSuggestions = _focusNode.hasFocus && query.trim().isNotEmpty;
    final suggestions =
        showSuggestions ? _computeSuggestions(query, state) : const <SearchSuggestion>[];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (text) {
              context.read<MarketCubit>().search(text);
              setState(() {});
            },
            onSubmitted: (_) => _focusNode.unfocus(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: palette.textTertiary),
              prefixIcon: Icon(Icons.search, color: palette.textPrimary),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      tooltip: 'Borrar búsqueda',
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: palette.textSecondary,
                      onPressed: () {
                        _controller.clear();
                        context.read<MarketCubit>().search('');
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: palette.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: palette.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: palette.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(
                  color: AppColors.purple,
                  width: 1.5,
                ),
              ),
            ),
          ),
          if (showSuggestions && suggestions.isNotEmpty)
            _SuggestionsBox(
              suggestions: suggestions,
              onSelect: _selectSuggestion,
              onOpenProfile: (b) {
                _focusNode.unfocus();
                openBusinessProfile(context, b.id);
              },
            ),
        ],
      ),
    );
  }
}

class _SuggestionsBox extends StatelessWidget {
  const _SuggestionsBox({
    required this.suggestions,
    required this.onSelect,
    required this.onOpenProfile,
  });

  final List<SearchSuggestion> suggestions;
  final ValueChanged<SearchSuggestion> onSelect;
  final ValueChanged<Business> onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: AppColors.purple,
                ),
                const SizedBox(width: 6),
                Text(
                  'Sugerencias',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: palette.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          for (var i = 0; i < suggestions.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 56),
            _SuggestionRow(
              suggestion: suggestions[i],
              onTap: () => onSelect(suggestions[i]),
              onOpenProfile: onOpenProfile,
            ),
          ],
        ],
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({
    required this.suggestion,
    required this.onTap,
    required this.onOpenProfile,
  });

  final SearchSuggestion suggestion;
  final VoidCallback onTap;
  final ValueChanged<Business> onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            switch (suggestion) {
              BusinessSuggestion(:final business) => _BusinessAvatar(
                  business: business,
                ),
              CategorySuggestion() => Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: palette.purpleSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.category_rounded,
                    size: 18,
                    color: AppColors.purple,
                  ),
                ),
            },
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    switch (suggestion) {
                      BusinessSuggestion(:final business) => business.name,
                      CategorySuggestion(:final category) =>
                        category.nameEs,
                    },
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    switch (suggestion) {
                      BusinessSuggestion(:final business) =>
                        business.address.isNotEmpty
                            ? business.address
                            : 'Negocio local',
                      CategorySuggestion() => 'Categoría',
                    },
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            switch (suggestion) {
              BusinessSuggestion(:final business) => IconButton(
                  tooltip: 'Ver negocio',
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  color: palette.textSecondary,
                  onPressed: () => onOpenProfile(business),
                ),
              CategorySuggestion() => Icon(
                  Icons.north_west_rounded,
                  size: 16,
                  color: palette.textTertiary,
                ),
            },
          ],
        ),
      ),
    );
  }
}

class _BusinessAvatar extends StatelessWidget {
  const _BusinessAvatar({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final cover = business.coverUrl;
    final palette = context.palette;

    if (cover != null && cover.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          cover,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(palette),
        ),
      );
    }
    return _fallback(palette);
  }

  Widget _fallback(AppPalette palette) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: palette.mutedFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.storefront_rounded,
        size: 18,
        color: palette.textSecondary,
      ),
    );
  }
}

