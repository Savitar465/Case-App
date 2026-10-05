import 'package:flutter_test/flutter_test.dart';
import 'package:market_app/features/market/data/models/business_model.dart';

void main() {
  String resolve(String raw) =>
      raw.startsWith('http') ? raw : 'https://cdn.test/$raw';

  // 2026-10-05 is a Monday.
  DateTime monday(int hour, int minute) => DateTime(2026, 10, 5, hour, minute);

  test('parses the wizard schedule shape and closing label', () {
    final business = BusinessModel.fromRemote({
      'id': '1',
      'name': 'Body Xtreme',
      'address': 'Av. Pando',
      'schedule': {
        'monday': {'is_open': true, 'open': '6:00', 'close': '19:00'},
        'sunday': {'is_open': false, 'open': '6:00', 'close': '19:00'},
      },
    }, resolveImageUrl: resolve);

    final range = business.openingHours.currentRange(monday(10, 0));
    expect(range?.closeLabel, '19:00');
    expect(business.openingHours.currentRange(monday(19, 0)), isNull);
    expect(business.openingHours.days.containsKey(DateTime.sunday), isFalse);
  });

  test('parses the legacy list schedule shape with split shifts', () {
    final business = BusinessModel.fromRemote({
      'id': '1',
      'name': 'Dental',
      'address': 'x',
      'schedule': {
        'monday': [
          {'open': '08:00', 'close': '12:00'},
          {'open': '14:00', 'close': '19:00'},
        ],
      },
    }, resolveImageUrl: resolve);

    expect(business.openingHours.currentRange(monday(13, 0)), isNull);
    expect(
      business.openingHours.currentRange(monday(15, 0))?.closeLabel,
      '19:00',
    );
  });

  test('averages active reviews and puts the cover image first', () {
    final business = BusinessModel.fromRemote({
      'id': '1',
      'name': 'Pizza',
      'address': 'x',
      'business_images': [
        {'url': 'b.jpg', 'is_cover': false, 'display_order': 1},
        {'url': 'https://img/a.jpg', 'is_cover': true, 'display_order': 0},
      ],
      'reviews': [
        {'rating': 5, 'status': 'active'},
        {'rating': 3, 'status': 'active'},
        {'rating': 1, 'status': 'deleted'},
      ],
    }, resolveImageUrl: resolve);

    expect(business.imageUrls, ['https://img/a.jpg', 'https://cdn.test/b.jpg']);
    expect(business.rating, 4);
    expect(business.reviewCount, 2);
  });
}
