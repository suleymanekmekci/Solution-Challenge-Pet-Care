import 'dart:io';

import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/screens/loadingScreen.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'adaptiveWidgets.dart';
import 'locationInput.dart';

class AddNeedHelp extends StatefulWidget {
  final Function selectPage;
  AddNeedHelp({this.selectPage});
  @override
  _AddNeedHelpState createState() => _AddNeedHelpState();
}

class _AddNeedHelpState extends State<AddNeedHelp> {
  final TextEditingController descriptionController = TextEditingController();
  String dropDownValue = "";
  LatLng selectedLocation;
  String error = "";
  bool _isLoading = false;
  File _imageFile;

  void submit() async {
    if (dropDownValue ==
            AppLocalizations.of(context)
                .translate("addHelpScreen_animalTypeNotSelected") ||
        descriptionController.text == "" ||
        _imageFile == null ||
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

    String animalType = "";
    if (dropDownValue ==
        AppLocalizations.of(context).translate("addHelpScreen_cat")) {
      animalType = "0";
    } else if (dropDownValue ==
        AppLocalizations.of(context).translate("addHelpScreen_dog")) {
      animalType = "1";
    }

    int statusCode = await Provider.of<AnimalLocation>(context, listen: false)
        .addAnimal(selectedLocation, descriptionController.text, animalType,
            dropDownValue, _imageFile);

    print(statusCode);
    widget.selectPage(0);
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      compressFormat: ImageCompressFormat.png,
      cropStyle: CropStyle.circle,
      sourcePath: _imageFile.path,
      androidUiSettings: AndroidUiSettings(
        backgroundColor: Constants.primaryColorLight,
        toolbarTitle: AppLocalizations.of(context)
            .translate("profileEditScreen_cropImage"),
        toolbarColor: Constants.primaryColorLight,
        activeControlsWidgetColor: Constants.primaryColorLight,
        dimmedLayerColor: Constants.backgroundColor,
        toolbarWidgetColor: Constants.focusColor,
        hideBottomControls: false,
      ),
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      File selected = await ImagePicker.pickImage(source: source);
      setState(() {
        _imageFile = selected;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    if (dropDownValue == "") {
      dropDownValue = AppLocalizations.of(context)
          .translate("addHelpScreen_animalTypeNotSelected");
    }
    return _isLoading
        ? Loading(false)
        : ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 0,
                      ),
                      Container(
                        width: 120,
                        height: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(width: 0.5))),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 0.6,
                                        ),
                                        _imageFile != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.file(
                                                  _imageFile,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  "addHelpScreen_noImage"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AdaptiveWidgets.alertDialog(
                                                title: Text(AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        "addHelpScreen_pickASource")),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      SizedBox(height: 10),
                                                      GestureDetector(
                                                        child: Row(
                                                          children: [
                                                            AdaptiveWidgets.adaptiveIcon(
                                                                color: Constants
                                                                    .primaryColorDark,
                                                                androidIcon:
                                                                    Icons.image,
                                                                iosIcon:
                                                                    CupertinoIcons
                                                                        .photo),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      "addHelpScreen_gallery"),
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          _pickImage(ImageSource
                                                              .gallery);
                                                        },
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15)),
                                                      GestureDetector(
                                                        child: Row(
                                                          children: [
                                                            AdaptiveWidgets
                                                                .adaptiveIcon(
                                                              iosIcon:
                                                                  CupertinoIcons
                                                                      .camera,
                                                              androidIcon: Icons
                                                                  .camera_alt,
                                                              color: Constants
                                                                  .primaryColorDark,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      "addHelpScreen_camera"),
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await _pickImage(
                                                              ImageSource
                                                                  .camera);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Constants.primaryColorDark),
                                      child: AdaptiveWidgets.adaptiveIcon(
                                        color: Constants.focusColor,
                                        iosIcon: CupertinoIcons.camera,
                                        androidIcon: Icons.camera_alt,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_imageFile != null)
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await _cropImage();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Constants.primaryColorDark),
                                          child: Icon(
                                            Icons.crop,
                                            color: Constants.focusColor,
                                          ),
                                        ),
                                      ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              AdaptiveWidgets.adaptiveTextField(
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
                            AppLocalizations.of(context).translate(
                                "addHelpScreen_animalTypeNotSelected"))
                          AppLocalizations.of(context)
                              .translate("addHelpScreen_animalTypeNotSelected"),
                        AppLocalizations.of(context)
                            .translate("addHelpScreen_cat"),
                        AppLocalizations.of(context)
                            .translate("addHelpScreen_dog"),
                      ],
                      updateFunction: (value) {
                        setState(() {
                          dropDownValue = value;
                        });
                      },
                      context: context,
                      preText: AppLocalizations.of(context)
                          .translate("addHelpScreen_chooseAnimal"),
                      width: 300),
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
