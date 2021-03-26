import 'package:PetCare/models/animalModel.dart';
import 'package:PetCare/screens/animalDetailScreen.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AnimalCard extends StatelessWidget {
  final GoogleMapController mapController;
  final PanelController panelController;
  final AnimalModel animalModel;

  AnimalCard(
      {@required this.animalModel,
      @required this.mapController,
      @required this.panelController});
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await mapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: animalModel.latLng,
              zoom: 16,
            )));
            panelController.close();
          },
          child: Container(
            width: mediaQuery.size.width - 60,
            height: 70,
            decoration: BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 60,
                  width: 50,
                  child: Image(
                    image: AssetImage("assets/icons/animalSad" +
                        animalModel.animalTypeId.toString() +
                        ".png"),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Help Needed",
                      style: TextStyle(color: Constants.focusColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 60,
                                                  child: Text(
                            animalModel.description,
                            style: TextStyle(color: Constants.focusColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        if(animalModel.distance != 0)
                        Text(
                          animalModel.distance.round().toString() + " m",
                          style: TextStyle(color: Constants.focusColor),
                        ),
                      ],
                    )
                  ],
                ),
                AdaptiveWidgets.adaptiveRaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0)),
                    width: 70,
                    onPressed: () async {
                      await panelController.close();
                      await mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        target: animalModel.latLng,
                        zoom: 16,
                      )));
                      Navigator.of(context).pushNamed(
                          AnimalDetailScreen.routeName,
                          arguments: animalModel);
                    },
                    child: Text("Help"),
                    color: Constants.focusColor,
                    context: context)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
