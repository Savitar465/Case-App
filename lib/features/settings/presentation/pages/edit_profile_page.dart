import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/account_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../bloc/edit_profile_cubit.dart';
import '../widgets/settings_widgets.dart';
import 'change_email_page.dart';

/// "Editar perfil": photo, name, username and phone, plus the entry to change
/// the email.
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
        listener: (context, state) async {
          if (state.saved) {
            // Let the green "Cambios guardados" button register before leaving.
            await Future<void>.delayed(const Duration(milliseconds: 900));
            if (context.mounted) Navigator.of(context).pop(true);
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
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;

  /// Local photo picked in this session; uploaded only when saving.
  String? _avatarPath;
  bool _isDirty = false;

  static final _usernamePattern = RegExp(r'^[a-z0-9._]{3,30}$');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.settings.fullName)
      ..addListener(_updateDirty);
    _usernameController = TextEditingController(text: widget.settings.username)
      ..addListener(_updateDirty);
    _phoneController = TextEditingController(text: widget.settings.phone)
      ..addListener(_updateDirty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Compares against the loaded values, so typing a field back to its
  /// original value no longer counts as a pending change.
  void _updateDirty() {
    final settings = widget.settings;
    final dirty =
        _avatarPath != null ||
        _nameController.text.trim() != settings.fullName.trim() ||
        _usernameController.text.trim() != (settings.username ?? '') ||
        _phoneController.text.trim() != (settings.phone ?? '').trim();
    if (dirty != _isDirty) setState(() => _isDirty = dirty);
  }

  Future<void> _pickAvatar() async {
    FocusScope.of(context).unfocus();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.purple,
              ),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.purple,
              ),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (picked == null || !mounted) return;
      setState(() => _avatarPath = picked.path);
      _updateDirty();
    } catch (_) {
      if (!mounted) return;
      showSettingsSnackBar(context, 'No se pudo abrir la imagen');
    }
  }

  Future<void> _confirmExit() async {
    FocusScope.of(context).unfocus();
    final choice = await showDialog<_ExitChoice>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Guardar cambios?'),
        content: const Text(
          'Tienes cambios sin guardar en tu perfil. '
          '¿Deseas guardarlos antes de salir?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_ExitChoice.discard),
            child: const Text('Descartar'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_ExitChoice.cancel),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(_ExitChoice.save),
            style: FilledButton.styleFrom(backgroundColor: AppColors.purple),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    switch (choice) {
      case _ExitChoice.save:
        // On success the page listener pops; on a validation error we stay.
        _save();
      case _ExitChoice.discard:
        // Navigator.pop bypasses the PopScope guard below.
        Navigator.of(context).pop();
      case _ExitChoice.cancel:
      case null:
        break;
    }
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = _phoneController.text.trim();
    context.read<EditProfileCubit>().save(
      fullName: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      phone: phone.isEmpty ? null : phone,
      avatarFilePath: _avatarPath,
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

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return 'Ingresa un nombre de usuario';
    if (username.length < 3) return 'Debe tener al menos 3 caracteres';
    if (!_usernamePattern.hasMatch(username)) {
      return 'Usa solo letras, números, punto o guion bajo';
    }
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
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            _AvatarPicker(
              localPath: _avatarPath,
              remoteUrl: widget.settings.avatarUrl,
              initial: widget.settings.fullName,
              onTap: _pickAvatar,
            ),
            const SizedBox(height: 24),
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
              icon: Icons.sell_outlined,
              label: 'Nombre de usuario',
              hintText: 'tu_usuario',
              prefixText: '@',
              controller: _usernameController,
              keyboardType: TextInputType.visiblePassword,
              validator: _validateUsername,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
                _LowercaseFormatter(),
                FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9._]')),
              ],
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
            BlocSelector<
              EditProfileCubit,
              EditProfileState,
              ({bool isSaving, bool saved})
            >(
              selector: (state) =>
                  (isSaving: state.isSaving, saved: state.saved),
              builder: (context, status) => status.saved
                  ? SettingsPrimaryButton(
                      label: 'Cambios guardados',
                      icon: Icons.check_circle,
                      color: AppColors.badgeGreen,
                      // Already saved; the page pops on its own.
                      onPressed: () {},
                    )
                  : SettingsPrimaryButton(
                      label: 'Guardar cambios',
                      icon: Icons.save_outlined,
                      isLoading: status.isSaving,
                      onPressed: _save,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ExitChoice { save, discard, cancel }

/// Lowercases as the user types; usernames are stored lowercase.
class _LowercaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}

/// Round photo with a camera badge and the "Toca la foto para cambiarla"
/// caption. Shows the freshly picked file first, then the saved photo, then
/// the name's initial.
class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({
    required this.localPath,
    required this.remoteUrl,
    required this.initial,
    required this.onTap,
  });

  final String? localPath;
  final String? remoteUrl;
  final String initial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ImageProvider? image = localPath != null
        ? FileImage(File(localPath!))
        : remoteUrl != null
        ? NetworkImage(remoteUrl!)
        : null;
    final letter = initial.trim().isEmpty
        ? '?'
        : initial.trim()[0].toUpperCase();
    return Column(
      children: [
        Semantics(
          button: true,
          label: 'Cambiar foto de perfil',
          child: GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: const Color(0xFFBFE3FF),
                  foregroundImage: image,
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.palette.page, width: 2),
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Toca la foto para cambiarla',
          style: TextStyle(color: context.palette.textSecondary),
        ),
      ],
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
    this.prefixText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.inputFormatters,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

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
        inputFormatters: inputFormatters,
        autocorrect: inputFormatters == null,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixText: prefixText,
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
