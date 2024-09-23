import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/style_form_field.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final description = TextEditingController();
  String searchTerm = '';
  String? pathImage;
  //bool picked = false;

  void showPopUp(
    BuildContext context,
    LatLng position,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(30),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          title: const Text(
            'Anexe a foto do problema',
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    pickAndUploadImage();
                    setState(() {});
                  },
                  icon: /*picked
                      ? const Icon(
                          Icons.check_box,
                          color: Colors.green,
                          size: 70,
                        )
                      : 
                      */const Icon(
                          Icons.photo,
                          size: 70,
                        ),
                ),
                TextFormFieldComponent(
                  controller: description,
                  label: 'Descrição',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite a descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(255, 255, 244, 0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26, // Cor da sombra
                          blurRadius: 8.0, // Raio de desfoque
                          offset: Offset(0, 4), // Posição da sombra
                        ),
                      ],
                    ),
                    child: const Text("Salvar"),
                  ),
                  onTap: () => submitForm(position),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  submitForm(
    LatLng position,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        ServicesDB()
            .saveMarker(
          description.text,
          position.latitude,
          position.longitude,
          pathImage!,
        )
            .whenComplete(() {
          ServicesDB().getMakers(context);
        });
        /*
        setState(() {
          picked = false;
        });*/
        FocusNode().unfocus();
        Navigator.pop(context);
      } on AuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.message),
          ),
        );
      }
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      pathImage = file.path;
      /*setState(() {
        picked = true;
      });*/
    }
  }

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final PositionService position =
        Provider.of<PositionService>(context, listen: false);
    final markers = Provider.of<MarkersEntity>(context).markers;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: GoogleMap(
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
                showPopUp(context, position);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
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
