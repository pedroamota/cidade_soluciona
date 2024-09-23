import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../database/services_db.dart';
import '../../models/makers.dart';
import '../../service/auth_service.dart';
import '../../service/position_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> markers = {};
  String searchTerm = '';

  void addMarker(LatLng position) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: const InfoWindow(title: 'Você clicou aqui'),
    );

    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final PositionService position =
        Provider.of<PositionService>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 15,
            ),
            markers: markers,
            onLongPress: (LatLng position) {
              addMarker(position);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            width: size.width, // Ocupa toda a largura da tela
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    Navigator.pop(context); // Volta à tela anterior
                  },
                ),
                Expanded(
                  // Expande o TextField para ocupar o espaço restante
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Procurar localidade',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      isDense: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchTerm = value.toLowerCase();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
