import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/follow_repository.dart';
import '../bloc/follow_list_cubit.dart';

/// "Seguir" / "Siguiendo" toggle for a single business.
///
/// Owns its own [FollowListCubit] unless a [cubit] is supplied, in which case
/// the parent (e.g. BusinessProfilePage) controls its lifecycle and refresh.
class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.businessId, this.cubit});

  final String businessId;

  /// Optional externally-owned cubit. When null, this widget creates and owns
  /// its own cubit.
  final FollowListCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final externalCubit = cubit;
    if (externalCubit != null) {
      return BlocProvider<FollowListCubit>.value(
        value: externalCubit,
        child: _ButtonBody(businessId: businessId),
      );
    }
    return BlocProvider<FollowListCubit>(
      create: (context) =>
          FollowListCubit(repository: context.read<FollowRepository>())
            ..initialize(),
      child: _ButtonBody(businessId: businessId),
    );
  }
}

class _ButtonBody extends StatelessWidget {
  const _ButtonBody({required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowListCubit, FollowListState>(
      builder: (context, state) {
        final isFollowing = state.isFollowing(businessId);
        void onPressed() => context.read<FollowListCubit>().toggle(businessId);
        if (isFollowing) {
          return OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.check),
            label: const Text('Siguiendo'),
          );
        }
        return FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.favorite_border),
          label: const Text('Seguir'),
        );
      },
    );
  }
}
