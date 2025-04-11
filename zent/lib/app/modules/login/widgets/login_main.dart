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
        final bool isSmallScreen = constraints.maxWidth < 600;
        final theme = Theme.of(context);
        return Row(
          children: [
            if (!isSmallScreen) _buildLeftColumn(context, constraints),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white, // Lado derecho con fondo blanco
                child: _buildLoginContent(context, isSmallScreen, constraints),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeftColumn(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Ajustar el tamaño del título según el tamaño de la pantalla
    final titleFontSize = size.width > 1200 ? 60.0 : 48.0;
    final titleLetterSpacing = size.width > 1200 ? 6.0 : 4.0;
    final topPadding = size.height > 800 ? 160.0 : 120.0;

    return Expanded(
      flex: 1,
      child: Container(
        color: theme.colorScheme
            .primary, // Usando el color primary para el lado izquierdo
        child: Stack(
          children: [
            // Título ZENT centrado verticalmente entre el borde superior y la imagen
            Positioned(
              top: topPadding, // Posición ajustada según altura de pantalla
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
            // La imagen estará pegada al fondo y ocupará el mayor espacio posible
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

  Widget _buildLoginContent(
      BuildContext context, bool isSmallScreen, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Ajustar el espaciado y tamaño del texto según el tamaño de la pantalla
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
          if (isSmallScreen) ...[
            Text(
              'ZENT',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                fontSize: size.width > 600 ? 48.0 : 36.0,
              ),
            ),
            SizedBox(height: size.width > 600 ? 40.0 : 32.0),
          ],
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
          LoginTextField(),
          SizedBox(height: size.width > 1200 ? 40.0 : 32.0),
          LoginButtons(),
        ],
      ),
    );
  }
}
