import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final position = Provider.of<PositionService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);

    final db = ServicesDB(auth: auth);
    db.saveLocal(position.latitude, position.longitude);
    db.getLocalAlerts(context);

    return const Scaffold(
      body: GoogleMap(
        mapToolbarEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            -22.2491,
            -45.7055,
          ),
          zoom: 15,
        ),
        myLocationEnabled: true,
      ),
    );
  }
}
