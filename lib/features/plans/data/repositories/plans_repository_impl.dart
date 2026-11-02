import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import '../../domain/entities/plan.dart';
import '../../domain/entities/plans_failure.dart';
import '../../domain/repositories/plans_repository.dart';
import '../datasources/remote/plans_remote_data_source.dart';

class PlansRepositoryImpl implements PlansRepository {
  PlansRepositoryImpl({required PlansRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final PlansRemoteDataSource _remote;

  @override
  Future<List<Plan>> getPlans() async {
    try {
      return await _remote.fetchPlans();
    } catch (error) {
      developer.log(
        'Plans: getPlans failed',
        name: 'plans.data',
        error: error,
      );
      throw _mapInfraError(error);
    }
  }

  PlansFailure _mapInfraError(Object error) {
    if (error is PlansFailure) return error;
    if (error is PlansRemoteException) return PlansFailure(error.message);
    if (error is SocketException) {
      return const PlansFailure('No hay conexión a internet');
    }
    if (error is TimeoutException) {
      return const PlansFailure('La solicitud ha tardado demasiado');
    }
    return PlansFailure(error.toString());
  }
}

