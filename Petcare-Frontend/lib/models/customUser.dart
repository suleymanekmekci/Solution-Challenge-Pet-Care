import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomUser {
  String uid;
  int id;
  String email;
  String fullName;
  String city;
  LatLng initialLatLng;
  CustomUser({
    this.uid,
    this.id,
    this.email,
    this.fullName,
    this.city,
    this.initialLatLng
  });
}
