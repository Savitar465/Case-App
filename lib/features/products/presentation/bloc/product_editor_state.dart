part of 'product_editor_cubit.dart';

enum ProductEditorAction { saved, deleted }

class ProductEditorState extends Equatable {
  const ProductEditorState({
    this.draft,
    this.isSaving = false,
    this.isDeleting = false,
    this.lastSaved,
    this.failure,
    this.lastAction,
  });

  final Product? draft;
  final bool isSaving;
  final bool isDeleting;
  final Product? lastSaved;
  final ProductFailure? failure;
  final ProductEditorAction? lastAction;

  bool get hasError => failure != null;
  bool get isBusy => isSaving || isDeleting;

  ProductEditorState copyWith({
    Product? draft,
    bool? isSaving,
    bool? isDeleting,
    Product? lastSaved,
    ProductFailure? failure,
    ProductEditorAction? lastAction,
    bool clearFailure = false,
    bool clearLastSaved = false,
    bool clearLastAction = false,
  }) {
    return ProductEditorState(
      draft: draft ?? this.draft,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      lastSaved: clearLastSaved ? null : lastSaved ?? this.lastSaved,
      failure: clearFailure ? null : failure ?? this.failure,
      lastAction: clearLastAction ? null : lastAction ?? this.lastAction,
    );
  }

  @override
  List<Object?> get props => [
    draft,
    isSaving,
    isDeleting,
    lastSaved,
    failure,
    lastAction,
  ];
}
