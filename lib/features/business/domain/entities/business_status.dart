enum BusinessStatus { pending, active, deleted }

extension BusinessStatusX on BusinessStatus {
  String get label => switch (this) {
    BusinessStatus.pending => 'pending',
    BusinessStatus.active => 'active',
    BusinessStatus.deleted => 'deleted',
  };
}

BusinessStatus businessStatusFromLabel(String? value) {
  if (value == null || value.isEmpty) {
    return BusinessStatus.pending;
  }
  switch (value.toLowerCase()) {
    case 'active':
      return BusinessStatus.active;
    case 'deleted':
      return BusinessStatus.deleted;
    case 'pending':
    default:
      return BusinessStatus.pending;
  }
}
