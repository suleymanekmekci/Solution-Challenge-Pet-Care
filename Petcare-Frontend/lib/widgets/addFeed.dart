import 'package:PetCare/models/animalLocationModel.dart';
import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/screens/loadingScreen.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'adaptiveWidgets.dart';
import 'locationInput.dart';

class AddFeed extends StatefulWidget {
  final Function selectPage;
  AddFeed({this.selectPage});
  @override
  _AddFeedState createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberOfAnimalController =
      TextEditingController();
  String dropDownValue = "";
  LatLng selectedLocation;
  String error = "";
  bool _isLoading = false;

  Future submit() async {
    if (dropDownValue ==
            AppLocalizations.of(context)
                .translate("addFeedScreen_foodTypeNotSelected") ||
        descriptionController.text == "" ||
        numberOfAnimalController.text == "" ||
        selectedLocation == null) {
      setState(() {
        error = AppLocalizations.of(context)
            .translate("addFeedScreen_error_fillEverything");
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });

    String foodType = "";
    if (dropDownValue ==
        AppLocalizations.of(context).translate("addFeedScreen_cats")) {
      foodType = "0";
    } else if (dropDownValue ==
        AppLocalizations.of(context).translate("addFeedScreen_dogs")) {
      foodType = "1";
    } else if (dropDownValue ==
        AppLocalizations.of(context).translate("addFeedScreen_catsAndDogs")) {
      foodType = "2";
    } else if (dropDownValue ==
        AppLocalizations.of(context).translate("addFeedScreen_water")) {
      foodType = "3";
    }

    await Provider.of<AnimalLocation>(context, listen: false).addContainer(
        selectedLocation,
        descriptionController.text,
        foodType,
        numberOfAnimalController.text);

    widget.selectPage(0);
  }

  @override
  Widget build(BuildContext context) {
    if (dropDownValue == "") {
      dropDownValue = AppLocalizations.of(context)
          .translate("addFeedScreen_foodTypeNotSelected");
    }

    var mediaQuery = MediaQuery.of(context);
    return _isLoading
        ? Loading(false)
        : ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              AdaptiveWidgets.adaptiveTextField(
                  labelTextWidth: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 6.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 20,
                  height: mediaQuery.size.height / 3 - 100,
                  controller: descriptionController,
                  labelText: AppLocalizations.of(context)
                      .translate("addFeedScreen_description"),
                  obscureText: false,
                  hintText: AppLocalizations.of(context)
                      .translate("addFeedScreen_description"),
                  textInputType: TextInputType.multiline,
                  submitFunction: submit,
                  width: mediaQuery.size.width - 50,
                  onChanged: (String val) {}),
              SizedBox(
                height: 20,
              ),
              LocationInput(
                saveLocation: (LatLng latLng) {
                  selectedLocation = latLng;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdaptiveWidgets.adaptiveDropdownButton(
                      value: dropDownValue,
                      textColor: Constants.focusColor,
                      buttonColor: Constants.focusColor,
                      list: [
                        if (dropDownValue ==
                            AppLocalizations.of(context)
                                .translate("addFeedScreen_foodTypeNotSelected"))
                          AppLocalizations.of(context)
                              .translate("addFeedScreen_foodTypeNotSelected"),
                        AppLocalizations.of(context)
                            .translate("addFeedScreen_cats"),
                        AppLocalizations.of(context)
                            .translate("addFeedScreen_dogs"),
                        AppLocalizations.of(context)
                            .translate("addFeedScreen_catsAndDogs"),
                        AppLocalizations.of(context)
                            .translate("addFeedScreen_water")
                      ],
                      updateFunction: (value) {
                        setState(() {
                          dropDownValue = value;
                        });
                      },
                      context: context,
                      preText: AppLocalizations.of(context)
                          .translate("addFeedScreen_foodType"),
                      width: 300),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdaptiveWidgets.adaptiveTextField(
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      labelTextWidth: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 6.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      height: 40,
                      controller: numberOfAnimalController,
                      labelText: AppLocalizations.of(context)
                          .translate("addFeedScreen_numberOfAnimals"),
                      obscureText: false,
                      hintText: "",
                      textInputType: TextInputType.numberWithOptions(),
                      submitFunction: submit,
                      width: 180,
                      onChanged: (String val) {}),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  error,
                  style: TextStyle(
                      color: Constants.focusColor, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: AdaptiveWidgets.adaptiveRaisedButton(
                      onPressed: () async {
                        await submit();
                      },
                      child: Text(AppLocalizations.of(context)
                          .translate("addFeedScreen_add")),
                      color: Constants.focusColor,
                      context: context,
                      width: 0),
                ),
              ),
            ],
          );
  }
}
