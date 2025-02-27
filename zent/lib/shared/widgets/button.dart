import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icon; // Nuevo parámetro para el ícono

  const Button({
    required this.texto,
    required this.onPressed,
    this.icon, // Hacemos el ícono opcional
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF074073),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Asegura que el Row no ocupe más espacio del necesario
        children: [
          Text(
            texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              letterSpacing: 3.60,
            ),
          ),
          if (icon != null) SizedBox(width: 8), // Espacio entre el texto y el ícono
          if (icon != null) Icon(icon, color: Colors.white), // Muestra el ícono si está presente
        ],
      ),
    );
  }
}