import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../business_register/presentation/pages/register_intro_page.dart';
import '../../domain/entities/profile_business.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/profile_widgets.dart';
import 'business_management_page.dart';

/// "Mi perfil" tab. Shows the user header, the businesses they follow and
/// either a "register a business" promo or their owned businesses.
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

class _ProfileView extends StatelessWidget {
  const _ProfileView();

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
                  _comingSoon(context, 'La configuración');
                },
              ),
              if (user.isGuest)
                ListTile(
                  leading: const Icon(Icons.login, color: AppColors.purple),
                  title: const Text('Iniciar sesión'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(
                      context,
                    ).pushNamed(LoginPage.routeName);
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

  void _openManagement(BuildContext context, ProfileBusiness business) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BusinessManagementPage(business: business),
      ),
    );
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
      backgroundColor: Colors.white,
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
                  _TopBar(
                    onMenu: () => _openMenu(context, overview.user),
                  ),
                  const SizedBox(height: 16),
                  ProfileHeader(
                    user: overview.user,
                    onEdit: () => _comingSoon(context, 'La edición de perfil'),
                  ),
                  const SizedBox(height: 28),
                  _FollowedSection(
                    businesses: overview.followed,
                    onSeeAll: () =>
                        _comingSoon(context, 'Ver todos los negocios'),
                    onUnfollow: (id) =>
                        context.read<ProfileCubit>().unfollow(id),
                  ),
                  const SizedBox(height: 28),
                  if (overview.hasBusinesses)
                    _OwnedSection(
                      businesses: overview.owned,
                      onSeeAll: () =>
                          _comingSoon(context, 'Ver todos tus negocios'),
                      onOpen: (business) => _openManagement(context, business),
                      onCreate: () => _openRegister(context),
                      onBoost: () => _comingSoon(context, 'Impulsar negocio'),
                    )
                  else
                    RegisterBusinessPromo(
                      onRegister: () => _openRegister(context),
                    ),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
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
              separatorBuilder: (_, _) => const SizedBox(width: 14),
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

class _OwnedSection extends StatelessWidget {
  const _OwnedSection({
    required this.businesses,
    required this.onSeeAll,
    required this.onOpen,
    required this.onCreate,
    required this.onBoost,
  });

  final List<ProfileBusiness> businesses;
  final VoidCallback onSeeAll;
  final ValueChanged<ProfileBusiness> onOpen;
  final VoidCallback onCreate;
  final VoidCallback onBoost;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Mis negocios',
          actionLabel: 'Ver todos',
          onAction: onSeeAll,
        ),
        const SizedBox(height: 12),
        for (final business in businesses) ...[
          OwnedBusinessRow(
            business: business,
            onTap: () => onOpen(business),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        CreateBusinessButton(onPressed: onCreate),
        const SizedBox(height: 16),
        BoostPromo(onActivate: onBoost),
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
