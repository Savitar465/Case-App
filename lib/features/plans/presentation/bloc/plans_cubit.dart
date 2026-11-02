import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/plan.dart';
import '../../domain/entities/plan_business.dart';
import '../../domain/entities/plans_failure.dart';
import '../../domain/usecases/get_my_businesses_use_case.dart';
import '../../domain/usecases/get_plans_use_case.dart';
import '../../domain/usecases/subscribe_business_use_case.dart';

part 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit({
    required GetPlansUseCase getPlans,
    required GetMyBusinessesUseCase getMyBusinesses,
    required SubscribeBusinessUseCase subscribeBusiness,
  })  : _getPlans = getPlans,
        _getMyBusinesses = getMyBusinesses,
        _subscribeBusiness = subscribeBusiness,
        super(const PlansState());

  final GetPlansUseCase _getPlans;
  final GetMyBusinessesUseCase _getMyBusinesses;
  final SubscribeBusinessUseCase _subscribeBusiness;

  static const List<Plan> defaultFallbackPlans = [
    Plan(id: 'default-basico', name: 'Básico', price: 9),
    Plan(id: 'default-pro', name: 'Pro', price: 19),
    Plan(id: 'default-premium', name: 'Premium', price: 29),
  ];

  Future<void> loadPlans() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final fetched = await _getPlans();
      final plans = fetched.isNotEmpty ? fetched : defaultFallbackPlans;
      final currentSelected = state.selectedPlan;
      final selected = (currentSelected != null && plans.contains(currentSelected))
          ? currentSelected
          : plans.first;

      emit(state.copyWith(
        isLoading: false,
        plans: plans,
        selectedPlan: selected,
      ));
    } on PlansFailure catch (failure) {
      emit(state.copyWith(
        isLoading: false,
        plans: defaultFallbackPlans,
        selectedPlan: defaultFallbackPlans.first,
        error: failure.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        plans: defaultFallbackPlans,
        selectedPlan: defaultFallbackPlans.first,
        error: 'No se pudieron cargar los planes',
      ));
    }
  }

  void selectPlan(Plan plan) {
    emit(state.copyWith(selectedPlan: plan));
  }

  Future<void> loadMyBusinesses({String? preselectedBusinessId}) async {
    emit(state.copyWith(isLoadingBusinesses: true, clearError: true));
    try {
      final businesses = await _getMyBusinesses();

      PlanBusiness? selected;
      if (preselectedBusinessId != null) {
        for (final b in businesses) {
          if (b.id == preselectedBusinessId) {
            selected = b;
            break;
          }
        }
      }
      selected ??= state.selectedBusiness;
      if (selected == null && businesses.isNotEmpty) {
        selected = businesses.first;
      }

      emit(state.copyWith(
        isLoadingBusinesses: false,
        myBusinesses: businesses,
        selectedBusiness: selected,
      ));
    } on PlansFailure catch (failure) {
      emit(state.copyWith(
        isLoadingBusinesses: false,
        error: failure.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoadingBusinesses: false,
        error: 'No se pudieron cargar tus negocios',
      ));
    }
  }

  void selectBusiness(PlanBusiness business) {
    emit(state.copyWith(selectedBusiness: business));
  }

  Future<void> subscribeSelectedBusiness() async {
    final plan = state.selectedPlan;
    final business = state.selectedBusiness;

    if (plan == null) {
      emit(state.copyWith(error: 'Debes seleccionar un plan'));
      return;
    }
    if (business == null) {
      emit(state.copyWith(error: 'Debes seleccionar un negocio'));
      return;
    }

    emit(state.copyWith(
      isSubscribing: true,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      await _subscribeBusiness(
        businessId: business.id,
        plan: plan,
      );

      // Refresh locally the updated business in state
      final updatedList = state.myBusinesses.map((b) {
        if (b.id == business.id) {
          return b.copyWith(isPro: true);
        }
        return b;
      }).toList();

      emit(state.copyWith(
        isSubscribing: false,
        subscriptionSuccess: true,
        myBusinesses: updatedList,
        selectedBusiness: business.copyWith(isPro: true),
        successMessage:
            '¡Tu negocio "${business.name}" ahora es ViKuS Pro con el plan ${plan.name}!',
      ));
    } on PlansFailure catch (failure) {
      emit(state.copyWith(
        isSubscribing: false,
        error: failure.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isSubscribing: false,
        error: 'Ocurrió un error al procesar la suscripción',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void clearSuccess() {
    emit(state.copyWith(clearSuccess: true));
  }
}
