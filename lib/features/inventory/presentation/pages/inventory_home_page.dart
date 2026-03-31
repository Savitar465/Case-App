import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../bloc/employees_cubit.dart';
import '../bloc/inventory_dashboard_cubit.dart';
import '../bloc/inventory_stock_cubit.dart';
import '../bloc/locations_cubit.dart';
import '../bloc/reports_cubit.dart';
import '../bloc/transactions_cubit.dart';
import 'inventory_dashboard_section.dart';
import 'inventory_master_section.dart';
import 'inventory_reports_section.dart';
import 'inventory_transactions_section.dart';

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({super.key, required this.session});

  static const routeName = '/inventory';

  final AuthSession session;

  @override
  State<InventoryHomePage> createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  int _selectedIndex = 0;
  bool _isSyncing = false;

  Future<void> _syncNow() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
    });
    final repo = context.read<InventoryRepository>();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sincronizando con Supabase...')),
    );
    try {
      await repo.syncPendingChanges();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sincronización completada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de sincronización: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryRepository = context.read<InventoryRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationsCubit>(
          create: (_) =>
              LocationsCubit(repository: inventoryRepository)..initialize(),
        ),
        BlocProvider<EmployeesCubit>(
          create: (_) =>
              EmployeesCubit(repository: inventoryRepository)..initialize(),
        ),
        BlocProvider<InventoryDashboardCubit>(
          create: (_) =>
              InventoryDashboardCubit(repository: inventoryRepository)
                ..initialize(),
        ),
        BlocProvider<InventoryStockCubit>(
          create: (_) =>
              InventoryStockCubit(repository: inventoryRepository)
                ..watch(),
        ),
        BlocProvider<TransactionsCubit>(
          create: (_) => TransactionsCubit(repository: inventoryRepository),
        ),
        BlocProvider<InventoryReportsCubit>(
          create: (_) =>
              InventoryReportsCubit(repository: inventoryRepository)
                ..initialize(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion de inventario'),
          actions: [
            IconButton(
              tooltip: 'Sincronizar con Supabase',
              onPressed: _isSyncing ? null : _syncNow,
              icon: const Icon(Icons.cloud_sync),
            ),
            IconButton(
              tooltip: 'Cerrar sesion',
              onPressed: () =>
                  context.read<AuthBloc>().add(const LogoutRequested()),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.business_outlined),
                  selectedIcon: Icon(Icons.business),
                  label: Text('Gestión'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.swap_horiz_outlined),
                  selectedIcon: Icon(Icons.swap_horiz),
                  label: Text('Movimientos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: Text('Reportes'),
                ),
              ],
              onDestinationSelected: (value) => setState(() {
                _selectedIndex = value;
              }),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  InventoryDashboardSection(),
                  InventoryMasterSection(),
                  InventoryTransactionsSection(),
                  InventoryReportsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
