import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/inventory_transaction.dart';
import '../../domain/repositories/inventory_repository.dart';

class TransactionsState extends Equatable {
  const TransactionsState({
    this.isProcessing = false,
    this.message,
    this.error,
  });

  final bool isProcessing;
  final String? message;
  final String? error;

  TransactionsState copyWith({
    bool? isProcessing,
    String? message,
    String? error,
  }) {
    return TransactionsState(
      isProcessing: isProcessing ?? this.isProcessing,
      message: message,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isProcessing, message, error];
}

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({required InventoryRepository repository})
      : _repository = repository,
        super(const TransactionsState());

  final InventoryRepository _repository;

  Future<void> recordPurchase(Purchase purchase) async {
    emit(state.copyWith(isProcessing: true, message: null, error: null));
    try {
      await _repository.recordPurchase(purchase);
      emit(state.copyWith(
        isProcessing: false,
        message: 'Compra registrada correctamente.',
      ));
    } catch (error) {
      emit(state.copyWith(
        isProcessing: false,
        error: error.toString(),
      ));
    }
  }

  Future<void> recordSale(Sale sale) async {
    emit(state.copyWith(isProcessing: true, message: null, error: null));
    try {
      await _repository.recordSale(sale);
      emit(state.copyWith(
        isProcessing: false,
        message: 'Venta registrada correctamente.',
      ));
    } catch (error) {
      emit(state.copyWith(
        isProcessing: false,
        error: error.toString(),
      ));
    }
  }

  Future<void> recordTransfer(InventoryTransfer transfer) async {
    emit(state.copyWith(isProcessing: true, message: null, error: null));
    try {
      await _repository.recordTransfer(transfer);
      emit(state.copyWith(
        isProcessing: false,
        message: 'Transferencia registrada correctamente.',
      ));
    } catch (error) {
      emit(state.copyWith(
        isProcessing: false,
        error: error.toString(),
      ));
    }
  }
}
