import 'package:PetCare/utilities/constants.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

//This class is for a loading screen which takes up the entire screen
class Loading extends StatelessWidget {
  bool willPop = false;
  Loading(bool b) {
    willPop = b;
  }
  static String routeName = "/loadingScreen";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => willPop,
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Container(
          color: Constants.backgroundColor,
          child: Center(
            child:  SpinKitDualRing(
                    color: Constants.focusColor,
                    size: 100,
                  ),
          ),
        ),
      ),
    );
  }
}
