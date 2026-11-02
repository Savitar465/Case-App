part of 'plans_cubit.dart';

class PlansState extends Equatable {
  const PlansState({
    this.isLoading = false,
    this.plans = const [],
    this.selectedPlan,
    this.isLoadingBusinesses = false,
    this.myBusinesses = const [],
    this.selectedBusiness,
    this.isSubscribing = false,
    this.subscriptionSuccess = false,
    this.successMessage,
    this.error,
  });

  final bool isLoading;
  final List<Plan> plans;
  final Plan? selectedPlan;
  final bool isLoadingBusinesses;
  final List<PlanBusiness> myBusinesses;
  final PlanBusiness? selectedBusiness;
  final bool isSubscribing;
  final bool subscriptionSuccess;
  final String? successMessage;
  final String? error;

  PlansState copyWith({
    bool? isLoading,
    List<Plan>? plans,
    Plan? selectedPlan,
    bool? isLoadingBusinesses,
    List<PlanBusiness>? myBusinesses,
    PlanBusiness? selectedBusiness,
    bool clearSelectedBusiness = false,
    bool? isSubscribing,
    bool? subscriptionSuccess,
    String? successMessage,
    bool clearSuccess = false,
    String? error,
    bool clearError = false,
  }) {
    return PlansState(
      isLoading: isLoading ?? this.isLoading,
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      isLoadingBusinesses: isLoadingBusinesses ?? this.isLoadingBusinesses,
      myBusinesses: myBusinesses ?? this.myBusinesses,
      selectedBusiness: clearSelectedBusiness
          ? null
          : selectedBusiness ?? this.selectedBusiness,
      isSubscribing: isSubscribing ?? this.isSubscribing,
      subscriptionSuccess: clearSuccess
          ? false
          : subscriptionSuccess ?? this.subscriptionSuccess,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    plans,
    selectedPlan,
    isLoadingBusinesses,
    myBusinesses,
    selectedBusiness,
    isSubscribing,
    subscriptionSuccess,
    successMessage,
    error,
  ];
}
