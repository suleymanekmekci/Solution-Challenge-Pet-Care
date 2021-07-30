import 'package:PetCare/models/customUser.dart';
import 'package:PetCare/providers/currentUser.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CustomUser currentUser = Provider.of<CurrentUser>(context).currentUser;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Text(
          AppLocalizations.of(context).translate("profileScreen_profile"),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Constants.focusColor),
        )),
        SizedBox(height: 20,),
        Text(currentUser.fullName),
        SizedBox(height: 20,),
        AdaptiveWidgets.adaptiveRaisedButton(
            onPressed: () async {
              await Provider.of<CurrentUser>(context, listen: false).logout();
            },
            child: Text(AppLocalizations.of(context).translate("profileScreen_logout"),style: TextStyle(color: Constants.primaryColorDark),),
            color: Constants.focusColor,
            context: context)
      ],
    );
  }
}
