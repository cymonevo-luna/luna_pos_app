import 'package:flutter/material.dart';

import '../../../core/di/locator.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../../stock/data/food_supply_repository.dart';
import '../../stock/models/food_supply.dart';

class FoodSupplyPickerSheet extends StatefulWidget {
  const FoodSupplyPickerSheet({super.key});

  static Future<FoodSupply?> show(BuildContext context) {
    return showModalBottomSheet<FoodSupply>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const FoodSupplyPickerSheet(),
    );
  }

  @override
  State<FoodSupplyPickerSheet> createState() => _FoodSupplyPickerSheetState();
}

class _FoodSupplyPickerSheetState extends State<FoodSupplyPickerSheet> {
  final _searchController = TextEditingController();
  final _foodSupplyRepository = locator<FoodSupplyRepository>();
  List<FoodSupply> _supplies = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSupplies();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadSupplies({String? search}) async {
    setState(() => _loading = true);
    try {
      final response = await _foodSupplyRepository.fetchFoodSupplies(
        search: search,
      );
      if (!mounted) return;
      setState(() {
        _supplies = response.items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _onSearchChanged() {
    _loadSupplies(search: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText.title(l10n.smartPurchaseSelectIngredient),
                    const VGap(AppSpacing.md),
                    AppTextField(
                      fieldKey: const Key('smart_purchase_food_supply_search'),
                      hint: l10n.smartPurchaseSearchIngredients,
                      controller: _searchController,
                      prefixIcon: Icons.search,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _supplies.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: AppText.body(
                                l10n.smartPurchaseNoIngredients,
                                align: TextAlign.center,
                                muted: true,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _supplies.length,
                            itemBuilder: (context, index) {
                              final supply = _supplies[index];
                              return ListTile(
                                key: Key(
                                  'smart_purchase_food_supply_${supply.id}',
                                ),
                                title: Text(supply.title),
                                subtitle: Text(supply.unit),
                                onTap: () =>
                                    Navigator.of(context).pop(supply),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
