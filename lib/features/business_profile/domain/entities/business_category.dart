enum BusinessCategory {
  unknown,
  food,
  retail,
  services,
  health,
  beauty,
  fitness,
  education,
  entertainment,
  other,
}

extension BusinessCategoryX on BusinessCategory {
  String get label => switch (this) {
    BusinessCategory.unknown => 'unknown',
    BusinessCategory.food => 'food',
    BusinessCategory.retail => 'retail',
    BusinessCategory.services => 'services',
    BusinessCategory.health => 'health',
    BusinessCategory.beauty => 'beauty',
    BusinessCategory.fitness => 'fitness',
    BusinessCategory.education => 'education',
    BusinessCategory.entertainment => 'entertainment',
    BusinessCategory.other => 'other',
  };
}

BusinessCategory businessCategoryFromLabel(String? value) {
  if (value == null || value.isEmpty) {
    return BusinessCategory.unknown;
  }
  final normalized = value.toLowerCase();
  for (final category in BusinessCategory.values) {
    if (category.label == normalized) return category;
  }
  return BusinessCategory.unknown;
}
