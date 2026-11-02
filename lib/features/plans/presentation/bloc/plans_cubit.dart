import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/plan.dart';
import '../../domain/entities/plans_failure.dart';
import '../../domain/usecases/get_plans_use_case.dart';

part 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit({required GetPlansUseCase getPlans})
    : _getPlans = getPlans,
      super(const PlansState());

  final GetPlansUseCase _getPlans;

  static const List<Plan> defaultFallbackPlans = [
    Plan(id: 'default-mensual', name: 'Mensual', price: 15),
    Plan(id: 'default-trimestral', name: 'Trimestral', price: 42),
    Plan(id: 'default-anual', name: 'Anual', price: 150),
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
}

