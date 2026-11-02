part of 'plans_cubit.dart';

class PlansState extends Equatable {
  const PlansState({
    this.isLoading = false,
    this.plans = const [],
    this.selectedPlan,
    this.error,
  });

  final bool isLoading;
  final List<Plan> plans;
  final Plan? selectedPlan;
  final String? error;

  PlansState copyWith({
    bool? isLoading,
    List<Plan>? plans,
    Plan? selectedPlan,
    String? error,
    bool clearError = false,
  }) {
    return PlansState(
      isLoading: isLoading ?? this.isLoading,
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, plans, selectedPlan, error];
}

