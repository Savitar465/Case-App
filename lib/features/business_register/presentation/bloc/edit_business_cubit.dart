import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../market/domain/entities/category.dart';
import '../../domain/entities/business_draft.dart';
import '../../domain/entities/business_registration_failure.dart';
import '../../domain/entities/day_schedule.dart';
import '../../domain/entities/editable_photo.dart';
import '../../domain/repositories/business_registration_repository.dart';
import '../../domain/usecases/get_business_for_edit_use_case.dart';
import '../../domain/usecases/update_business_use_case.dart';

part 'edit_business_state.dart';

/// Drives one section of the business editor: load → edit → save.
class EditBusinessCubit extends Cubit<EditBusinessState> {
  EditBusinessCubit({
    required BusinessRegistrationRepository repository,
    required String businessId,
    required EditBusinessSection section,
  }) : _repository = repository,
       _getBusiness = GetBusinessForEditUseCase(repository),
       _updateBusiness = UpdateBusinessUseCase(repository),
       super(EditBusinessState(businessId: businessId, section: section));

  final BusinessRegistrationRepository _repository;
  final GetBusinessForEditUseCase _getBusiness;
  final UpdateBusinessUseCase _updateBusiness;

  Future<void> load() async {
    emit(state.copyWith(status: EditBusinessStatus.loading, clearError: true));
    try {
      final business = await _getBusiness(state.businessId);
      emit(
        state.copyWith(
          status: EditBusinessStatus.ready,
          draft: business.draft,
          initialDraft: business.draft,
          photos: business.photos,
          initialPhotos: business.photos,
          removedPhotos: const [],
        ),
      );
    } on BusinessRegistrationFailure catch (failure) {
      emit(
        state.copyWith(
          status: EditBusinessStatus.loadFailure,
          error: failure.message,
        ),
      );
      return;
    } catch (error) {
      emit(
        state.copyWith(
          status: EditBusinessStatus.loadFailure,
          error: error.toString(),
        ),
      );
      return;
    }
    // Only the info screen shows the category picker.
    if (state.section == EditBusinessSection.info) await _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _repository.getCategories();
      if (!isClosed) emit(state.copyWith(categories: categories));
    } catch (_) {
      // Non-fatal: the current category stays selected and is still shown.
    }
  }

  // ── Field updates ──────────────────────────────────────────────────────
  void editDraft(BusinessDraft Function(BusinessDraft draft) change) {
    final draft = state.draft;
    if (draft == null) return;
    emit(state.copyWith(draft: change(draft), clearError: true));
  }

  void selectCategory(MarketCategory category) =>
      editDraft((draft) => draft.copyWith(category: category));

  void setLocation(double latitude, double longitude) => editDraft(
    (draft) => draft.copyWith(latitude: latitude, longitude: longitude),
  );

  void updateDay(int index, DaySchedule Function(DaySchedule day) change) {
    editDraft((draft) {
      final schedule = [...draft.schedule];
      schedule[index] = change(schedule[index]);
      return draft.copyWith(schedule: schedule);
    });
  }

  // ── Photos ─────────────────────────────────────────────────────────────
  void addPhotos(List<String> paths) => emit(
    state.copyWith(
      photos: [...state.photos, ...paths.map(EditablePhoto.local)],
    ),
  );

  void removePhoto(EditablePhoto photo) {
    emit(
      state.copyWith(
        photos: state.photos.where((p) => p != photo).toList(),
        removedPhotos: photo.isLocal
            ? state.removedPhotos
            : [...state.removedPhotos, photo],
      ),
    );
  }

  /// Moves [photo] to the front; the first photo is the cover.
  void makeCover(EditablePhoto photo) {
    emit(
      state.copyWith(photos: [photo, ...state.photos.where((p) => p != photo)]),
    );
  }

  // ── Save ───────────────────────────────────────────────────────────────
  Future<void> save() async {
    final draft = state.draft;
    if (draft == null || !state.canSave) return;
    emit(state.copyWith(status: EditBusinessStatus.saving, clearError: true));
    try {
      await _updateBusiness(
        businessId: state.businessId,
        draft: draft,
        // Null leaves photos untouched when this save didn't change them.
        photos: state.photosChanged ? state.photos : null,
        removedPhotos: state.photosChanged ? state.removedPhotos : null,
      );
      emit(state.copyWith(status: EditBusinessStatus.saved));
    } on BusinessRegistrationFailure catch (failure) {
      emit(
        state.copyWith(
          status: EditBusinessStatus.ready,
          error: failure.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: EditBusinessStatus.ready,
          error: error.toString(),
        ),
      );
    }
  }
}
