import 'dart:convert';

import 'package:PetCare/providers/animalLocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:PetCare/models/customUser.dart';
import 'package:PetCare/services/auth.dart';
import "package:flutter/material.dart";
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CurrentUser with ChangeNotifier {
  AuthService _auth = AuthService();
  CustomUser currentUser;
  final String API = "https://streetanimals.herokuapp.com/api/";

  Future setCurrentUserInfo(BuildContext context) async {
    currentUser = await _auth.getCurrentUserFromFirebaseUser();
    if (currentUser == null) {
      return 400;
    }
    String token = await _auth.getToken();
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };
    var apiResponse = await http.get(API + "user/getUser", headers: headers);

    var decodedApiResponse = await jsonDecode(apiResponse.body);

    currentUser.fullName =
        decodedApiResponse["firstName"] + " " + decodedApiResponse["lastName"];

    LatLng latLng;
    Location location = Location.instance;
    location.changeSettings(accuracy: LocationAccuracy.balanced);
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      await location.requestPermission();
      permissionStatus = await location.hasPermission();
    }
    if (permissionStatus == PermissionStatus.granted) {
      LocationData locData = await location.getLocation();
      latLng = LatLng(locData.latitude, locData.longitude);
    } else {
      latLng = LatLng(39.925137, 32.836942);
    }
    currentUser.initialLatLng = latLng;

    await Provider.of<AnimalLocation>(context, listen: false)
        .fillNearbyContainers(latLng);
    await Provider.of<AnimalLocation>(context, listen: false)
        .fillNearbyAnimals(latLng, context);

    notifyListeners();
    return 200;
  }

  Future registerUser(String fullName) async {
    String token = await _auth.getToken();
    var data = {
      "fullName": fullName,
      //"email": email
    };
    var body = jsonEncode(data);
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };
    var response =
        await http.post(API + "user/register", body: body, headers: headers);

    return response.statusCode;
  }

  Future logout() async {
    currentUser = null;
    await _auth.signOut();
    notifyListeners();
    return 200;
  }
}
