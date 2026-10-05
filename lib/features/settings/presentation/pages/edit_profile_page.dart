import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/account_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../bloc/edit_profile_cubit.dart';
import '../widgets/settings_widgets.dart';
import 'change_email_page.dart';

/// "Editar perfil": name and phone, plus the entry to change the email.
/// Pops `true` after a successful save so the caller can reload.
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static const routeName = '/settings/edit-profile';

  @override
  Widget build(BuildContext context) {
    final repository = context.read<SettingsRepository>();
    return BlocProvider(
      create: (_) => EditProfileCubit(
        loadSettings: LoadAccountSettingsUseCase(repository),
        updateProfile: UpdateProfileUseCase(repository),
      )..load(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Editar perfil',
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listenWhen: (prev, curr) =>
            (curr.saved && !prev.saved) ||
            (curr.error != null && curr.error != prev.error),
        listener: (context, state) {
          if (state.saved) {
            showSettingsSnackBar(context, 'Perfil actualizado');
            Navigator.of(context).pop(true);
          } else if (state.settings != null) {
            // Load errors render inline; only save errors need a snackbar.
            showSettingsSnackBar(context, state.error!);
          }
        },
        buildWhen: (prev, curr) =>
            prev.isLoading != curr.isLoading ||
            (prev.settings == null) != (curr.settings == null),
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final settings = state.settings;
          if (settings == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.error ?? 'No se pudo cargar tu información',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return _EditProfileForm(settings: settings);
        },
      ),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm({required this.settings});

  final AccountSettings settings;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.settings.fullName);
    _phoneController = TextEditingController(text: widget.settings.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = _phoneController.text.trim();
    context.read<EditProfileCubit>().save(
      fullName: _nameController.text.trim(),
      phone: phone.isEmpty ? null : phone,
    );
  }

  Future<void> _openEmail(String currentEmail) async {
    final cubit = context.read<EditProfileCubit>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: ChangeEmailPage.routeName),
        builder: (_) => ChangeEmailPage(currentEmail: currentEmail),
      ),
    );
    cubit.refreshEmail();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Ingresa tu nombre';
    if (name.length < 2) return 'El nombre es demasiado corto';
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null;
    if (!RegExp(r'^\+?[0-9 ()-]+$').hasMatch(phone)) {
      return 'Usa solo números, espacios o +';
    }
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Ingresa un número válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Text(
            'Actualiza tu información personal',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.palette.textSecondary),
          ),
          const SizedBox(height: 20),
          _EditableFieldCard(
            icon: Icons.person_outline,
            label: 'Nombre completo',
            controller: _nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: _validateName,
          ),
          const SizedBox(height: 12),
          _EditableFieldCard(
            icon: Icons.phone_outlined,
            label: 'Número telefónico',
            hintText: 'Agrega tu número',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
          ),
          const SizedBox(height: 12),
          BlocSelector<EditProfileCubit, EditProfileState, String>(
            selector: (state) => state.settings?.email ?? '',
            builder: (context, email) =>
                _EmailCard(email: email, onTap: () => _openEmail(email)),
          ),
          const SizedBox(height: 20),
          const SettingsInfoCard(
            icon: Icons.verified_user_outlined,
            title: 'Tu información está segura',
            message:
                'Solo usamos tus datos para mejorar tu experiencia. '
                'No los compartimos con terceros.',
          ),
          const SizedBox(height: 24),
          BlocSelector<EditProfileCubit, EditProfileState, bool>(
            selector: (state) => state.isSaving,
            builder: (context, isSaving) => SettingsPrimaryButton(
              label: 'Guardar cambios',
              icon: Icons.save_outlined,
              isLoading: isSaving,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bordered card with an icon, a small label and an inline text field, as in
/// the "Editar perfil" mockup.
class _EditableFieldCard extends StatelessWidget {
  const _EditableFieldCard({
    required this.icon,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return _FieldCardFrame(
      icon: icon,
      trailing: const Icon(Icons.edit, color: AppColors.purple, size: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: TextStyle(
            color: context.palette.textMuted,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(color: context.palette.textSecondary),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
        ),
      ),
    );
  }
}

class _EmailCard extends StatelessWidget {
  const _EmailCard({required this.email, required this.onTap});

  final String email;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: _FieldCardFrame(
        icon: Icons.mail_outline,
        trailing: Icon(Icons.chevron_right, color: context.palette.textMuted),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-mail',
                style: TextStyle(
                  fontSize: 12,
                  color: context.palette.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldCardFrame extends StatelessWidget {
  const _FieldCardFrame({
    required this.icon,
    required this.child,
    required this.trailing,
  });

  final IconData icon;
  final Widget child;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.purple),
          const SizedBox(width: 12),
          Expanded(child: child),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}
