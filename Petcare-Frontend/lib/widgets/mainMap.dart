import 'package:PetCare/models/animalLocationModel.dart';
import 'package:PetCare/models/animalModel.dart';
import 'package:PetCare/models/customUser.dart';
import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/providers/currentUser.dart';
import 'package:PetCare/screens/animalDetailScreen.dart';
import 'package:PetCare/screens/feedScreen.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/animalCard.dart';
import 'package:PetCare/widgets/locationCard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MainMapWidget extends StatefulWidget {
  @override
  _MainMapWidgetState createState() => _MainMapWidgetState();
}

class _MainMapWidgetState extends State<MainMapWidget> {
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(0),
    topRight: Radius.circular(0),
  );

  Widget _floatingCollapsed(AnimalLocationModel firstElement) {
    if (firstElement == null) {
      firstElement = AnimalLocationModel(
        imageAssetPath: "assets/icons/catsAndDogs",
          distance: 0,
          id: "0",
          lastFeedingDate: "",
          description: "",
          foodType: "",
          numberOfAnimals: "0",
          latLng: LatLng(1, 1));
    }
    return Container(
      decoration: BoxDecoration(
        color: Constants.panelColor,
        borderRadius: radius,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Icon(
                Icons.arrow_upward,
                color: Constants.focusColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            LocationCard(
                animalLocationModel: firstElement,
                mapController: mapController,
                panelController: panelController)
          ],
        ),
      ),
    );
  }

  PanelController panelController = PanelController();
  ScrollController scrollController = ScrollController();
  GoogleMapController mapController;
  BitmapDescriptor feedIcon;
  BitmapDescriptor helpIcon;

  @override
  void initState() {
    super.initState();
    
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              size: Size(200, 200),
            ),
            'assets/icons/feed_icon.png')
        .then((d) {
      setState(() {
        feedIcon = d;
      });
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              size: Size(200, 200),
            ),
            'assets/icons/help_icon.png')
        .then((d) {
      setState(() {
        helpIcon = d;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    double _panelHeightClosed = 130;
    CustomUser currentUser = Provider.of<CurrentUser>(context).currentUser;
    List<AnimalLocationModel> nearbyContainers =
        Provider.of<AnimalLocation>(context).nearbyContainers;
    List<AnimalModel> nearbyAnimals =
        Provider.of<AnimalLocation>(context).nearbyAnimals;
    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: 0.5,
      defaultPanelState: PanelState.CLOSED,
      controller: panelController,
      body: Center(
          child: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
          setState(() {
            mapController = controller;
          });
        },
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition:
            CameraPosition(target: currentUser.initialLatLng, zoom: 16),
        markers: {
          ...nearbyContainers
              .map((element) => Marker(
                  markerId: MarkerId("L" + element.id.toString()),
                  position: element.latLng,
                  icon: feedIcon == null
                      ? BitmapDescriptor.defaultMarker
                      : feedIcon,
                  onTap: () async {
                    await mapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: element.latLng,
                      zoom: 16,
                    )));
                    Navigator.of(context)
                        .pushNamed(FeedScreen.routeName, arguments: element);
                  }))
              .toSet(),
          ...nearbyAnimals
              .map((element) => Marker(
                  markerId: MarkerId("A" + element.id.toString()),
                  position: element.latLng,
                  icon: helpIcon == null
                      ? BitmapDescriptor.defaultMarker
                      : helpIcon,
                  onTap: () async {
                    await mapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: element.latLng,
                      zoom: 16,
                    )));
                    Navigator.of(context).pushNamed(
                        AnimalDetailScreen.routeName,
                        arguments: element);
                  }))
              .toSet()
        },
      )),
      panelBuilder: (sc) {
        scrollController = sc;
        return Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: Constants.panelColor
          ),
          child: ListView(
            controller: sc,
            children: [
              Container(
                child: Icon(
                  Icons.arrow_downward,
                  color: Constants.focusColor,
                ),
                decoration:
                    BoxDecoration(color: Constants.panelColor, borderRadius: radius),
              ),
              SizedBox(
                height: 30,
              ),
              if (mapController != null)
                ...nearbyContainers
                    .map((e) => LocationCard(
                        animalLocationModel: e,
                        mapController: mapController,
                        panelController: panelController))
                    .toList(),
              ...nearbyAnimals
                  .map((e) => AnimalCard(
                      animalModel: e,
                      mapController: mapController,
                      panelController: panelController))
                  .toList()
            ],
          ),
        );
      },
      collapsed: _floatingCollapsed(nearbyContainers[0]),
      borderRadius: null,
    );
  }
}
