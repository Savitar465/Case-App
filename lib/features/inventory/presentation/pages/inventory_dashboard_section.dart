import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_dashboard_cubit.dart';
import '../bloc/inventory_stock_cubit.dart';
import 'inventory_ui_utils.dart';

class InventoryDashboardSection extends StatelessWidget {
  const InventoryDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<InventoryDashboardCubit>().initialize();
        await context.read<InventoryStockCubit>().refreshGlobal();
      },
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          BlocBuilder<InventoryDashboardCubit, InventoryDashboardState>(
            builder: (context, state) {
              final summary = state.todaySummary;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Venta global del dia'),
                            const SizedBox(height: 8),
                            Text(
                              summary == null
                                  ? 'S/ 0.00'
                                  : formatCurrency(summary.totalAmount),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (summary != null)
                              Text('Fecha: ${formatDate(summary.date)}'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            context.read<InventoryDashboardCubit>().initialize(),
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Inventario global',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          BlocBuilder<InventoryStockCubit, InventoryStockState>(
            builder: (context, state) {
              if (state.isLoading && state.stocks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.stocks.isEmpty) {
                return const Text('No hay inventario registrado.');
              }
              return Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Producto')),
                      DataColumn(label: Text('Ubicacion')),
                      DataColumn(label: Text('Cantidad')),
                    ],
                    rows: state.stocks
                        .map(
                          (stock) => DataRow(
                            cells: [
                              DataCell(Text(stock.productName)),
                              DataCell(Text(stock.locationName ?? 'Global')),
                              DataCell(Text(stock.quantityOnHand
                                  .toStringAsFixed(2))),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}




