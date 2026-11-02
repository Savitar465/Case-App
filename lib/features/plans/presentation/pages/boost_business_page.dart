import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/plan.dart';
import '../../domain/repositories/plans_repository.dart';
import '../../domain/usecases/get_plans_use_case.dart';
import '../bloc/plans_cubit.dart';

class BoostBusinessPage extends StatelessWidget {
  const BoostBusinessPage({super.key});

  static const routeName = '/boost-business';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlansCubit(
        getPlans: GetPlansUseCase(context.read<PlansRepository>()),
      )..loadPlans(),
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
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Has seleccionado el plan ${selectedPlan.name} (${selectedPlan.price.toInt()} Bs). ¡Pronto podrás completar tu suscripción!',
          ),
          backgroundColor: AppColors.purple,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<PlansCubit, PlansState>(
          builder: (context, state) {
            return Column(
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
            );
          },
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
                    padding: const EdgeInsets.only(left: 54, right: 8, bottom: 6),
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

