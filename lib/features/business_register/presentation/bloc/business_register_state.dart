part of 'business_register_cubit.dart';

enum RegisterStatus { editing, submitting, success, failure }

/// The wizard steps, in order. The intro screen lives outside the wizard.
enum RegisterStep {
  name,
  category,
  location,
  contact,
  schedule,
  photos,
  catalog,
}

class BusinessRegisterState extends Equatable {
  const BusinessRegisterState({
    required this.draft,
    this.step = RegisterStep.name,
    this.categories = const [],
    this.status = RegisterStatus.editing,
    this.error,
    this.publishedId,
  });

  final BusinessDraft draft;
  final RegisterStep step;
  final List<MarketCategory> categories;
  final RegisterStatus status;
  final String? error;
  final String? publishedId;

  bool get isSubmitting => status == RegisterStatus.submitting;

  bool get isFirstStep => step.index == 0;
  bool get isLastStep => step.index == RegisterStep.values.length - 1;

  /// 0..1 progress shown in the header (the name step has no bar).
  double get progress => (step.index + 1) / RegisterStep.values.length;

  BusinessRegisterState copyWith({
    BusinessDraft? draft,
    RegisterStep? step,
    List<MarketCategory>? categories,
    RegisterStatus? status,
    String? error,
    String? publishedId,
  }) {
    return BusinessRegisterState(
      draft: draft ?? this.draft,
      step: step ?? this.step,
      categories: categories ?? this.categories,
      status: status ?? this.status,
      error: error,
      publishedId: publishedId ?? this.publishedId,
    );
  }

  @override
  List<Object?> get props => [
    draft,
    step,
    categories,
    status,
    error,
    publishedId,
  ];
}
