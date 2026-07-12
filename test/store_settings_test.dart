import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/store_settings/models/store_settings.dart';

void main() {
  test('StoreSettings deserializes live API field names', () {
    const json = {
      'brand_name': 'Luna Cafe',
      'branch_name': 'Cabang Sudirman',
      'address': 'Jl. Sudirman No. 10',
      'phone': '021-1234567',
      'thank_you_note': 'Terima kasih!',
    };

    final settings = StoreSettings.fromJson(json);

    expect(settings.brandName, 'Luna Cafe');
    expect(settings.branchName, 'Cabang Sudirman');
    expect(settings.branchAddress, 'Jl. Sudirman No. 10');
    expect(settings.branchPhone, '021-1234567');
    expect(settings.thankYouNote, 'Terima kasih!');
  });
}
