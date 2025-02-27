import 'package:flutter/material.dart';
import 'text_field.dart'; // Importa tu widget CampoTexto

class DataWidget extends StatelessWidget {
  final bool showSalario; // Parámetro para controlar la visibilidad del campo Salario

  const DataWidget({
    Key? key,
    this.showSalario = true, // Por defecto, el campo Salario está visible
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección 1: Datos Personales
        Text(
          'Datos Personales',
          style: TextStyle(
            color: Color(0xFF266F8C),
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),

        // Fila 1: Nombre, Apellido Paterno, Apellido Materno
        Row(
          children: [
            Expanded(child: CampoTexto(label: 'Nombre:')),
            SizedBox(width: 10),
            Expanded(child: CampoTexto(label: 'Apellido Paterno:')),
            SizedBox(width: 10),
            Expanded(child: CampoTexto(label: 'Apellido Materno:')),
          ],
        ),
        SizedBox(height: 10),

        // Fila 2: Correo Electrónico, Teléfono, NSS
        Row(
          children: [
            Expanded(child: CampoTexto(label: 'Correo Electrónico:')),
            SizedBox(width: 10),
            Expanded(child: CampoTexto(label: 'Teléfono:')),
            SizedBox(width: 10),
            Expanded(child: CampoTexto(label: 'NSS:')),
          ],
        ),
        SizedBox(height: 10),

        // Fila 3: Contraseña y Confirmar Contraseña
        Row(
          children: [
            Expanded(child: CampoTexto(label: 'Contraseña:', obscureText: true)),
            SizedBox(width: 10),
            Expanded(child: CampoTexto(label: 'Confirmar Contraseña:', obscureText: true)),
          ],
        ),
        SizedBox(height: 20),

        // Sección 2: Datos de la Empresa
        Text(
          'Datos de la Empresa',
          style: TextStyle(
            color: Color(0xFF266F8C),
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),

        // Fila 4: ID, Fecha de Ingreso, Salario (condicional)
        Row(
          children: [
            Expanded(child: CampoTexto(label: 'ID:')),
            SizedBox(width: 10),
            Expanded(child: CampoTexto(label: 'Fecha de Ingreso:')),
            if (showSalario) SizedBox(width: 10),
            if (showSalario) Expanded(child: CampoTexto(label: 'Salario:')),
          ],
        ),
      ],
    );
  }
}