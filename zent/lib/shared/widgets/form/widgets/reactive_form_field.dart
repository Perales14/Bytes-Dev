import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A wrapper that correctly handles reactive properties in GetX
/// This solves the common "[Get] the improper use of a GetX has been detected" error
/// and improves reusability across form components
class ReactiveFormField<T> extends StatelessWidget {
  /// The reactive value to observe
  final Rx<T> value;

  /// Builder function that receives the current value
  final Widget Function(T value) builder;

  const ReactiveFormField({
    required this.value,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => builder(value.value));
  }
}
