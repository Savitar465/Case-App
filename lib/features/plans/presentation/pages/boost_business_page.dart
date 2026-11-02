import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../business_register/presentation/pages/register_intro_page.dart';
import '../../domain/entities/plan.dart';
import '../../domain/entities/plan_business.dart';
import '../../domain/repositories/plans_repository.dart';
import '../../domain/usecases/get_my_businesses_use_case.dart';
import '../../domain/usecases/get_plans_use_case.dart';
import '../../domain/usecases/subscribe_business_use_case.dart';
import '../bloc/plans_cubit.dart';

class BoostBusinessPage extends StatelessWidget {
  const BoostBusinessPage({super.key, this.initialBusinessId});

  final String? initialBusinessId;

  static const routeName = '/boost-business';

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PlansRepository>();
    return BlocProvider(
      create: (context) => PlansCubit(
        getPlans: GetPlansUseCase(repo),
        getMyBusinesses: GetMyBusinessesUseCase(repo),
        subscribeBusiness: SubscribeBusinessUseCase(repo),
      )
        ..loadPlans()
        ..loadMyBusinesses(preselectedBusinessId: initialBusinessId),
      child: const _BoostBusinessView(),
    );
  }
}

class _BoostBusinessView extends StatefulWidget {
  const _BoostBusinessView();

  @override
  State<_BoostBusinessView> createState() => _BoostBusinessViewState();
}

class _BoostBusinessViewState extends State<_BoostBusinessView> {
  int? _expandedReasonIndex;

  void _toggleReason(int index) {
    setState(() {
      if (_expandedReasonIndex == index) {
        _expandedReasonIndex = null;
      } else {
        _expandedReasonIndex = index;
      }
    });
  }

  void _onContinue(BuildContext context, Plan? selectedPlan) {
    if (selectedPlan == null) return;

    context.read<PlansCubit>().loadMyBusinesses();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PlansCubit>(),
        child: _SelectBusinessSheet(selectedPlan: selectedPlan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlansCubit, PlansState>(
      listenWhen: (previous, current) =>
          previous.subscriptionSuccess != current.subscriptionSuccess ||
          (current.error != null && previous.error != current.error),
      listener: (context, state) {
        if (state.subscriptionSuccess) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.successMessage ?? '¡Suscripción exitosa!',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.purple,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          Navigator.of(context).pop(true);
        } else if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          context.read<PlansCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.palette.page,
          appBar: AppBar(
            backgroundColor: context.palette.page,
            elevation: 0,
            leading: IconButton(
              tooltip: 'Volver',
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: context.palette.textPrimary,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    children: [
                      const _VikusProBrandHeader(),
                      const SizedBox(height: 24),
                      Text(
                        '¿Por qué unirme a Pro?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: context.palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ReasonCard(
                        index: 0,
                        icon: Icons.storefront,
                        title: 'Perfil destacado',
                        description:
                            'Tu negocio aparecerá en los primeros lugares de búsqueda y en la sección destacada de la pantalla principal. Multiplica tu visibilidad frente a clientes cercanos listos para comprar.',
                        isExpanded: _expandedReasonIndex == 0,
                        onTap: () => _toggleReason(0),
                      ),
                      const SizedBox(height: 12),
                      _ReasonCard(
                        index: 1,
                        icon: Icons.local_offer,
                        title: 'Ofertas ilimitadas',
                        description:
                            'Publica todas las promociones, descuentos especiales y ofertas de temporada que desees sin restricciones. Llega a usuarios activos que buscan oportunidades de compra.',
                        isExpanded: _expandedReasonIndex == 1,
                        onTap: () => _toggleReason(1),
                      ),
                      const SizedBox(height: 12),
                      _ReasonCard(
                        index: 2,
                        icon: Icons.inventory_2_outlined,
                        title: 'Publica más productos y servicios',
                        description:
                            'Amplía tu catálogo sin límite de ítems. Exhibe fotos en alta calidad, descripciones detalladas, precios y categorías para que tus clientes conozcan todo lo que ofreces.',
                        isExpanded: _expandedReasonIndex == 2,
                        onTap: () => _toggleReason(2),
                      ),
                      const SizedBox(height: 24),
                      if (state.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else ...[
                        for (final plan in state.plans) ...[
                          _PlanCard(
                            plan: plan,
                            isSelected: state.selectedPlan?.id == plan.id,
                            onSelect: () =>
                                context.read<PlansCubit>().selectPlan(plan),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: state.selectedPlan != null
                          ? () => _onContinue(context, state.selectedPlan)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.purple.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectBusinessSheet extends StatelessWidget {
  const _SelectBusinessSheet({required this.selectedPlan});

  final Plan selectedPlan;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlansCubit, PlansState>(
      listener: (context, state) {
        if (state.subscriptionSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: context.palette.shadow,
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.palette.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.purple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.storefront,
                          color: AppColors.purple,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Elige tu negocio',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: context.palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Plan ${selectedPlan.name} · ${selectedPlan.price.toInt()} Bs/mes',
                              style: TextStyle(
                                fontSize: 13,
                                color: context.palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: context.palette.textMuted,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24),
                if (state.isLoadingBusinesses)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.purple),
                    ),
                  )
                else if (state.myBusinesses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.store_mall_directory_outlined,
                          size: 48,
                          color: context.palette.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No tienes negocios registrados',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Registra tu negocio para poder adquirir una suscripción ViKuS Pro y disfrutar de todos sus beneficios.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.palette.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(
                              RegisterIntroPage.routeName,
                            );
                          },
                          icon: const Icon(Icons.add_business, size: 18),
                          label: const Text('Registrar negocio'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecciona el negocio al que deseas activar el plan:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: context.palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 280),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.myBusinesses.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final business = state.myBusinesses[index];
                              final isSelected =
                                  state.selectedBusiness?.id == business.id;

                              return _BusinessChoiceTile(
                                business: business,
                                isSelected: isSelected,
                                onSelect: () => context
                                    .read<PlansCubit>()
                                    .selectBusiness(business),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: (state.selectedBusiness != null &&
                                    !state.isSubscribing)
                                ? () => context
                                    .read<PlansCubit>()
                                    .subscribeSelectedBusiness()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  AppColors.purple.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: 0,
                            ),
                            child: state.isSubscribing
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    state.selectedBusiness != null
                                        ? 'Activar ViKuS Pro para ${state.selectedBusiness!.name}'
                                        : 'Selecciona un negocio',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BusinessChoiceTile extends StatelessWidget {
  const _BusinessChoiceTile({
    required this.business,
    required this.isSelected,
    required this.onSelect,
  });

  final PlanBusiness business;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.purple.withValues(alpha: 0.08)
            : context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.purple : context.palette.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    color: AppColors.purple.withValues(alpha: 0.12),
                    child: business.imageUrl != null &&
                            business.imageUrl!.isNotEmpty
                        ? Image.network(
                            business.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.storefront,
                              color: AppColors.purple,
                              size: 22,
                            ),
                          )
                        : const Icon(
                            Icons.storefront,
                            color: AppColors.purple,
                            size: 22,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              business.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: context.palette.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (business.isPro) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.purple.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Pro Activo',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.purple,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (business.address.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          business.address,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.palette.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _CustomRadio(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VikusProBrandHeader extends StatelessWidget {
  const _VikusProBrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.purple,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.purple.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.storefront,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: context.palette.textPrimary,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(text: 'ViKuS '),
              TextSpan(
                text: 'Pro',
                style: TextStyle(color: AppColors.purple),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.description,
    required this.isExpanded,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final String title;
  final String description;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? AppColors.purple.withValues(alpha: 0.5)
              : context.palette.border,
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.purple.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.purple,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.palette.textPrimary,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right,
                        color: isExpanded
                            ? AppColors.purple
                            : context.palette.textMuted,
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 54, right: 8, bottom: 6),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  });

  final Plan plan;
  final bool isSelected;
  final VoidCallback onSelect;

  String _formatSubtitle(Plan plan) {
    final lower = plan.name.toLowerCase();
    final priceStr = plan.price.toInt().toString();
    if (lower.contains('mensual') || lower == 'mes') {
      return '$priceStr Bs/mes';
    } else if (lower.contains('trimestral') || lower.contains('3 meses')) {
      return '$priceStr Bs/3 meses';
    } else if (lower.contains('anual') || lower == 'año') {
      return '$priceStr Bs/Anual';
    }
    return '$priceStr Bs';
  }

  String? _badgeText(Plan plan) {
    final lower = plan.name.toLowerCase();
    if (lower.contains('mensual') || lower == 'mes') {
      return 'Más popular';
    } else if (lower.contains('trimestral')) {
      return 'Ahorra 7%';
    } else if (lower.contains('anual')) {
      return 'Ahorra 17%';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final badge = _badgeText(plan);
    final isPopular = badge == 'Más popular';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.purple.withValues(alpha: 0.08)
            : context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.purple : context.palette.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.purple.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          else
            BoxShadow(
              color: context.palette.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                _CustomRadio(isSelected: isSelected),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatSubtitle(plan),
                        style: TextStyle(
                          fontSize: 13,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isPopular
                          ? AppColors.purple
                          : AppColors.purple.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isPopular ? Colors.white : AppColors.purple,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomRadio extends StatelessWidget {
  const _CustomRadio({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.purple : context.palette.textMuted,
          width: 2,
        ),
        color: isSelected ? AppColors.purple : Colors.transparent,
      ),
      child: isSelected
          ? const Center(
              child: ContainerDot(),
            )
          : null,
    );
  }
}

class ContainerDot extends StatelessWidget {
  const ContainerDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
