import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:market_app/features/business/domain/entities/business.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';
import 'package:market_app/features/business/domain/usecases/refresh_businesses_use_case.dart';
import 'package:market_app/features/business/domain/usecases/watch_businesses_use_case.dart';
import 'package:market_app/features/business/presentation/bloc/business_list_cubit.dart';

class BusinessListPage extends StatelessWidget {
  const BusinessListPage({super.key});

  static const String routeName = '/businesses';

  @override
  Widget build(BuildContext context) {
    final repository = context.read<BusinessRepository>();
    return BlocProvider(
      create: (_) => BusinessListCubit(
        watchBusinesses: WatchBusinessesUseCase(repository),
        refreshBusinesses: RefreshBusinessesUseCase(repository),
      )..initialize(),
      child: const _BusinessListView(),
    );
  }
}

class _BusinessListView extends StatelessWidget {
  const _BusinessListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Negocios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () =>
                context.read<AuthBloc>().add(const LogoutRequested()),
          ),
        ],
      ),
      body: BlocBuilder<BusinessListCubit, BusinessListState>(
        builder: (context, state) {
          if (state.isLoading && state.businesses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.businesses.isEmpty) {
            return _ErrorView(
              message: state.error!,
              onRetry: () => context.read<BusinessListCubit>().refresh(),
            );
          }
          if (state.businesses.isEmpty) {
            return const _EmptyView();
          }
          return RefreshIndicator(
            onRefresh: () => context.read<BusinessListCubit>().refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.businesses.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, index) =>
                  _BusinessTile(business: state.businesses[index]),
            ),
          );
        },
      ),
    );
  }
}

class _BusinessTile extends StatelessWidget {
  const _BusinessTile({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            business.logoUrl != null ? NetworkImage(business.logoUrl!) : null,
        child: business.logoUrl == null
            ? Text(business.name.isNotEmpty ? business.name[0].toUpperCase() : '?')
            : null,
      ),
      title: Text(business.name),
      subtitle: business.description != null
          ? Text(
              business.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil de "${business.name}" próximamente')),
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Todavía no hay negocios para mostrar.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
