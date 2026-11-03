part of 'edit_business_cubit.dart';

enum EditBusinessStatus { loading, loadFailure, ready, saving, saved }

/// One edit screen per "Administrar negocio" option on the dashboard.
enum EditBusinessSection { info, photos, schedule, social }

class EditBusinessState extends Equatable {
  const EditBusinessState({
    required this.businessId,
    required this.section,
    this.status = EditBusinessStatus.loading,
    this.draft,
    this.initialDraft,
    this.photos = const [],
    this.initialPhotos = const [],
    this.removedPhotos = const [],
    this.categories = const [],
    this.error,
  });

  final String businessId;
  final EditBusinessSection section;
  final EditBusinessStatus status;

  /// Current form values; null until loaded.
  final BusinessDraft? draft;

  /// Values as loaded, used to detect unsaved changes.
  final BusinessDraft? initialDraft;

  /// Photos in display order (first = cover), including new local ones.
  final List<EditablePhoto> photos;
  final List<EditablePhoto> initialPhotos;

  /// Stored photos the owner removed; deleted on save.
  final List<EditablePhoto> removedPhotos;
  final List<MarketCategory> categories;
  final String? error;

  bool get isSaving => status == EditBusinessStatus.saving;

  bool get photosChanged => !_samePhotos(photos, initialPhotos);

  bool get isDirty => draft != initialDraft || photosChanged;

  /// First unmet requirement of the open [section], or null when it can be
  /// saved. Other sections are not validated so, e.g., a legacy business
  /// without WhatsApp can still update its schedule.
  String? get validationError {
    final draft = this.draft;
    if (draft == null) return null;
    if (section == EditBusinessSection.schedule) {
      for (final day in draft.schedule) {
        final error = day.validationError;
        if (error != null) return error;
      }
      return null;
    }
    if (section != EditBusinessSection.info) return null;
    if (draft.name.trim().isEmpty) return 'Ingresa el nombre del negocio';
    if (draft.category == null) return 'Selecciona una categoría';
    if (draft.address.trim().isEmpty &&
        (draft.latitude == null || draft.longitude == null)) {
      return 'Indica la ubicación del negocio';
    }
    if (draft.whatsapp.trim().isEmpty) return 'Ingresa un número de WhatsApp';
    final email = draft.email.trim();
    if (email.isNotEmpty && !email.contains('@')) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  bool get canSave =>
      status == EditBusinessStatus.ready && isDirty && validationError == null;

  static bool _samePhotos(List<EditablePhoto> a, List<EditablePhoto> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  EditBusinessState copyWith({
    EditBusinessStatus? status,
    BusinessDraft? draft,
    BusinessDraft? initialDraft,
    List<EditablePhoto>? photos,
    List<EditablePhoto>? initialPhotos,
    List<EditablePhoto>? removedPhotos,
    List<MarketCategory>? categories,
    String? error,
    bool clearError = false,
  }) {
    return EditBusinessState(
      businessId: businessId,
      section: section,
      status: status ?? this.status,
      draft: draft ?? this.draft,
      initialDraft: initialDraft ?? this.initialDraft,
      photos: photos ?? this.photos,
      initialPhotos: initialPhotos ?? this.initialPhotos,
      removedPhotos: removedPhotos ?? this.removedPhotos,
      categories: categories ?? this.categories,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    businessId,
    section,
    status,
    draft,
    initialDraft,
    photos,
    initialPhotos,
    removedPhotos,
    categories,
    error,
  ];
}
