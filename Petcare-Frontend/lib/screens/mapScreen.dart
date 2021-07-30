import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLatLng;
  final bool isSelecting;

  MapScreen(
      {@required this.initialLatLng,
      @required this.isSelecting});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveWidgets.adaptiveScaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AdaptiveWidgets.adaptiveAppBar(
        actionsColor: Constants.focusColor,
        backgroundColor: Constants.primaryColorDark,
        title: Text(""),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: widget.initialLatLng,
            zoom: 16),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: !widget.isSelecting
            ? {
                Marker(
                    markerId: MarkerId("m1"),
                    position:
                        widget.initialLatLng)
              }
            : _pickedLocation == null
                ? null
                : {Marker(markerId: MarkerId("m1"), position: _pickedLocation)},
      ),
    );
  }
}
