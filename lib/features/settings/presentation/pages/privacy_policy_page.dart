import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../widgets/settings_widgets.dart';
import 'contact_support_page.dart';

/// Screen displaying the platform's Privacy Policy.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const routeName = '/settings/privacy';

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Política de privacidad',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const _HeaderCard(),
          const SizedBox(height: 20),
          const _Section(
            icon: Icons.shield_outlined,
            title: '1. Compromiso con tu privacidad',
            content:
                'Valoramos y respetamos tu privacidad. Esta política detalla '
                'de manera transparente qué datos recopilamos cuando usas '
                'nuestra plataforma, cómo los protegemos y para qué fines '
                'específicos son utilizados.',
          ),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.person_outline,
            title: '2. Información que recopilamos',
            content:
                '• Datos de cuenta: Nombre completo, correo electrónico y '
                'número telefónico cuando te registras o actualizas tu perfil.\n'
                '• Ubicación: Con tu autorización previa, recopilamos datos de '
                'geolocalización para mostrarte comercios, productos y ofertas '
                'cercanas a tu ubicación actual.\n'
                '• Información de comercios: Datos públicos del negocio como '
                'nombre, rubro, dirección, horarios de atención y fotos de catálogo.',
          ),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.track_changes_outlined,
            title: '3. Finalidad del tratamiento',
            content:
                'Utilizamos tu información con los siguientes propósitos:\n'
                '• Facilitar la búsqueda e interacción con negocios y productos locales.\n'
                '• Notificar sobre nuevas ofertas, promociones o mensajes según '
                'tus preferencias de notificación.\n'
                '• Gestionar solicitudes de atención y soporte técnico.\n'
                '• Prevenir fraudes y asegurar el correcto funcionamiento del servicio.',
          ),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.lock_outline,
            title: '4. Almacenamiento y seguridad',
            content:
                'Implementamos estándares de seguridad para proteger tus datos '
                'contra accesos no autorizados, pérdidas o alteraciones. El '
                'almacenamiento se realiza de forma segura en servidores '
                'certificados con comunicaciones cifradas en tránsito (HTTPS/TLS).',
          ),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.share_outlined,
            title: '5. Compartición de datos',
            content:
                'No vendemos, alquilamos ni comercializamos tus datos personales '
                'a terceros para fines publicitarios. Únicamente se comparte '
                'información imprescindible con proveedores técnicos de confianza '
                'que hacen posible la infraestructura y operación de la aplicación.',
          ),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.rule_folder_outlined,
            title: '6. Tus derechos',
            content:
                'Tienes derecho a acceder, rectificar o solicitar la eliminación '
                'de tus datos personales en cualquier momento desde la sección de '
                '"Editar perfil" o comunicándote con nuestro canal de soporte técnico.',
          ),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.notifications_active_outlined,
            title: '7. Control de notificaciones',
            content:
                'Puedes ajustar y desactivar en cualquier momento las alertas '
                'de nuevas ofertas, vencimientos o mensajes desde el menú '
                '"Notificaciones" en tus ajustes de cuenta.',
          ),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.update_outlined,
            title: '8. Cambios a esta política',
            content:
                'Podemos actualizar esta Política de Privacidad periódicamente. '
                'Te notificaremos sobre cambios relevantes publicando la versión '
                'actualizada en esta pantalla con su respectiva fecha de vigencia.',
          ),
          const SizedBox(height: 24),
          _SupportPrompt(
            onContactTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  settings: const RouteSettings(
                    name: ContactSupportPage.routeName,
                  ),
                  builder: (_) => const ContactSupportPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.border),
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.purple,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu privacidad es nuestra prioridad',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Última actualización: Octubre 2026',
                  style: TextStyle(
                    fontSize: 13,
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.content,
  });

  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.border),
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.purple),
              const SizedBox(width: 8),
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
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportPrompt extends StatelessWidget {
  const _SupportPrompt({required this.onContactTap});

  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.contact_support_outlined,
            size: 28,
            color: context.palette.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            '¿Preguntas sobre el tratamiento de tus datos?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Escríbenos y responderemos cualquier inquietud sobre privacidad.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: context.palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onContactTap,
            child: const Text('Contactar a soporte'),
          ),
        ],
      ),
    );
  }
}

