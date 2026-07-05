import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/protocol/tier_aware_page.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_providers.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';
import 'package:kuttiomp_mobile/features/search/presentation/search_result_card.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/clan_bound_view.dart';
import 'package:kuttiomp_mobile/shared/widgets/living_authority_decorator.dart';
import 'package:kuttiomp_mobile/shared/widgets/mode_tier_guard.dart';
import 'package:kuttiomp_mobile/shared/widgets/sacred_content_locker_widget.dart';

/// Gated global discovery shell with full protocol guard stack (§4, Protocols 1–9).
class SearchPage extends TierAwarePage {
  const SearchPage({super.key}) : super(requiredTier: GenerationalTierBitmask.allTiers);

  @override
  Widget buildTierContent(BuildContext context) {
    return const _SearchDiscoverScaffold();
  }
}

class _SearchDiscoverScaffold extends ConsumerStatefulWidget {
  const _SearchDiscoverScaffold();

  @override
  ConsumerState<_SearchDiscoverScaffold> createState() => _SearchDiscoverScaffoldState();
}

class _SearchDiscoverScaffoldState extends ConsumerState<_SearchDiscoverScaffold> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleType(SearchContentType type) {
    final filter = ref.read(searchFilterProvider);
    final types = Set<SearchContentType>.from(filter.contentTypes);
    if (types.contains(type)) {
      if (types.length > 1) types.remove(type);
    } else {
      types.add(type);
    }
    ref.read(searchFilterProvider.notifier).state = SearchFilter(
      mode: filter.mode,
      canonicalStage: filter.canonicalStage,
      landGeometry: filter.landGeometry,
      contentTypes: types,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
    final filter = ref.watch(searchFilterProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final service = ref.watch(searchServiceProvider);
    final ext = KuttiompThemeExtension.of(context);

    final gateContext = {
      'elderApproved': true,
      'speaker_id': 'system-search',
      'attribution_json': {'speaker_id': 'system-search'},
      'visible_to_tiers': mode.tierBitmask,
      'fontSize': mode.minimumFontSize,
      'hasSemanticsLabel': true,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Language', style: ext.elderTitle.copyWith(fontSize: 28)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ApprovedContentGate(
        contentContext: gateContext,
        builder: (context) => SafeArea(
          child: service.adaptResultsForMode(
            context: context,
            mode: mode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Semantics(
                    label: 'Search words, phrases, and lessons',
                    child: TextField(
                      controller: _controller,
                      style: ext.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Search words, phrases, lessons…',
                        hintStyle: ext.bodyLarge.copyWith(
                          color: ext.bodyLarge.color?.withOpacity(0.6),
                        ),
                        prefixIcon: Icon(Icons.search, color: ext.landAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: ext.landAccent),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Mode: ${mode.label} · Stage: ${filter.canonicalStage}',
                    style: ext.bodyLarge.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: SearchContentType.values.map((type) {
                      final selected = filter.contentTypes.contains(type);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type.label, style: ext.bodyLarge.copyWith(fontSize: 18)),
                          selected: selected,
                          onSelected: (_) => _toggleType(type),
                          selectedColor: ext.landAccent.withOpacity(0.2),
                          checkmarkColor: ext.landAccent,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: resultsAsync.when(
                    loading: () => Center(
                      child: Text('Searching…', style: ext.bodyLarge),
                    ),
                    error: (_, __) => Center(
                      child: Text(
                        'Content pending elder review',
                        style: ext.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    data: (results) {
                      if (results.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No results match your search and cultural filters.',
                              style: ext.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final result = results[index];
                          final ctx = result.toContentContext(mode: mode);
                          final preview = service.voiceFirstPreview(mode: mode, result: result);

                          return SacredContentLockerWidget(
                            recordId: result.id,
                            isSacred: result.requiresSacredGate,
                            contentContext: ctx,
                            child: ApprovedContentGate(
                              contentContext: ctx,
                              builder: (context) => ModeTierGuard(
                                visibleToTiers: result.visibleToTiers,
                                child: ClanBoundView(
                                  clanScope: result.clanScope,
                                  child: LivingAuthorityDecorator(
                                    speakerMetadata: result.speakerMetadata,
                                    contentContext: ctx,
                                    child: service.adaptResultForMode(
                                      context: context,
                                      mode: mode,
                                      result: result,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          if (mode == KuttiompMode.elder) ...[
                                            Text(
                                              preview,
                                              style: ext.bodyLarge.copyWith(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                          SearchResultCard.fromResult(
                                            result: result,
                                            onTap: () => context.push(result.detailRoute),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}