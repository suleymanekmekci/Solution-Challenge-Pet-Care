import 'dart:convert';
import 'dart:io';

import 'package:PetCare/models/animalLocationModel.dart';
import 'package:PetCare/services/app_localizations.dart';
import '../models/animalModel.dart';
import '../services/firebaseStorageUploader.dart';
import 'package:PetCare/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class AnimalLocation with ChangeNotifier {
  AuthService _auth = AuthService();
  final String API = "https://streetanimals.herokuapp.com/api/";
  List<AnimalLocationModel> nearbyContainers = [];
  List<AnimalModel> nearbyAnimals = [];

  Future fillNearbyContainers(LatLng latLng) async {
    String token = await _auth.getToken();
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
      "latitude": latLng.latitude.toString(),
      "longitude": latLng.longitude.toString()
    };
    var apiResponse =
        await http.get(API + "container/getNearContainers", headers: headers);

    List decodedApiResponse = json.decode(apiResponse.body);

    if (apiResponse.statusCode != 200) {
      return;
    }

    nearbyContainers.clear();

    for (int i = 0; i < decodedApiResponse.length; i++) {
      double latitude = double.parse(decodedApiResponse[i]["latitude"]);
      double longitude = double.parse(decodedApiResponse[i]["longitude"]);
      LatLng latLng = LatLng(latitude, longitude);
      String assetPath;
      if (decodedApiResponse[i]["foodType"] == "cats") {
        assetPath = "assets/icons/dog1.png";
      } else if (decodedApiResponse[i]["foodType"] == "dogs") {
        assetPath = "assets/icons/cat1.png";
      } else {
        assetPath = "assets/icons/catsAndDogs.png";
      }
      AnimalLocationModel animalLocationModel = AnimalLocationModel(
          distance: (decodedApiResponse[i]["distance"] * 1000),
          lastFeedingDate: decodedApiResponse[i]["lastFeedingDate"],
          id: decodedApiResponse[i]["id"].toString(),
          description: decodedApiResponse[i]["description"],
          foodType: decodedApiResponse[i]["foodType"],
          latLng: latLng,
          imageAssetPath: assetPath,
          numberOfAnimals: decodedApiResponse[i]["numberOfAnimals"].toString());
      nearbyContainers.add(animalLocationModel);
    }
  }

  Future fillNearbyAnimals(LatLng latLng, BuildContext context) async {
    String token = await _auth.getToken();
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
      "latitude": latLng.latitude.toString(),
      "longitude": latLng.longitude.toString()
    };
    var apiResponse =
        await http.get(API + "animal/getNearAnimals", headers: headers);

    List decodedApiResponse = json.decode(apiResponse.body);

    if (apiResponse.statusCode != 200) {
      return;
    }

    nearbyAnimals.clear();

    for (int i = 0; i < decodedApiResponse.length; i++) {
      double latitude = double.parse(decodedApiResponse[i]["latitude"]);
      double longitude = double.parse(decodedApiResponse[i]["longitude"]);
      LatLng latLng = LatLng(latitude, longitude);

      String animalType = "";
      if (decodedApiResponse[i]["animalBreed"] == 0) {
        animalType =
            AppLocalizations.of(context).translate("addHelpScreen_cat");
      } else if (decodedApiResponse[i]["animalBreed"] == 1) {
        animalType =
            AppLocalizations.of(context).translate("addHelpScreen_dog");
      }

      AnimalModel animalModel = AnimalModel(
          animalTypeId: decodedApiResponse[i]["animalBreed"],
          distance: (decodedApiResponse[i]["distance"] * 1000),
          id: decodedApiResponse[i]["id"].toString(),
          description: decodedApiResponse[i]["description"],
          latLng: latLng,
          animalType: animalType,
          photoUrl: decodedApiResponse[i]["photoUrl"]);
      nearbyAnimals.add(animalModel);
    }
  }

  Future addContainer(LatLng latLng, String description, String foodType,
      String numberOfAnimals) async {
    String token = await _auth.getToken();
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };
    var data = {
      "latitude": latLng.latitude,
      "longitude": latLng.longitude,
      "description": description,
      "foodType": foodType,
      "numberOfAnimals": numberOfAnimals
    };

    var body = json.encode(data);

    var apiResponse = await http.post(API + "container/addContainer",
        headers: headers, body: body);

    if (apiResponse.statusCode == 200) {
      String assetPath;
      if (foodType == "cats") {
        assetPath = "assets/icons/dog1.png";
      } else if (foodType == "dogs") {
        assetPath = "assets/icons/cat1.png";
      } else {
        assetPath = "assets/icons/catsAndDogs.png";
      }

      var decodedApiResponse = jsonDecode(apiResponse.body);
      print(decodedApiResponse);      
      nearbyContainers.insert(0,AnimalLocationModel(
          imageAssetPath: assetPath,
          distance: (0),
          lastFeedingDate: decodedApiResponse["lastFeedingDate"].toString(),
          id: decodedApiResponse["id"].toString(),
          description: description,
          foodType: foodType,
          latLng: latLng,
          numberOfAnimals: numberOfAnimals));
    }

    print(apiResponse.body);
  }

  Future feedAnimal(String id) async {
    String token = await _auth.getToken();
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };

    var apiResponse = await http.patch(API + ("container/fillContainer/" + id),
        headers: headers);
    if (apiResponse.statusCode == 200) {
      for (int i = 0; i < nearbyContainers.length; i++) {
        if (nearbyContainers[i].id == id) {
          nearbyContainers[i].lastFeedingDate =
              DateTime.now().toIso8601String();
          break;
        }
      }
    }
    notifyListeners();
  }

  Future addAnimal(
    LatLng latLng,
    String description,
    String animalType,
    String animalTypeName,
    File _imageFile,
  ) async {
    String downloadUrl = "";
    String id = "";
    String token = await _auth.getToken();
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };
    var data = {
      "latitude": latLng.latitude,
      "longitude": latLng.longitude,
      "description": description,
      "animalBreed": animalType,
    };

    var body = json.encode(data);

    var apiResponse =
        await http.post(API + "animal/addAnimal", headers: headers, body: body);

    print(apiResponse.statusCode);

    if (apiResponse.statusCode == 200) {
      if (_imageFile != null) {
        var decodedApiResponse = jsonDecode(apiResponse.body);
        StorageUploadTask uploadTask =
            await FirebaseStorageUploader.startUpload(
                "animalImages/${decodedApiResponse["id"].toString()}.png",
                _imageFile);
        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        print("Upload done");
        if (uploadTask.isComplete) {
          var headers = {
            "Authorization": "Bearer ${token}",
            "Content-Type": "application/json",
          };
          var data = {
            "photoUrl": downloadUrl,
          };
          var body = json.encode(data);
          id = decodedApiResponse["id"].toString();
          var apiResponse2 = await http.patch(
              API + "animal/addPhoto/" + decodedApiResponse["id"].toString(),
              headers: headers,
              body: body);
          print(decodedApiResponse);
          if (apiResponse2.statusCode == 200) {
            //CALL GET NEAR ANIMALS
          } else {
            return 400;
          }
        } else {
          return 600;
        }
      }
    } else {
      return 400;
    }
    nearbyAnimals.insert(0,AnimalModel(
        photoUrl: downloadUrl,
        distance: 0,
        id: id,
        latLng: latLng,
        animalType: animalTypeName,
        description: description,
        animalTypeId: int.parse(animalType)));
    return 200;
  }

  Future helpAnimal(String id) async {
    String token = await _auth.getToken();
    var headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };

    var apiResponse =
        await http.delete(API + "animal/deleteAnimal/" + id, headers: headers);

    if (apiResponse.statusCode == 200) {
      for (int i = 0; i < nearbyAnimals.length; i++) {
        if (nearbyAnimals[i].id == id) {
          StorageReference reference = await FirebaseStorage.instance
              .getReferenceFromUrl(nearbyAnimals[i].photoUrl);
          await reference.delete();
          nearbyAnimals.removeAt(i);
          break;
        }
      }
      notifyListeners();
    }
    return apiResponse.statusCode;
  }
}
