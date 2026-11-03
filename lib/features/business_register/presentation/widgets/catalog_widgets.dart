import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../bloc/catalog_cubit.dart';

/// Pieces shared by the owner's product/service list and offer list.

/// `listenWhen` for [showCatalogFeedback].
bool catalogFeedbackChanged(CatalogState previous, CatalogState current) =>
    (current.error != null && previous.error != current.error) ||
    (current.message != null && previous.message != current.message);

/// Shows the cubit's latest error or success notice as a snackbar.
void showCatalogFeedback(BuildContext context, CatalogState state) {
  final text = state.error ?? state.message;
  if (text == null) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(text)));
}

/// Red-button confirmation dialog; resolves to true when confirmed.
Future<bool> confirmDestructive(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Eliminar',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed == true;
}

class CatalogAction {
  const CatalogAction(
    this.label,
    this.icon,
    this.onSelected, {
    this.destructive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onSelected;
  final bool destructive;
}

/// Row card: thumbnail, title, subtitle, optional status chip and a ⋮ menu.
class CatalogTile extends StatelessWidget {
  const CatalogTile({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    required this.actions,
    required this.onTap,
    this.detail,
    this.badge,
    this.dimmed = false,
    this.isBusy = false,
  });

  final String? imageUrl;
  final IconData fallbackIcon;
  final String title;
  final String subtitle;
  final String? detail;
  final Widget? badge;
  final bool dimmed;
  final bool isBusy;
  final VoidCallback? onTap;
  final List<CatalogAction> actions;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final placeholder = ColoredBox(
      color: context.palette.mutedFill,
      child: Icon(fallbackIcon, color: AppColors.purple),
    );
    return Material(
      color: context.palette.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: isBusy ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.palette.border),
          ),
          child: Opacity(
            opacity: dimmed ? 0.55 : 1,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: url == null
                        ? placeholder
                        : Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => placeholder,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.palette.textSecondary,
                        ),
                      ),
                      if (detail != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          detail!,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.palette.textTertiary,
                          ),
                        ),
                      ],
                      if (badge != null) ...[const SizedBox(height: 6), badge!],
                    ],
                  ),
                ),
                if (isBusy)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  PopupMenuButton<CatalogAction>(
                    tooltip: 'Opciones',
                    onSelected: (action) => action.onSelected(),
                    itemBuilder: (_) => [
                      for (final action in actions)
                        PopupMenuItem(
                          value: action,
                          child: Row(
                            children: [
                              Icon(
                                action.icon,
                                size: 20,
                                color: action.destructive
                                    ? Colors.redAccent
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                action.label,
                                style: TextStyle(
                                  color: action.destructive
                                      ? Colors.redAccent
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class CatalogEmptyState extends StatelessWidget {
  const CatalogEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 56, color: context.palette.textMuted),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.palette.textSecondary),
          ),
        ],
      ),
    );
  }
}
