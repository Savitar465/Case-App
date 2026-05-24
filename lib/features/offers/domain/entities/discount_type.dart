enum DiscountType { percentage, fixedAmount, unknown }

DiscountType discountTypeFromLabel(String? label) {
  switch (label?.toLowerCase()) {
    case 'percentage':
    case 'porcentaje':
      return DiscountType.percentage;
    case 'fixed_amount':
    case 'fixed':
    case 'monto_fijo':
      return DiscountType.fixedAmount;
    default:
      return DiscountType.unknown;
  }
}
