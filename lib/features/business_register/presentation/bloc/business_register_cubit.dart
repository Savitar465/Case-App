import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../market/domain/entities/category.dart';
import '../../domain/entities/business_draft.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../../domain/entities/day_schedule.dart';
import '../../domain/repositories/business_registration_repository.dart';

part 'business_register_state.dart';

class BusinessRegisterCubit extends Cubit<BusinessRegisterState> {
  BusinessRegisterCubit({required BusinessRegistrationRepository repository})
    : _repository = repository,
      super(BusinessRegisterState(draft: BusinessDraft()));

  final BusinessRegistrationRepository _repository;

  Future<void> loadCategories() async {
    if (state.categories.isNotEmpty) return;
    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(categories: categories));
    } catch (_) {
      // Non-fatal: the category step shows a retry affordance.
    }
  }

  // ── Field updates ──────────────────────────────────────────────────────
  void setName(String value) =>
      emit(state.copyWith(draft: state.draft.copyWith(name: value)));

  void selectCategory(MarketCategory category) =>
      emit(state.copyWith(draft: state.draft.copyWith(category: category)));

  void setAddress(String value) =>
      emit(state.copyWith(draft: state.draft.copyWith(address: value)));

  void setLocation(double latitude, double longitude) => emit(
    state.copyWith(
      draft: state.draft.copyWith(latitude: latitude, longitude: longitude),
    ),
  );

  void setWhatsapp(String value) =>
      emit(state.copyWith(draft: state.draft.copyWith(whatsapp: value)));

  void setTiktok(String value) =>
      emit(state.copyWith(draft: state.draft.copyWith(tiktok: value)));

  void setFacebook(String value) =>
      emit(state.copyWith(draft: state.draft.copyWith(facebook: value)));

  void setInstagram(String value) =>
      emit(state.copyWith(draft: state.draft.copyWith(instagram: value)));

  void setWebsite(String value) =>
      emit(state.copyWith(draft: state.draft.copyWith(website: value)));

  void toggleDay(int index, bool isOpen) =>
      _updateDay(index, (day) => day.copyWith(isOpen: isOpen));

  void setDayOpen(int index, String value) =>
      _updateDay(index, (day) => day.copyWith(open: value));

  void setDayClose(int index, String value) =>
      _updateDay(index, (day) => day.copyWith(close: value));

  void _updateDay(int index, DaySchedule Function(DaySchedule) transform) {
    final schedule = [...state.draft.schedule];
    schedule[index] = transform(schedule[index]);
    emit(state.copyWith(draft: state.draft.copyWith(schedule: schedule)));
  }

  void addPhotos(List<String> paths) => emit(
    state.copyWith(
      draft: state.draft.copyWith(photos: [...state.draft.photos, ...paths]),
    ),
  );

  void removePhoto(String path) => emit(
    state.copyWith(
      draft: state.draft.copyWith(
        photos: state.draft.photos.where((p) => p != path).toList(),
      ),
    ),
  );

  void addCatalogItem(CatalogItemDraft item) {
    if (item.kind == CatalogItemKind.service) {
      emit(
        state.copyWith(
          draft: state.draft.copyWith(
            services: [...state.draft.services, item],
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          draft: state.draft.copyWith(
            products: [...state.draft.products, item],
          ),
        ),
      );
    }
  }

  void removeCatalogItem(CatalogItemDraft item) {
    emit(
      state.copyWith(
        draft: state.draft.copyWith(
          services: state.draft.services.where((s) => s.id != item.id).toList(),
          products: state.draft.products.where((p) => p.id != item.id).toList(),
        ),
      ),
    );
  }

  // ── Step navigation ────────────────────────────────────────────────────
  /// Whether the current step's required fields are satisfied.
  bool get canAdvance {
    final draft = state.draft;
    return switch (state.step) {
      RegisterStep.name => draft.name.trim().isNotEmpty,
      RegisterStep.category => draft.category != null,
      RegisterStep.location =>
        draft.address.trim().isNotEmpty ||
            (draft.latitude != null && draft.longitude != null),
      RegisterStep.contact => draft.whatsapp.trim().isNotEmpty,
      RegisterStep.schedule => true,
      RegisterStep.photos => true,
      RegisterStep.catalog => true,
    };
  }

  void next() {
    if (!canAdvance || state.isLastStep) return;
    emit(state.copyWith(step: RegisterStep.values[state.step.index + 1]));
  }

  void back() {
    if (state.isFirstStep) return;
    emit(state.copyWith(step: RegisterStep.values[state.step.index - 1]));
  }

  // ── Publish ────────────────────────────────────────────────────────────
  Future<void> publish() async {
    emit(state.copyWith(status: RegisterStatus.submitting));
    try {
      final id = await _repository.publish(state.draft);
      emit(state.copyWith(status: RegisterStatus.success, publishedId: id));
    } catch (error) {
      emit(
        state.copyWith(status: RegisterStatus.failure, error: error.toString()),
      );
    }
  }
}
