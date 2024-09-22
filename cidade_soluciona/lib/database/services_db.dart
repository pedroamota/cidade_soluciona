import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/makers.dart';
import '../models/user.dart';
import '../service/auth_service.dart';
import '../service/notify_user.dart';
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

  Future<void> saveUser(String name, String username, String phone) async {
    try {
      final userDocRef = db.collection('dados').doc('${auth.usuario!.email}');
      await userDocRef.set({
        'name': name,
        'username': username,
        'phone': phone,
        'friends': [],
        'latitude': '',
        'longitude': '',
        'help': '',
        'msm': '',
        'alert': false,
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
        user.username = userData['username'];
        user.telefone = userData['phone'];
        user.friends = userData['friends'];
        user.alert = userData['alert'];
        user.help = userData['help'];
        user.latitude = userData['latitude'];
        user.longitude = userData['longitude'];

        getLocalFriends(context);
      } else {
        print('Documento do usuário não encontrado.');
      }
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
    }
  }

  addFriend(newEmail, context) async {
    // Referência ao documento do usuário usando o email como ID
    final userDocRef =
        FirebaseFirestore.instance.collection('dados').doc(newEmail);

    // Verifique se o documento com o email como ID existe
    final docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      final userDocRef = db.collection('dados').doc('${auth.usuario!.email}');

      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        List<dynamic> currentFriends = userSnapshot.get('friends') ?? [];

        if (!currentFriends.contains(newEmail)) {
          currentFriends.add(newEmail);

          await userDocRef.update({
            'friends': currentFriends,
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blue,
              content: Text('Amigo adicionado'),
            ),
          );
        } else {
          NotifyUser.showPopUp(context, 'Usuario já está na lista de amigos');
        }
      } else {
        print('Documento do usuário não encontrado.');
      }
    } else {
      NotifyUser.showPopUp(context, 'Usuario não existe');
    }
  }

  Future<void> sendAlert(context, String msm, bool alert) async {
    final user = Provider.of<Usuario>(context, listen: false);

    try {
      CollectionReference dadosCollection =
          FirebaseFirestore.instance.collection('dados');

      for (String email in user.friends) {
        DocumentReference userDocRef = dadosCollection.doc(email);
        Map<String, dynamic> updatedData = {
          'alert': alert,
          'help': user.name,
          'msm': msm,
        };
        await userDocRef.update(updatedData);
        print('Document for $email updated successfully.');
      }

      print('All documents updated.');
    } catch (e) {
      print('Error updating documents: $e');
    }
  }

  saveLocal(double latitude, double longitude) async {
    final userDocRef = db.collection('dados').doc('${auth.usuario!.email}');

    await userDocRef.update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  //SEMPRE ATIVADAS

  void listenToAlert(context) {
    FirebaseFirestore.instance
        .collection('dados')
        .doc(auth.usuario!.email)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        bool alertStatus = userData['alert'] ?? false;
        String msm = userData['msm'] ?? false;
        String name = userData['help'] ?? false;
        if (alertStatus) {
          NotifyUser.showPopUp(context, '$name precisa de ajuda! $msm');
        } else {
          print('Alerta desativado.');
        }
      } else {
        print('Documento do usuário não encontrado.');
      }
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

  void getLocalFriends(context) async {
    final markers = Provider.of<MarkersEntity>(context, listen: false);
    Set<Marker> listMarkers = {};
    List<dynamic> listEmails = [];

    listEmails = Provider.of<Usuario>(context, listen: false).friends;

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

  updatePhone(String phone, context) async {
    try {
      final userDocRef = db.collection('dados').doc('${auth.usuario!.email}');
      await userDocRef.update({
        'phone': phone,
      }).whenComplete(
          () => NotifyUser.showScackbar(context, 'Atualizado com sucesso'));
      getData(context);
    } catch (e) {
      NotifyUser.showScackbar(context, 'Erro na atualização');
    }
  }

  updateUser(String name, context) async {
    try {
      final userDocRef = db.collection('dados').doc('${auth.usuario!.email}');
      await userDocRef.update({
        'username': name,
      }).whenComplete(
          () => NotifyUser.showScackbar(context, 'Atualizado com sucesso'));
      getData(context);
    } catch (e) {
      NotifyUser.showScackbar(context, 'Erro na atualização');
    }
  }
}
