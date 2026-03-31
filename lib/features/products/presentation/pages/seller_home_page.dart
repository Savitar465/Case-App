import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:market_app/features/inventory/domain/entities/employee.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_location.dart';
import 'package:market_app/features/products/domain/entities/product_failure.dart';
import 'package:market_app/features/products/domain/entities/seller.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';
import 'package:market_app/features/products/presentation/bloc/product_editor_cubit.dart';
import 'package:market_app/features/products/presentation/bloc/seller_inventory_cubit.dart';
import 'package:market_app/features/products/presentation/pages/market_home_page.dart';
import 'package:market_app/features/products/presentation/pages/seller_products_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({super.key, required this.session});

  final AuthSession session;

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  Seller? _seller;
  bool _isLoadingSeller = true;
  String? _loadError;
  Employee? _employee;
  InventoryLocation? _inventoryLocation;
  String? _contextError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveSeller();
    });
  }

  Future<void> _resolveSeller() async {
    final repository = context.read<ProductRepository>();
    final user = widget.session.user;

    setState(() {
      _isLoadingSeller = true;
      _loadError = null;
      _employee = null;
      _inventoryLocation = null;
      _contextError = null;
    });

    try {
      Seller? seller = await repository.loadSellerForUser(user.id);
      seller ??= await repository.refreshSellerForUser(user.id);
      if (seller == null && user.sellerId != null) {
        seller = Seller(
          id: user.sellerId!,
          userId: user.id,
          storeName: user.displayName ?? user.email,
        );
      }

      final inventoryContext = await _loadInventoryContext(authUserId: user.id);

      if (!mounted) {
        return;
      }
      if (seller == null) {
        setState(() {
          _seller = null;
          _isLoadingSeller = false;
          _loadError =
              'No seller profile found. Ask an administrator to create one.';
          _employee = inventoryContext.employee;
          _inventoryLocation = inventoryContext.location;
          _contextError = inventoryContext.error;
        });
        return;
      }
      setState(() {
        _seller = seller;
        _isLoadingSeller = false;
        _employee = inventoryContext.employee;
        _inventoryLocation = inventoryContext.location;
        _contextError = inventoryContext.error;
      });

      if (inventoryContext.error != null && mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'No se pudo cargar la ubicacion de inventario: ${inventoryContext.error}',
              ),
            ),
          );
      }
    } on ProductFailure catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _seller = null;
        _isLoadingSeller = false;
        _loadError = error.message;
        _employee = null;
        _inventoryLocation = null;
        _contextError = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _seller = null;
        _isLoadingSeller = false;
        _loadError = error.toString();
        _employee = null;
        _inventoryLocation = null;
        _contextError = null;
      });
    }
  }

  Future<({Employee? employee, InventoryLocation? location, String? error})>
  _loadInventoryContext({required String authUserId}) async {
    final supabase = Supabase.instance.client;
    try {
      final dynamic employeeResponse = await supabase
          .schema('market')
          .from('employees')
          .select()
          .eq('auth_user_id', authUserId)
          .maybeSingle();

      if (employeeResponse == null) {
        return (employee: null, location: null, error: null);
      }

      final employeeMap = Map<String, dynamic>.from(employeeResponse as Map);
      final employee = _mapEmployee(employeeMap);

      InventoryLocation? location;
      final locationId = employee.locationId;
      if (locationId != null && locationId.isNotEmpty) {
        final dynamic locationResponse = await supabase
            .schema('market')
            .from('inventory_locations')
            .select()
            .eq('id', locationId)
            .maybeSingle();

        if (locationResponse != null) {
          location = _mapLocation(
            Map<String, dynamic>.from(locationResponse as Map),
            fallbackId: locationId,
          );
        }
      }

      return (employee: employee, location: location, error: null);
    } on PostgrestException catch (error) {
      return (employee: null, location: null, error: error.message);
    } catch (error) {
      return (employee: null, location: null, error: error.toString());
    }
  }

  Employee _mapEmployee(Map<String, dynamic> data) {
    final authUserId = _stringOrNull(data['auth_user_id']);
    final id = _stringOrNull(data['id']) ?? authUserId ?? '';
    final primaryName = _stringOrNull(data['first_name']);
    final fallbackName = _stringOrNull(data['last_name']);
    final firstName = (primaryName == null || primaryName.isEmpty)
        ? (fallbackName ?? 'Colaborador')
        : primaryName;

    final role = _stringOrNull(data['role']) ?? 'seller';

    return Employee(
      id: id,
      firstName: firstName,
      lastName: fallbackName,
      email: _stringOrNull(data['email']),
      phone: _stringOrNull(data['phone']),
      authUserId: authUserId,
      role: role,
      locationId: _stringOrNull(data['location_id']),
      locationType: _stringOrNull(data['location_type']),
      isActive: _parseBool(data['is_active'], fallback: true),
      hiredAt: _parseDate(data['hired_at']),
      createdAt: _parseDate(data['created_at']),
      updatedAt: _parseDate(data['updated_at']),
      syncedAt: _parseDate(data['synced_at']),
    );
  }

  InventoryLocation _mapLocation(
    Map<String, dynamic> data, {
    required String fallbackId,
  }) {
    final typeLabel = _stringOrNull(data['type']) ?? 'store';
    return InventoryLocation(
      id: _stringOrNull(data['id']) ?? fallbackId,
      type: InventoryLocationTypeX.fromLabel(typeLabel),
      name: _stringOrNull(data['name']) ?? 'Ubicacion',
      code: _stringOrNull(data['code']),
      description: _stringOrNull(data['description']),
      address: _stringOrNull(data['address']),
      phone: _stringOrNull(data['phone']),
      managerId: _stringOrNull(data['manager_id']),
      isActive: _parseBool(data['is_active'], fallback: true),
      createdAt: _parseDate(data['created_at']),
      updatedAt: _parseDate(data['updated_at']),
      syncedAt: _parseDate(data['synced_at']),
    );
  }

  String? _stringOrNull(dynamic value) {
    if (value == null) {
      return null;
    }
    final stringValue = value.toString().trim();
    return stringValue.isEmpty ? null : stringValue;
  }

  bool _parseBool(dynamic value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == 't' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == 'f' || normalized == '0') {
        return false;
      }
    }
    return fallback;
  }

  DateTime? _parseDate(dynamic value) {
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toUtc();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingSeller) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_seller == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Seller workspace')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.store_mall_directory_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  _loadError ?? 'Seller profile unavailable.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _resolveSeller,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
                IconButton(
                  tooltip: 'Cerrar sesion',
                  onPressed: () =>
                      context.read<AuthBloc>().add(const LogoutRequested()),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final seller = _seller!;
    final repository = context.read<ProductRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<SellerInventoryCubit>(
          create: (_) =>
              SellerInventoryCubit(supabase: Supabase.instance.client),
        ),
        BlocProvider<ProductEditorCubit>(
          create: (_) =>
              ProductEditorCubit(repository: repository, sellerId: seller.id),
        ),
      ],
      child: _SellerHomeShell(
        session: widget.session,
        seller: seller,
        onReloadSeller: _resolveSeller,
        employee: _employee,
        location: _inventoryLocation,
        contextError: _contextError,
      ),
    );
  }
}

class _SellerHomeShell extends StatefulWidget {
  const _SellerHomeShell({
    required this.session,
    required this.seller,
    required this.onReloadSeller,
    this.employee,
    this.location,
    this.contextError,
  });

  final AuthSession session;
  final Seller seller;
  final VoidCallback onReloadSeller;
  final Employee? employee;
  final InventoryLocation? location;
  final String? contextError;

  @override
  State<_SellerHomeShell> createState() => _SellerHomeShellState();
}

class _SellerHomeShellState extends State<_SellerHomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      SellerProductsPage(
        session: widget.session,
        seller: widget.seller,
        onReloadSeller: widget.onReloadSeller,
        employee: widget.employee,
        location: widget.location,
        contextError: widget.contextError,
      ),
      const MarketHomePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            label: 'My catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Marketplace',
          ),
        ],
        onDestinationSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}
