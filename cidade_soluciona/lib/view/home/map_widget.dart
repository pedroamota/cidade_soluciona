import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../database/services_db.dart';
import '../../models/makers.dart';
import '../../service/auth_service.dart';
import 'position_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final position = Provider.of<PositionService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);

    final db = ServicesDB(auth: auth);
    db.saveLocal(position.latitude, position.longitude);
    db.getLocalFriends(context);

    return Container(
      width: size.width * .8,
      height: size.height * .5,
      color: Colors.white,
      child: GoogleMap(
        mapToolbarEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 12,
        ),
        myLocationEnabled: true,
        markers: Provider.of<MarkersEntity>(context, listen: false).markers,
      ),
    );
  }
}
