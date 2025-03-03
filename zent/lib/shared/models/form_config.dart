import 'package:flutter/material.dart';

/// Configuration model for all form types
class FormConfig {
  final String title;
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool showObservations;
  final bool showFiles;
  final int observationsFlex;

  const FormConfig({
    required this.title,
    this.primaryButtonText = 'AGREGAR',
    this.secondaryButtonText = 'CANCELAR',
    this.showObservations = true,
    this.showFiles = false,
    this.observationsFlex = 1,
  });

  // Employee form configuration
  static const FormConfig employee = FormConfig(
    title: 'REGISTRO DE EMPLEADO',
    showFiles: true,
  );

  // Client form configuration
  static const FormConfig client = FormConfig(
    title: 'REGISTRO DE CLIENTE',
    observationsFlex: 1, // Changed from 2 to 1 to reduce size
  );
}
