import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../reviews/presentation/bloc/review_list_cubit.dart';

/// Bottom sheet to create or edit the signed-in user's review.
///
/// Expects a [ReviewListCubit] to be provided above it.
class SubmitReviewSheet extends StatefulWidget {
  const SubmitReviewSheet({
    super.key,
    this.initialRating = 0,
    this.initialComment = '',
    this.isEditing = false,
  });

  final int initialRating;
  final String initialComment;
  final bool isEditing;

  @override
  State<SubmitReviewSheet> createState() => _SubmitReviewSheetState();
}

class _SubmitReviewSheetState extends State<SubmitReviewSheet> {
  late int _rating = widget.initialRating;
  late final TextEditingController _comment = TextEditingController(
    text: widget.initialComment,
  );

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await context.read<ReviewListCubit>().submit(
      rating: _rating,
      comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('¡Gracias por tu opinión!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.isEditing ? 'Editar opinión' : 'Escribir opinión',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final value = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = value),
                icon: Icon(
                  value <= _rating ? Icons.star : Icons.star_border,
                  color: AppColors.star,
                  size: 36,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _comment,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Cuéntanos tu experiencia (opcional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<ReviewListCubit, ReviewListState>(
            buildWhen: (a, b) => a.error != b.error,
            builder: (context, state) {
              final error = state.error;
              if (error == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        error,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          BlocBuilder<ReviewListCubit, ReviewListState>(
            buildWhen: (a, b) => a.isSubmitting != b.isSubmitting,
            builder: (context, state) {
              final canSubmit = _rating > 0 && !state.isSubmitting;
              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canSubmit ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(widget.isEditing ? 'Actualizar' : 'Publicar'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
