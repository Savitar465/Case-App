import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/follow.dart';
import '../../domain/repositories/follow_repository.dart';
import '../bloc/follow_list_cubit.dart';

class FollowListPage extends StatelessWidget {
  const FollowListPage({super.key});

  static const String routeName = '/follows';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowListCubit>(
      create: (context) =>
          FollowListCubit(repository: context.read<FollowRepository>())
            ..initialize(),
      child: const _FollowListView(),
    );
  }
}

class _FollowListView extends StatelessWidget {
  const _FollowListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Negocios que sigo')),
      body: BlocBuilder<FollowListCubit, FollowListState>(
        builder: (context, state) {
          if (state.isLoading && state.follows.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.follows.isEmpty) {
            return Center(child: Text(state.error!));
          }
          if (state.follows.isEmpty) {
            return const Center(child: Text('Aún no sigues ningún negocio'));
          }
          return RefreshIndicator(
            onRefresh: () => context.read<FollowListCubit>().refresh(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.follows.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _FollowTile(follow: state.follows[index]),
            ),
          );
        },
      ),
    );
  }
}

class _FollowTile extends StatelessWidget {
  const _FollowTile({required this.follow});

  final Follow follow;

  @override
  Widget build(BuildContext context) {
    final date = follow.createdAt.toLocal();
    final formatted = '${date.year}-${_two(date.month)}-${_two(date.day)}';
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.storefront)),
      title: Text(follow.businessId),
      subtitle: Text('Siguiendo desde $formatted'),
    );
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
