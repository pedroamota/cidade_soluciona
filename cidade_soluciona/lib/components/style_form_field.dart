import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  String? Function(String?)? validator;
  bool isRed;

  TextFormFieldComponent({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(
            color:
                isRed ? const Color.fromARGB(255, 255, 244, 0) : Colors.white),
        filled: true,
        fillColor: Colors.white,
        labelText: label,
      ),
      controller: controller,
      validator: validator,
    );
  }
}
