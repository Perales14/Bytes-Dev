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
        final bool isSmallScreen = constraints.maxWidth < 900;
        final theme = Theme.of(context);
        return Row(
          children: [
            if (!isSmallScreen) _buildLeftColumn(context),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white, // Lado derecho con fondo blanco
                child: _buildLoginContent(context, isSmallScreen),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      flex: 1,
      child: Container(
        color: theme.colorScheme.primary,
        child: Stack(
          children: [
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'ZENT',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
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

  Widget _buildLoginContent(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : 48,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSmallScreen) ...[
            Text(
              'ZENT',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme
                    .primary, // Color contrastante para pantalla pequeña
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 32),
          ],
          Text(
            'BIENVENIDO DE NUEVO',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary, // Ajustando para fondo blanco
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          LoginTextField(),
          const SizedBox(height: 32),
          LoginButtons(),
        ],
      ),
    );
  }
}
