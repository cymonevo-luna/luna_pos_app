import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/features/menu_disposal/dispose_food_controller.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';

void main() {
  const sampleMenu = POSMenuItem(
    id: 'menu-1',
    title: 'Nasi Goreng',
    availableStock: 1,
    sellPrice: 35000,
  );

  test('setQuantity blocks quantity above available stock', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(disposeFoodProvider.notifier);
    notifier.selectMenu(sampleMenu);
    notifier.setQuantity(5);

    final state = container.read(disposeFoodProvider);
    expect(state.quantityError, isNotNull);
    expect(state.canSubmit, isFalse);
  });

  test('setQuantity blocks zero quantity', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(disposeFoodProvider.notifier);
    notifier.selectMenu(sampleMenu);
    notifier.setQuantity(0);

    final state = container.read(disposeFoodProvider);
    expect(state.quantityError, isNotNull);
    expect(state.canSubmit, isFalse);
  });
}
