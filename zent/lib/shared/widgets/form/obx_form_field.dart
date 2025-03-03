import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ObxFormField<T> extends StatelessWidget {
  final Rx<T> value;
  final Widget Function(T value) builder;

  const ObxFormField({
    required this.value,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentValue = value.value;
      return builder(currentValue);
    });
  }
}
