import 'package:flutter/material.dart';
import 'package:zent/shared/widgets/text_field.dart'; // Importa tu widget CampoTexto
import 'package:zent/shared/widgets/button.dart'; // Importa tu widget Boton
import 'package:zent/shared/widgets/dropdown_generico.dart'; // Importa tu widget DropdownGenérico
import 'package:zent/shared/widgets/data_widget.dart'; // Importa tu widget DataWidget

class FormularioCompleto extends StatelessWidget {
  final bool showSalario; // Parámetro para controlar la visibilidad del campo Salario

  const FormularioCompleto({
    Key? key,
    this.showSalario = true, // Por defecto, el campo Salario está visible
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.black.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "FORMULARIO"
          Center(
            child: Text(
              'FORMULARIO',
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                letterSpacing: 3.60,
              ),
            ),
          ),
          SizedBox(height: 30),

          // Contenedor Principal (Datos Personales, Datos de la Empresa y Observaciones)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección Izquierda: Datos Personales y Datos de la Empresa
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Usar el widget DataWidget para los datos personales y de la empresa
                    DataWidget(
                      showSalario: showSalario, // Pasar el parámetro showSalario
                    ),
                    SizedBox(height: 20),

                    // Fila: Rol y Tipo de Contrato
                    Row(
                      children: [
                        Expanded(
                          child: DropdownGenerico(
                            label: 'Rol',
                            opciones: ['Admin', 'Captador de Campo', 'Promotor', 'Recursos Humanos'],
                            onChanged: (valor) {
                              // Lógica cuando se selecciona un valor
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownGenerico(
                            label: 'Tipo de Contrato',
                            opciones: ['Indeterminado', 'Determinado', 'Obra/Servicio', 'Capacitación'],
                            onChanged: (valor) {
                              // Lógica cuando se selecciona un valor
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Espacio entre las secciones
              SizedBox(width: 20),

              // Sección Derecha: Observaciones
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Observaciones',
                      style: TextStyle(
                        color: Color(0xFF266F8C),
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFF266F8C), // Color del contorno (#266F8C)
                          width: 1, // Grosor del borde
                        ),
                      ),
                      child: TextField(
                        maxLines: 15, // Área de texto más grande
                        decoration: InputDecoration(
                          border: InputBorder.none, // Elimina el borde interno del TextField
                          hintText: 'Escribe tus observaciones aquí...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          // Botones CANCELAR y AGREGAR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(texto: 'CANCELAR', onPressed: () {}),
              SizedBox(width: 100),
              Button(texto: 'AGREGAR', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}