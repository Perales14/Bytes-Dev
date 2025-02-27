import 'package:flutter/material.dart';

import 'package:get/get.dart';


import '../controllers/form_controller.dart';
import '../../../shared/widgets/formulario_widget.dart';


class FormView extends StatelessWidget {
  const FormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Registro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormularioCompleto(),
        ),
      ),
    );
  }
}
