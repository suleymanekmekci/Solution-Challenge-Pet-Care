import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnimalModel {
  LatLng latLng;
  String description;
  String id;
  double distance;
  String photoUrl;
  String animalType;
  String imageAsset;
  int animalTypeId;
  AnimalModel(
      {this.latLng,
      this.description,
      this.photoUrl,
      @required this.id,
      @required this.distance,
      this.animalType , @required this.animalTypeId});
}
