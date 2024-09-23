import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/makers.dart';
import '../models/user.dart';
import '../service/auth_service.dart';
import 'DBFirestore.dart';

class ServicesDB {
  late FirebaseFirestore db;
  final FirebaseStorage storage = FirebaseStorage.instance;

  ServicesDB() {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  //USUARIO

  Future<void> saveMarker(
      String name, double latitude, double longitude, String path) async {
    final userDocRef = db.collection('dados');
    final result = await userDocRef.add({
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    });

    File file = File(path);
    String ref = 'images/img-${result.id}';
    await storage.ref(ref).putFile(file);
  }

  void getMakers(context) async {
    final markersProvider = Provider.of<MarkersEntity>(context, listen: false);

    final CollectionReference dadosRef = db.collection('dados');

// Buscando todos os documentos da coleção 'dados'
    QuerySnapshot querySnapshot = await dadosRef.get();

// Mapeando os documentos Firestore para objetos Marker
    Set<Marker> markers = querySnapshot.docs.map((doc) {
      return Marker(
        markerId: MarkerId(doc.id), // Usando o ID do documento como markerId
        position: LatLng(
          doc['latitude'] as double,
          doc['longitude'] as double,
        ),
        infoWindow: InfoWindow(title: doc['name']),
      );
    }).toSet(); // Convertendo para um Set de Markers, já que o GoogleMap usa um Set
    markersProvider.setMarkers(markers);
  }
}
