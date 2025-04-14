// Componente principal de la pantalla de login con layout adaptativo
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/login/controllers/login_controller.dart';
import 'login_buttons.dart';
import 'login_textfield.dart';

class LoginMain extends GetView<LoginController> {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar si estamos en pantalla pequeña (móvil)
        final bool isSmallScreen = constraints.maxWidth < 600;

        return Row(
          children: [
            // Panel izquierdo (solo visible en pantallas medianas y grandes)
            if (!isSmallScreen) _buildLeftPanel(context, constraints),

            // Panel derecho (formulario de login)
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: _buildLoginForm(context, isSmallScreen, constraints),
              ),
            ),
          ],
        );
      },
    );
  }

  // Panel izquierdo con imagen y logo
  Widget _buildLeftPanel(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Ajustes responsivos para el título
    final titleFontSize = size.width > 1200 ? 60.0 : 48.0;
    final titleLetterSpacing = size.width > 1200 ? 6.0 : 4.0;
    final topPadding = size.height > 800 ? 160.0 : 120.0;

    return Expanded(
      flex: 1,
      child: Container(
        color: theme.colorScheme.primary,
        child: Stack(
          children: [
            // Título ZENT centrado en la parte superior
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'ZENT',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    letterSpacing: titleLetterSpacing,
                  ),
                ),
              ),
            ),

            // Imagen inferior que ocupa el espacio restante
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/dibujos_login.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Formulario de login (panel derecho)
  Widget _buildLoginForm(
      BuildContext context, bool isSmallScreen, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Ajustes responsivos
    final titleFontSize =
        size.width > 1200 ? 26.0 : (size.width > 600 ? 22.0 : 18.0);
    final verticalSpacing =
        size.width > 1200 ? 60.0 : (size.width > 600 ? 48.0 : 32.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : (size.width > 1200 ? 80 : 48),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Solo mostrar título ZENT en pantallas pequeñas (donde no se ve el panel izquierdo)
          if (isSmallScreen) ...[
            _buildMobileHeader(theme, size),
            SizedBox(height: size.width > 600 ? 40.0 : 32.0),
          ],

          // Título de bienvenida
          Text(
            'BIENVENIDO DE NUEVO',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontSize: titleFontSize,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: verticalSpacing),

          // Campos de texto (email y contraseña)
          const LoginTextField(),

          SizedBox(height: size.width > 1200 ? 40.0 : 32.0),

          // Botones de acción
          const LoginButtons(),
        ],
      ),
    );
  }

  // Encabezado para vista móvil
  Widget _buildMobileHeader(ThemeData theme, Size size) {
    return Text(
      'ZENT',
      style: theme.textTheme.displayMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontSize: size.width > 600 ? 48.0 : 36.0,
      ),
    );
  }
}
