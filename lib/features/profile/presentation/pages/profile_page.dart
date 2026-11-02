import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../business/domain/repositories/business_repository.dart';
import '../../../business/presentation/pages/business_profile_page.dart';
import '../../../business_register/presentation/pages/register_intro_page.dart';
import '../../../plans/presentation/pages/boost_business_page.dart';
import '../../../settings/presentation/pages/edit_profile_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../domain/entities/profile_business.dart';
import '../../domain/entities/profile_overview.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/profile_widgets.dart';
import 'business_management_page.dart';
import 'my_businesses_page.dart';

/// "Mi perfil" tab with "Mi Perfil" and "Mi Negocio" tabs.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileCubit(repository: context.read<ProfileRepository>())..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  int _selectedTabIndex = 0;

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text('$feature estará disponible pronto')),
      );
  }

  void _openMenu(BuildContext context, ProfileUser user) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _openSettings(context, user);
                },
              ),
              if (user.isGuest)
                ListTile(
                  leading: const Icon(Icons.login, color: AppColors.purple),
                  title: const Text('Iniciar sesión'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).pushNamed(LoginPage.routeName);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.read<AuthBloc>().add(const LogoutRequested());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPage.routeName,
                      (route) => false,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _openSettings(BuildContext context, ProfileUser user) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: SettingsPage.routeName),
        builder: (_) => SettingsPage(
          isGuest: user.isGuest,
          onOpenBusinesses: () => _openMyBusinesses(context),
        ),
      ),
    );
  }

  Future<void> _openEditProfile(BuildContext context, ProfileUser user) async {
    if (user.isGuest) {
      Navigator.of(context).pushNamed(LoginPage.routeName);
      return;
    }
    final cubit = context.read<ProfileCubit>();
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        settings: const RouteSettings(name: EditProfilePage.routeName),
        builder: (_) => const EditProfilePage(),
      ),
    );
    if (updated == true) cubit.load();
  }

  void _openMyBusinesses(BuildContext context) {
    final owned = context.read<ProfileCubit>().state.overview?.owned ?? [];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: MyBusinessesPage.routeName),
        builder: (_) => MyBusinessesPage(
          businesses: owned,
          onOpen: (business) => _openManagement(context, business),
          onCreate: () => _openRegister(context),
        ),
      ),
    );
  }

  void _openManagement(BuildContext context, ProfileBusiness business) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BusinessManagementPage(business: business),
      ),
    );
  }

  Future<void> _openBusinessProfile(
    BuildContext context,
    ProfileBusiness business,
  ) async {
    final repository = context.read<BusinessRepository>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final fullBusiness = await repository.getBusiness(business.id);
      if (fullBusiness != null && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BusinessProfilePage(business: fullBusiness),
          ),
        );
      } else if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el perfil del negocio'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Error al abrir el perfil del negocio')),
        );
      }
    }
  }

  Future<void> _openBoost(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final boosted = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        settings: const RouteSettings(name: BoostBusinessPage.routeName),
        builder: (_) => const BoostBusinessPage(),
      ),
    );
    if (boosted == true) {
      cubit.load();
    }
  }

  Future<void> _openRegister(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const RegisterIntroPage()),
    );
    if (created == true) cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.page,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading || state.status == ProfileStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ProfileStatus.error) {
              return _ErrorView(
                message: state.error ?? 'No se pudo cargar tu perfil',
                onRetry: () => context.read<ProfileCubit>().load(),
              );
            }

            final overview = state.overview!;
            return RefreshIndicator(
              onRefresh: () => context.read<ProfileCubit>().load(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  _TopBar(onMenu: () => _openMenu(context, overview.user)),
                  const SizedBox(height: 16),
                  ProfileHeader(
                    user: overview.user,
                    onEdit: () => _openEditProfile(context, overview.user),
                  ),
                  const SizedBox(height: 20),
                  ProfileSegmentedTabs(
                    selectedIndex: _selectedTabIndex,
                    onChanged: (index) =>
                        setState(() => _selectedTabIndex = index),
                  ),
                  const SizedBox(height: 22),
                  if (_selectedTabIndex == 0) ...[
                    _FollowedSection(
                      businesses: overview.followed,
                      onSeeAll: () =>
                          _comingSoon(context, 'Ver todos los negocios'),
                      onUnfollow: (id) =>
                          context.read<ProfileCubit>().unfollow(id),
                    ),
                  ] else ...[
                    _BusinessTabView(
                      overview: overview,
                      onEdit: (business) => _openManagement(context, business),
                      onView: (business) =>
                          _openBusinessProfile(context, business),
                      onBoost: () => _openBoost(context),
                      onCreate: () => _openRegister(context),
                      onSeeAll: () => _openMyBusinesses(context),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onMenu});

  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mi perfil',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        IconButton(
          onPressed: onMenu,
          icon: const Icon(Icons.menu),
          color: AppColors.purple,
        ),
      ],
    );
  }
}

class _BusinessTabView extends StatelessWidget {
  const _BusinessTabView({
    required this.overview,
    required this.onEdit,
    required this.onView,
    required this.onBoost,
    required this.onCreate,
    required this.onSeeAll,
  });

  final ProfileOverview overview;
  final ValueChanged<ProfileBusiness> onEdit;
  final ValueChanged<ProfileBusiness> onView;
  final VoidCallback onBoost;
  final VoidCallback onCreate;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (!overview.hasBusinesses) {
      return Column(
        children: [
          RegisterBusinessPromo(onRegister: onCreate),
          const SizedBox(height: 16),
          BoostPromo(onActivate: onBoost),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final business in overview.owned) ...[
          OwnedBusinessDetailCard(
            business: business,
            onEdit: () => onEdit(business),
            onView: () => onView(business),
          ),
          const SizedBox(height: 14),
        ],
        BoostPromo(onActivate: onBoost),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: CreateBusinessButton(onPressed: onCreate)),
            if (overview.owned.length > 1) ...[
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onSeeAll,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Ver todos'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _FollowedSection extends StatelessWidget {
  const _FollowedSection({
    required this.businesses,
    required this.onSeeAll,
    required this.onUnfollow,
  });

  final List<ProfileBusiness> businesses;
  final VoidCallback onSeeAll;
  final ValueChanged<String> onUnfollow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Negocios que sigues',
          actionLabel: businesses.isEmpty ? null : 'Ver todos',
          onAction: onSeeAll,
        ),
        const SizedBox(height: 12),
        if (businesses.isEmpty)
          const EmptyHint(
            icon: Icons.favorite_border,
            message: 'Aún no sigues ningún negocio.',
          )
        else
          SizedBox(
            height: 196,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: businesses.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (_, index) => FollowedBusinessCard(
                business: businesses[index],
                onUnfollow: () => onUnfollow(businesses[index].id),
              ),
            ),
          ),
      ],
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
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: AppColors.purple),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
