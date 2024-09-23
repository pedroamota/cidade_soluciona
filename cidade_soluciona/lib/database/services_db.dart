import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/makers.dart';
import '../models/user.dart';
import '../service/auth_service.dart';
import 'DBFirestore.dart';

class ServicesDB {
  late FirebaseFirestore db;
  late AuthService auth;

  ServicesDB({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  //USUARIO

  Future<void> saveUser(String name) async {
    try {
      final userDocRef = db.collection('dados').doc('${auth.usuario!.email}');
      await userDocRef.set({
        'name': name,
        'latitude': '',
        'longitude': '',
      });
      print('User data saved successfully.');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void getData(context) async {
    final user = Provider.of<Usuario>(context, listen: false);

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('dados')
          .doc(auth.usuario!.email)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;
        user.name = userData['name'];
        user.latitude = userData['latitude'];
        user.longitude = userData['longitude'];

        getLocalAlerts(context);
      } else {
        print('Documento do usuário não encontrado.');
      }
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
    }
  }

  saveLocal(double latitude, double longitude) async {
    final userDocRef = db.collection('dados').doc('${auth.usuario!.email}');

    await userDocRef.update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  //Usar em caso de erro
  Future<List<dynamic>> _getEmails() async {
    try {
      // Referência ao documento do usuário
      final userDocRef = FirebaseFirestore.instance
          .collection('dados')
          .doc(auth.usuario!.email);

      // Obtendo os dados do documento
      final userDocSnapshot = await userDocRef.get();

      // Verifique se o documento existe antes de acessar a lista de amigos
      if (userDocSnapshot.exists) {
        // Obtenha a lista de amigos do documento
        List<dynamic> friends = userDocSnapshot.data()!['friends'] ?? [];
        return friends;
      } else {
        // Se o documento não existir, você pode lidar com isso de acordo com sua lógica
        throw Exception('Documento do usuário não encontrado');
      }
    } catch (e) {
      // Lidar com erros ou exceções aqui, se necessário
      print('Erro ao buscar a lista de amigos: $e');
      return [];
    }
  }

  void getLocalAlerts(context) async {
    final markers = Provider.of<MarkersEntity>(context, listen: false);
    Set<Marker> listMarkers = {};
    List<dynamic> listEmails = [];

    for (dynamic email in listEmails) {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('dados')
          .doc(email) // Use o email como ID do documento
          .get();

      var aux = Marker(
        markerId: MarkerId(doc['name']),
        position: LatLng(
          doc['latitude'] as double,
          doc['longitude'] as double,
        ),
        infoWindow: InfoWindow(title: doc['name']),
      );

      listMarkers.add(aux);
    }

    markers.setMarkers(listMarkers);
  }
}
