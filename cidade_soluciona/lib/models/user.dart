import 'package:flutter/material.dart';

class Usuario extends ChangeNotifier {
  String? id;
  String? name;
  String? username;
  String? senha;
  String? telefone;
  double? latitude;
  double? longitude;
  List<dynamic> friends = [];
  String? help;
  bool alert = false;
}
