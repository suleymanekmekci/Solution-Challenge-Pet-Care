import 'package:PetCare/providers/currentUser.dart';
import 'package:PetCare/screens/loadingScreen.dart';
import 'package:PetCare/screens/mapScreen.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/services/locationHelper.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationInput extends StatefulWidget {
  final Function saveLocation;
  LocationInput({this.saveLocation});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  bool imageLoading = false;
  bool mapLoading = false;

  LatLng _getCurrentUserLocation() /*async*/ {
    //final locData = await Location().getLocation();
    return Provider.of<CurrentUser>(context, listen: false)
        .currentUser
        .initialLatLng;
  }

  Future<void> _selectOnMap() async {
    setState(() {
      mapLoading = true;
    });
    LatLng latLng = /*await*/ _getCurrentUserLocation();

    setState(() {
      mapLoading = false;
    });

    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) =>
                MapScreen(initialLatLng: latLng, isSelecting: true)));
    if (selectedLocation == null) {
      return;
    }
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        longitude: selectedLocation.longitude,
        latitude: selectedLocation.latitude);
    setState(() {
      widget.saveLocation(selectedLocation);
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _currentLocation() async {
    setState(() {
      if (_previewImageUrl != null) {
        _previewImageUrl = null;
      }
      imageLoading = true;
    });
    LatLng latLng = /*await*/ _getCurrentUserLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        longitude: latLng.longitude, latitude: latLng.latitude);
    widget.saveLocation(latLng);

    setState(() {
      imageLoading = false;
      _previewImageUrl = staticMapImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mapLoading) {
      return Loading(false);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Constants.focusColor)),
            alignment: Alignment.center,
            height: 150,
            width: double.infinity,
            child: _previewImageUrl == null
                ? imageLoading
                    ? Loading(false)
                    : Text(
                        AppLocalizations.of(context)
                            .translate("addFeedScreen_noLocationChosen"),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Constants.focusColor),
                      )
                : Image.network(
                    _previewImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.location_on),
                label: Text(AppLocalizations.of(context)
                    .translate("addFeedScreen_currentLocation")),
                textColor: Constants.focusColor,
                onPressed: () {
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                  _currentLocation();
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.map),
                label: Text(AppLocalizations.of(context)
                    .translate("addFeedScreen_selectOnMap")),
                textColor: Constants.focusColor,
                onPressed: () {
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                  _selectOnMap();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
