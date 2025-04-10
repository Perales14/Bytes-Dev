import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/login/controllers/login_controller.dart';
import 'login_buttons.dart';
import 'login_textfield.dart';

class LoginMain extends GetView<LoginController> {
  const LoginMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;
        return Row(
          children: [
            if (!isSmallScreen)
              _buildLeftColumn(context, constraints),
            Expanded(
              flex: 1,
              child: _buildLoginContent(context, isSmallScreen),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeftColumn(BuildContext context, BoxConstraints constraints) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: _buildLogo(context),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/dibujos_login.png',
                fit: BoxFit.cover,
                width: constraints.maxWidth * 0.4,
                height: constraints.maxHeight * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Text(
      'ZENT',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginContent(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : 48,
        vertical: 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSmallScreen) ...[
            _buildLogo(context),
            const SizedBox(height: 32),
          ],
          Text(
            'BIENVENIDO DE NUEVO',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 32 : 48),
          LoginTextField(),
          const SizedBox(height: 32),
          LoginButtons(),
        ],
      ),
    );
  }
}