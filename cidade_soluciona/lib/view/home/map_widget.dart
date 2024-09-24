import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

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
  final searchController = TextEditingController();
  GoogleMapController? mapController;
  String searchTerm = '';
  String? pathImage;
  //bool picked = false;

  void moveToNewPosition(double lat, double lng) {
    mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
  }

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
                      */
                      const Icon(
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
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller; // Guarda o controlador do mapa
              },
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
                    child: Container(
                  color: Colors.white,
                  height: size.height * .08,
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: searchController,
                    googleAPIKey: "AIzaSyCFMsWVXk8t0RWh0IyL7gmgmGhz39ayO20",
                    countries: const ["br"], // optional by default null is set
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      moveToNewPosition(
                          prediction.lat as double, prediction.lng as double);
                    }, // this callback is called when isLatLngRequired is true
                    itemClick: (Prediction prediction) {
                      searchController.text = prediction.description!;
                      searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length));
                    },
                    itemBuilder: (context, index, Prediction prediction) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 7),
                            Expanded(child: Text(prediction.description ?? ""))
                          ],
                        ),
                      );
                    },
                    // if you want to add seperator between list items
                    seperatedBuilder: const Divider(),
                    // want to show close icon
                    isCrossBtnShown: true,
                    // optional container padding
                    containerHorizontalPadding: 10,
                    // place type
                    placeType: PlaceType.geocode,
                  ),
                )),
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
