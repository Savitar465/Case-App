enum ItemType { product, service, unknown }

ItemType itemTypeFromLabel(String? label) {
  switch (label?.toLowerCase()) {
    case 'product':
    case 'producto':
      return ItemType.product;
    case 'service':
    case 'servicio':
      return ItemType.service;
    default:
      return ItemType.unknown;
  }
}
