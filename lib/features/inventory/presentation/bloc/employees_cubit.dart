import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/employee.dart';
import '../../domain/repositories/inventory_repository.dart';

class EmployeesState extends Equatable {
  const EmployeesState({
    this.isLoading = true,
    this.employees = const [],
    this.locationFilter,
    this.error,
  });

  final bool isLoading;
  final List<Employee> employees;
  final String? locationFilter;
  final String? error;

  EmployeesState copyWith({
    bool? isLoading,
    List<Employee>? employees,
    String? locationFilter,
    String? error,
  }) {
    return EmployeesState(
      isLoading: isLoading ?? this.isLoading,
      employees: employees ?? this.employees,
      locationFilter: locationFilter ?? this.locationFilter,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, employees, locationFilter, error];
}

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit({required InventoryRepository repository})
      : _repository = repository,
        super(const EmployeesState());

  final InventoryRepository _repository;
  StreamSubscription<List<Employee>>? _subscription;

  void initialize({String? locationId}) {
    emit(state.copyWith(isLoading: true, locationFilter: locationId, error: null));
    _subscription?.cancel();
    _subscription = _repository
        .watchEmployees(locationId: locationId)
        .listen((employees) {
      emit(
        state.copyWith(
          isLoading: false,
          employees: employees,
          error: null,
        ),
      );
    }, onError: (error, stackTrace) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    });
  }

  Future<void> saveEmployee(Employee employee) async {
    try {
      await _repository.saveEmployee(employee);
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      await _repository.deleteEmployee(employeeId);
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
