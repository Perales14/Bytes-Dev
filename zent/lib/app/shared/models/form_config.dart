import 'package:flutter/material.dart';

/// Configuration model for all form types
class FormConfig {
  final String title;
  final bool showObservations;
  final int observationsFlex;
  final bool showFiles; // Add this property
  final String primaryButtonText;
  final String secondaryButtonText;

  const FormConfig({
    required this.title,
    this.showObservations = true,
    this.observationsFlex = 1,
    this.showFiles = false, // Default to false
    this.primaryButtonText = 'AGREGAR',
    this.secondaryButtonText = 'CANCELAR',
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
  static const FormConfig provider = FormConfig(
    title: 'REGISTRO DE PROVEEDOR',
    observationsFlex: 1, // Changed from 2 to 1 to reduce size
  );
}
