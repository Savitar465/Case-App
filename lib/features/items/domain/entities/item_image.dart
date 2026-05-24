import 'package:equatable/equatable.dart';

class ItemImage extends Equatable {
  const ItemImage({
    required this.id,
    required this.itemId,
    required this.url,
    required this.displayOrder,
  });

  final String id;
  final String itemId;
  final String url;
  final int displayOrder;

  @override
  List<Object?> get props => [id, itemId, url, displayOrder];
}
