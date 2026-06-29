import 'package:flutter/material.dart';

import '../widgets/register_widgets.dart';
import 'business_register_wizard_page.dart';

/// Value-proposition entry screen for business registration (design img.png).
class RegisterIntroPage extends StatelessWidget {
  const RegisterIntroPage({super.key});

  static const String routeName = '/register-business';

  Future<void> _start(BuildContext context) async {
    final navigator = Navigator.of(context);
    // Push (don't replace) so the wizard's result bubbles up: when it pops
    // `true` after publishing, we forward that to the Profile screen, which
    // reloads and shows the new business immediately.
    final created = await navigator.push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const BusinessRegisterWizardPage(),
      ),
    );
    navigator.pop(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepTitle('Consigue más clientes\ncerca de ti'),
              const SizedBox(height: 18),
              const StepSubtitle('Muestra tus productos, servicios y ofertas'),
              const SizedBox(height: 36),
              const _Benefit(
                icon: Icons.location_on,
                color: Colors.deepOrange,
                text: 'Haz visible tu negocio',
              ),
              const _Benefit(
                icon: Icons.chat_bubble_outline,
                color: Colors.black87,
                text: 'Conecta con clientes por WhatsApp y redes',
              ),
              const _Benefit(
                icon: Icons.photo_camera,
                color: Color(0xFFF5A623),
                text: 'Muestra lo que ofreces',
              ),
              const _Benefit(
                icon: Icons.local_fire_department,
                color: Colors.redAccent,
                text: 'Aumenta tus ventas con ofertas',
              ),
              const SizedBox(height: 12),
              WizardPrimaryButton(
                label: 'Registrar mi negocio',
                onPressed: () => _start(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18, height: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
