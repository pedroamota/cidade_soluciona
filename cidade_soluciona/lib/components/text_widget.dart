import 'package:flutter/material.dart';

class TextClass extends StatelessWidget {
  final String text;
  final bool isRosa;

  const TextClass({
    super.key,
    required this.text,
    this.isRosa = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: isRosa ? Colors.black : Colors.white,
      ),
    );
  }
}
