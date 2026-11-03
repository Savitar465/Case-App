import 'package:equatable/equatable.dart';

import 'business_draft.dart';
import 'editable_photo.dart';

/// An existing business loaded into the edit form. The catalog lists of
/// [draft] are always empty: items and offers are managed separately.
class EditableBusiness extends Equatable {
  const EditableBusiness({
    required this.id,
    required this.draft,
    this.photos = const [],
  });

  final String id;
  final BusinessDraft draft;

  /// Photos in display order; the first one is the cover.
  final List<EditablePhoto> photos;

  @override
  List<Object?> get props => [id, draft, photos];
}
