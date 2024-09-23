import 'package:cidade_soluciona/view/home/map_widget.dart';
import 'package:flutter/material.dart';

import '../../components/components_style.dart';


class LocalPage extends StatelessWidget {
  const LocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // Cor superior (branco)
              Colors.lightBlueAccent, // Cor inferior (azul claro)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            ComponentsStyle.appBar(size),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color.fromARGB(255, 255, 244, 0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26, // Cor da sombra
                      blurRadius: 8.0, // Raio de desfoque
                      offset: Offset(0, 4), // Posição da sombra
                    ),
                  ],
                ),
                child: const Text("MAPA"),
              ),
              onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPage(),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
