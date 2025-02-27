import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const Button({required this.texto, required this.onPressed});

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
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          letterSpacing: 3.60,
        ),
      ),
    );
  }
}