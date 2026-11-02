import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../widgets/settings_widgets.dart';
import 'contact_support_page.dart';

/// Screen displaying the platform's Terms and Conditions.
class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  static const routeName = '/settings/terms';

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Términos y condiciones',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const _HeaderCard(),
          const SizedBox(height: 20),
          const _Section(
            number: '1',
            title: 'Aceptación de los términos',
            content:
                'Al acceder o utilizar nuestra aplicación, aceptas quedar '
                'vinculado por estos Términos y Condiciones y nuestra Política '
                'de Privacidad. Si no estás de acuerdo con alguna parte de '
                'estos términos, te pedimos no utilizar la plataforma.',
          ),
          const SizedBox(height: 16),
          const _Section(
            number: '2',
            title: 'Descripción del servicio',
            content:
                'Nuestra plataforma actúa como un punto de encuentro digital '
                'que conecta usuarios con comercios y negocios locales, '
                'permitiendo descubrir productos, promociones, ofertas especiales '
                'y servicios ofrecidos por cada establecimiento.',
          ),
          const SizedBox(height: 16),
          const _Section(
            number: '3',
            title: 'Cuentas y registro',
            content:
                'Para utilizar ciertas funcionalidades, como la gestión de '
                'negocios o el envío de reseñas, es necesario crear una cuenta. '
                'Te comprometes a proporcionar información precisa y a '
                'mantener la confidencialidad de tus credenciales de acceso.',
          ),
          const SizedBox(height: 16),
          const _Section(
            number: '4',
            title: 'Publicación de negocios y ofertas',
            content:
                'Los propietarios o administradores de negocios registrados son '
                'los únicos responsables de la veracidad, vigencia y exactitud '
                'de los precios, disponibilidad de productos, fotos y ofertas '
                'que decidan publicar en el catálogo.',
          ),
          const SizedBox(height: 16),
          const _Section(
            number: '5',
            title: 'Uso aceptable y conductas prohibidas',
            content:
                'Queda estrictamente prohibido utilizar el servicio para fines '
                'ilícitos, publicar contenido difamatorio, fraudulento, engañoso, '
                'vulnerar derechos de autor, o realizar actividades que '
                'interfieran con el normal funcionamiento de los servidores.',
          ),
          const SizedBox(height: 16),
          const _Section(
            number: '6',
            title: 'Propiedad intelectual',
            content:
                'Todos los derechos de propiedad intelectual relativos a la '
                'aplicación, interfaz, marcas, logotipos y código fuente '
                'pertenecen a sus respectivos titulares. No se permite su '
                'copia o reproducción sin autorización previa.',
          ),
          const SizedBox(height: 16),
          const _Section(
            number: '7',
            title: 'Limitación de responsabilidad',
            content:
                'La plataforma no se hace responsable por transacciones, '
                'acuerdos comerciales o disputas que surjan de forma directa '
                'entre los usuarios y los comercios anunciantes, actuando '
                'únicamente como canal informativo y publicitario.',
          ),
          const SizedBox(height: 16),
          const _Section(
            number: '8',
            title: 'Modificaciones de los términos',
            content:
                'Nos reservamos el derecho de modificar o actualizar estos '
                'términos en cualquier momento para reflejar cambios legales o '
                'mejoras en nuestras funciones. Las modificaciones entrarán '
                'en vigor tras su publicación en esta sección.',
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
              Icons.verified_user_outlined,
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
                  'Condiciones del Servicio',
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
    required this.number,
    required this.title,
    required this.content,
  });

  final String number;
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
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
            Icons.help_outline,
            size: 28,
            color: context.palette.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            '¿Tienes dudas sobre nuestros términos?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nuestro equipo está a tu disposición para ayudarte.',
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
