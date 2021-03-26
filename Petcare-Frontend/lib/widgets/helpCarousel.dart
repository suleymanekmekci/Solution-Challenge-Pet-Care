import 'package:PetCare/models/animalModel.dart';
import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/screens/animalDetailScreen.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpCarousel extends StatefulWidget {
  @override
  _HelpCarouselState createState() => _HelpCarouselState();
}

class _HelpCarouselState extends State<HelpCarousel> {
  @override
  Widget build(BuildContext context) {
    List<AnimalModel> nearbyAnimals =
        Provider.of<AnimalLocation>(context).nearbyAnimals;
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...nearbyAnimals
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          color: Colors.grey[700]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("helpScreen_needsHelp"),
                            style: TextStyle(
                              color: Constants.focusColor,
                            ),
                          ),
                          SizedBox(height: 10,),
                          SizedBox(
                              height: 60,
                              child: Image(
                                image: AssetImage("assets/icons/animalSad" +
                                    e.animalTypeId.toString() +
                                    ".png"),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            e.distance.round().toString() + " m",
                            style: TextStyle(
                                color: Constants.focusColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AdaptiveWidgets.adaptiveRaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      AnimalDetailScreen.routeName,
                                      arguments: e);
                                },
                                child: FittedBox(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .translate("helpScreen_help"),
                                  style: TextStyle(
                                      color: Constants.primaryColorDark),
                                )),
                                color: Constants.focusColor,
                                context: context),
                          )
                        ],
                      ),
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }
}
