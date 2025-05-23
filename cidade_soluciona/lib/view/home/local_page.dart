import 'package:cidade_soluciona/view/home/map_widget.dart';
import 'package:cidade_soluciona/view/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components_style.dart';
import '../../database/services_db.dart';
import '../../service/auth_service.dart';
import '../../service/position_service.dart';

class LocalPage extends StatefulWidget {
  const LocalPage({super.key});

  @override
  State<LocalPage> createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Continue para carregar o mapa
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Trate a permissão negada
    }
  }

  getData() async {
    final db = ServicesDB();
    Provider.of<PositionService>(context, listen: false).getPosition();
    db.getMakers(context);
  }

  @override
  void initState() {
    requestLocationPermission();
    getData();
    super.initState();
  }

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
            const Spacer(),
            IconButton(
                icon: const Icon(Icons.logout_outlined),
                onPressed: () {
                  Provider.of<AuthService>(context, listen: false).logOut;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
