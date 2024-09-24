import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PositionService extends ChangeNotifier {
  double latitude = -22.2491;
  double longitude = -45.7055;
  bool picked = false;

  void setPicked(bool value){
    picked = value;
    notifyListeners();
  }

  Future<Position> _currentPosition() async {
    LocationPermission permission;
    bool activ = await Geolocator.isLocationServiceEnabled();

    if (!activ) {
      return Future.error('Por favor, habilite a localizaão do smartphone');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso a localização');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso a localização nas configurações');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosition() async {
    try {
      final position = await _currentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      );
    }
  }

  Stream<Position> streamLocal() {
    return Geolocator.getPositionStream();
  }
}
