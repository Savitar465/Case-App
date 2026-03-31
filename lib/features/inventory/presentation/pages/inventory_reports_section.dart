import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/inventory_report.dart';
import '../bloc/locations_cubit.dart';
import '../bloc/reports_cubit.dart';
import 'inventory_ui_utils.dart';

class InventoryReportsSection extends StatelessWidget {
  const InventoryReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryReportsCubit, InventoryReportsState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ReportCard<SalesReportEntry>(
              title: 'Ventas por tienda',
              entries: state.sales,
              builder: (entry) => ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: Text(entry.storeName),
                subtitle: Text(formatDate(entry.saleDate)),
                trailing: Text(formatCurrency(entry.totalAmount)),
              ),
              onFilter: () => _showFilterDialog(
                context,
                onChanged: (filter) =>
                    context.read<InventoryReportsCubit>().updateSalesFilter(filter),
              ),
            ),
            const SizedBox(height: 16),
            _ReportCard<PurchaseReportEntry>(
              title: 'Compras por ubicacion',
              entries: state.purchases,
              builder: (entry) => ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(entry.locationName),
                subtitle: Text(formatDate(entry.purchaseDate)),
                trailing: Text(formatCurrency(entry.totalCost)),
              ),
              onFilter: () => _showFilterDialog(
                context,
                onChanged: (filter) => context
                    .read<InventoryReportsCubit>()
                    .updatePurchaseFilter(filter),
              ),
            ),
            const SizedBox(height: 16),
            _ReportCard<TransferReportEntry>(
              title: 'Transferencias',
              entries: state.transfers,
              builder: (entry) => ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: Text('${entry.originName} ? ${entry.destinationName}'),
                subtitle: Text(formatDate(entry.transferDate)),
                trailing: Text('${entry.productCount} productos'),
              ),
              onFilter: () => _showFilterDialog(
                context,
                onChanged: (filter) => context
                    .read<InventoryReportsCubit>()
                    .updateTransferFilter(filter),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReportCard<T> extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.entries,
    required this.builder,
    required this.onFilter,
  });

  final String title;
  final List<T> entries;
  final Widget Function(T entry) builder;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: onFilter,
                  icon: const Icon(Icons.filter_alt_outlined),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              const Text('No hay registros para mostrar.')
            else
              ...entries.map(builder),
          ],
        ),
      ),
    );
  }
}

Future<void> _showFilterDialog(
  BuildContext context, {
  required ValueChanged<ReportsFilter> onChanged,
}) async {
  final locationsState = context.read<LocationsCubit>().state;
  final options = [
    ...locationsState.stores,
    ...locationsState.warehouses,
  ];
  String? locationId;
  DateTimeRange? range;

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filtrar reportes'),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: locationId,
                    decoration: const InputDecoration(labelText: 'Ubicacion'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ...options.map(
                        (location) => DropdownMenuItem(
                          value: location.id,
                          child: Text(location.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      locationId = value;
                    }),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          range == null
                              ? 'Sin rango seleccionado'
                              : '${formatDate(range!.start)} - ${formatDate(range!.end)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(DateTime.now().year + 5),
                            initialDateRange: range,
                          );
                          if (picked != null) {
                            setState(() => range = picked);
                          }
                        },
                        child: const Text('Elegir fechas'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  onChanged(
                    ReportsFilter(
                      locationId: locationId,
                      dateRange: range == null
                          ? null
                          : DateRange(start: range!.start, end: range!.end),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Aplicar'),
              ),
            ],
          );
        },
      );
    },
  );
}




