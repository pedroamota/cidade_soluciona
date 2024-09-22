import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersEntity extends ChangeNotifier {
  Set<Marker> markers = {};

  setMarkers(Set<Marker> newList) {
    markers = newList;
  }
}
