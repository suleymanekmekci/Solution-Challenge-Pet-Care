import 'package:PetCare/models/animalLocationModel.dart';
import 'package:PetCare/screens/feedScreen.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LocationCard extends StatelessWidget {
  final GoogleMapController mapController;
  final PanelController panelController;
  final AnimalLocationModel animalLocationModel;

  LocationCard(
      {@required this.animalLocationModel,
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
              target: animalLocationModel.latLng,
              zoom: 16,
            )));
            panelController.close();
          },
          child: Container(
            width: mediaQuery.size.width - 60,
            height: 70,
            decoration: BoxDecoration(color: Constants.primaryColorDark),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 60,
                  width: 50,
                  child: Image(
                    image: AssetImage(animalLocationModel.imageAssetPath),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Feeding Needed",style: TextStyle(color: Constants.focusColor),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(width: 60,child: Text(animalLocationModel.description,style: TextStyle(color: Constants.focusColor),overflow: TextOverflow.ellipsis,)),
                        SizedBox(width: 10,),
                        if(animalLocationModel.distance != 0)
                        Text(animalLocationModel.distance.round().toString()+" m",style: TextStyle(color: Constants.focusColor),),
                      ],
                    )
                  ],
                ),
                AdaptiveWidgets.adaptiveRaisedButton(
                   shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                    width: 70,
                    onPressed: () async {
                      await panelController.close();
                      await mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        target: animalLocationModel.latLng,
                        zoom: 16,
                      )));
                      Navigator.of(context).pushNamed(FeedScreen.routeName,
                          arguments: animalLocationModel);
                    },
                    child: Text("Feed",style: TextStyle(fontWeight: FontWeight.bold),),
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
