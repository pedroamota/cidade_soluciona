import 'package:flutter/material.dart';

class ComponentsStyle {
  static final bordas = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Colors.white,
  );
  static const text = TextStyle(
    color: Color.fromARGB(255, 255, 244, 0),
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static Widget appBar(size) {
    return Column(
      children: [
        SizedBox(
          height: size.width * .6,
          child: const Image(
            image: AssetImage("assets/logo.png"),
          ),
        ),
        Container(
          width: size.width * .7,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 255, 244, 0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26, // Cor da sombra
                  blurRadius: 8.0, // Raio de desfoque
                  offset: Offset(0, 4), // Posição da sombra
                ),
              ],),
          alignment: Alignment.center,
          child: const Text(
            'CIDADE SOLUCIONA',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 70),
      ],
    );
  }
}
