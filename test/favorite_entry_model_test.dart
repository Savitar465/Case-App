import 'package:flutter_test/flutter_test.dart';
import 'package:market_app/features/favorites/data/models/favorite_entry_model.dart';
import 'package:market_app/features/favorites/domain/entities/favorite_kind.dart';

void main() {
  String resolve(String raw) =>
      raw.startsWith('http') ? raw : 'https://cdn.test/$raw';

  test('item rows land in the service or product bucket by type', () {
    Map<String, dynamic> row(String type) => {
      'created_at': '2026-10-05T10:00:00',
      'items': {
        'id': 'i1',
        'name': 'Limpieza dental',
        'type': type,
        'price': 150,
        'currency': 'BOB',
        'business_id': 'b1',
        'businesses': {'name': 'Clínica'},
        'item_images': [
          {'url': 'x.jpg', 'display_order': 0},
        ],
      },
    };

    final service = FavoriteEntryModel.fromItemRow(row('service'), resolve)!;
    final product = FavoriteEntryModel.fromItemRow(row('product'), resolve)!;

    expect(service.kind, FavoriteKind.service);
    expect(product.kind, FavoriteKind.product);
    expect(service.businessId, 'b1');
    expect(service.subtitle, 'Clínica');
    expect(service.imageUrl, 'https://cdn.test/x.jpg');
    expect(service.price, 150);
  });

  test('rows whose target was deleted are skipped', () {
    expect(FavoriteEntryModel.fromItemRow({'items': null}, resolve), isNull);
    expect(FavoriteEntryModel.fromOfferRow({'offers': null}, resolve), isNull);
    expect(
      FavoriteEntryModel.fromFollowRow({'businesses': null}, resolve),
      isNull,
    );
  });

  test('business follows use the cover image and address', () {
    final entry = FavoriteEntryModel.fromFollowRow({
      'businesses': {
        'id': 'b1',
        'name': 'Body Xtreme',
        'address': 'Av. Pando',
        'business_images': [
          {'url': 'second.jpg', 'is_cover': false, 'display_order': 0},
          {'url': 'https://img/cover.jpg', 'is_cover': true},
        ],
      },
    }, resolve)!;

    expect(entry.kind, FavoriteKind.business);
    expect(entry.targetId, 'b1');
    expect(entry.subtitle, 'Av. Pando');
    expect(entry.imageUrl, 'https://img/cover.jpg');
  });
}
