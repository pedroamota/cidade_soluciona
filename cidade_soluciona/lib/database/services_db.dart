import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/makers.dart';
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
        infoWindow: InfoWindow(
          title: doc['name'],
          onTap: () async {
            try {
              String imageUrl = await getImg(doc.id);

              // Exibir o BottomSheet com a imagem dinâmica
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.6, // 50% da altura da tela
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              doc['name'],
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 20),
                            Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // Retorna a imagem quando carregada
                                }
                                return Container(
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: const Text('Erro ao carregar imagem'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } catch (e) {
              print('Erro ao obter imagem: $e');
            }
          },
        ),
      );
    }).toSet();
    markersProvider.setMarkers(markers);
  }

  Future<String> getImg(String id) async {
    final ref = await storage.ref('images/img-$id').getDownloadURL();
    return ref;
  }
}
