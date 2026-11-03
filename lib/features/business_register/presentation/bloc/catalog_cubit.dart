import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/business_registration_failure.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../../domain/entities/catalog_offer.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/usecases/add_catalog_item_use_case.dart';
import '../../domain/usecases/delete_catalog_item_use_case.dart';
import '../../domain/usecases/delete_offer_use_case.dart';
import '../../domain/usecases/get_catalog_items_use_case.dart';
import '../../domain/usecases/get_catalog_offers_use_case.dart';
import '../../domain/usecases/save_flash_offer_use_case.dart';
import '../../domain/usecases/set_catalog_item_active_use_case.dart';
import '../../domain/usecases/set_offer_active_use_case.dart';
import '../../domain/usecases/update_catalog_item_use_case.dart';

part 'catalog_state.dart';

/// Owner-side products, services and flash offers of one business. Every
/// write reloads both lists so prices/offer links stay consistent.
class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({
    required CatalogRepository repository,
    required String businessId,
  }) : _getItems = GetCatalogItemsUseCase(repository),
       _getOffers = GetCatalogOffersUseCase(repository),
       _addItem = AddCatalogItemUseCase(repository),
       _updateItem = UpdateCatalogItemUseCase(repository),
       _setItemActive = SetCatalogItemActiveUseCase(repository),
       _deleteItem = DeleteCatalogItemUseCase(repository),
       _saveOffer = SaveFlashOfferUseCase(repository),
       _setOfferActive = SetOfferActiveUseCase(repository),
       _deleteOffer = DeleteOfferUseCase(repository),
       super(CatalogState(businessId: businessId));

  final GetCatalogItemsUseCase _getItems;
  final GetCatalogOffersUseCase _getOffers;
  final AddCatalogItemUseCase _addItem;
  final UpdateCatalogItemUseCase _updateItem;
  final SetCatalogItemActiveUseCase _setItemActive;
  final DeleteCatalogItemUseCase _deleteItem;
  final SaveFlashOfferUseCase _saveOffer;
  final SetOfferActiveUseCase _setOfferActive;
  final DeleteOfferUseCase _deleteOffer;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final items = await _getItems(state.businessId);
      final offers = await _getOffers(state.businessId);
      if (isClosed) return;
      emit(
        state.copyWith(
          items: items,
          offers: offers,
          isLoading: false,
          hasLoaded: true,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          hasLoaded: true,
          error: _messageOf(error),
        ),
      );
    }
  }

  Future<bool> addItem(CatalogItemDraft draft) => _write(
    busyId: draft.id,
    success: '${_titleOf(draft.kind)} agregado',
    action: () => _addItem(state.businessId, draft),
  );

  Future<bool> updateItem(CatalogItem item, CatalogItemDraft draft) => _write(
    busyId: item.id,
    success: 'Cambios guardados',
    action: () => _updateItem(item, draft),
  );

  Future<bool> setItemActive(CatalogItem item, {required bool isActive}) =>
      _write(
        busyId: item.id,
        success: isActive
            ? '${_titleOf(item.kind)} activado'
            : '${_titleOf(item.kind)} pausado',
        action: () => _setItemActive(item.id, isActive: isActive),
      );

  Future<bool> deleteItem(CatalogItem item) => _write(
    busyId: item.id,
    success: '${_titleOf(item.kind)} eliminado',
    action: () => _deleteItem(item),
  );

  Future<bool> saveOffer({
    required CatalogItem item,
    required FlashOffer offer,
    String? offerId,
  }) => _write(
    busyId: offerId ?? item.id,
    success: offerId == null ? 'Oferta creada' : 'Oferta actualizada',
    action: () => _saveOffer(item: item, offer: offer, offerId: offerId),
  );

  Future<bool> setOfferActive(CatalogOffer offer, {required bool isActive}) =>
      _write(
        busyId: offer.id,
        success: isActive ? 'Oferta activada' : 'Oferta pausada',
        action: () => _setOfferActive(offer.id, isActive: isActive),
      );

  Future<bool> deleteOffer(CatalogOffer offer) => _write(
    busyId: offer.id,
    success: 'Oferta eliminada',
    action: () => _deleteOffer(offer.id),
  );

  /// Runs [action] with [busyId] marked busy, then reloads. Returns whether
  /// the write succeeded.
  Future<bool> _write({
    required String busyId,
    required String success,
    required Future<void> Function() action,
  }) async {
    emit(
      state.copyWith(
        busyIds: {...state.busyIds, busyId},
        clearError: true,
        clearMessage: true,
      ),
    );
    try {
      await action();
      if (isClosed) return true;
      emit(
        state.copyWith(
          busyIds: {...state.busyIds}..remove(busyId),
          message: success,
        ),
      );
      await load();
      return true;
    } catch (error) {
      if (isClosed) return false;
      emit(
        state.copyWith(
          busyIds: {...state.busyIds}..remove(busyId),
          error: _messageOf(error),
        ),
      );
      return false;
    }
  }

  static String _titleOf(CatalogItemKind kind) => kind.title;

  static String _messageOf(Object error) =>
      error is BusinessRegistrationFailure ? error.message : error.toString();
}
