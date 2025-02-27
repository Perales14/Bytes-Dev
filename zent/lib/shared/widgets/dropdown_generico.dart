import 'package:flutter/material.dart';

class DropdownGenerico extends StatefulWidget {
  final String label; // Etiqueta del dropdown
  final List<String> opciones; // Lista de opciones
  final String? valorInicial; // Valor inicial
  final Function(String?) onChanged; // Función para manejar cambios

  const DropdownGenerico({
    required this.label,
    required this.opciones,
    this.valorInicial,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownGenericoState createState() => _DropdownGenericoState();
}

class _DropdownGenericoState extends State<DropdownGenerico> {
  String? valorSeleccionado; // Estado interno

  @override
  void initState() {
    super.initState();
    valorSeleccionado = widget.valorInicial; // Asigna el valor inicial si existe
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Color(0xFF0D0D0D),
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black.withOpacity(0.6),
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: valorSeleccionado,
            hint: Text('Seleccione ${widget.label}'),
            items: widget.opciones.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (nuevoValor) {
              setState(() {
                valorSeleccionado = nuevoValor;
              });
              widget.onChanged(nuevoValor);
            },
          ),
        ),
      ],
    );
  }
}
