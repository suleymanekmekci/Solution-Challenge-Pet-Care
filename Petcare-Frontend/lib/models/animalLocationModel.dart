import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnimalLocationModel {
  LatLng latLng;
  String description;
  String foodType;
  String numberOfAnimals;
  String id;
  String lastFeedingDate;
  double distance;
  String imageAssetPath;
  AnimalLocationModel(
      {this.latLng,
      this.description,
      this.foodType,
      this.numberOfAnimals,
      @required this.id,
      @required this.lastFeedingDate,
      @required this.distance , @required this.imageAssetPath});
}
