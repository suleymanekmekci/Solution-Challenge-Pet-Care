import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/feedCarousel.dart';
import 'package:PetCare/widgets/helpCarousel.dart';
import "package:flutter/material.dart";

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(AppLocalizations.of(context).translate("searchScreen_needsFeed"),style: TextStyle(color: Constants.focusColor,fontSize: 18,fontWeight: FontWeight.bold),),
        ),
        
        FeedCarousel(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(AppLocalizations.of(context).translate("searchScreen_needsHelp"),style: TextStyle(color: Constants.focusColor,fontSize: 18,fontWeight: FontWeight.bold),),
        ),
        HelpCarousel(),
      ],
    );
  }
}
