import 'package:PetCare/models/animalLocationModel.dart';
import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/screens/feedScreen.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedCarousel extends StatefulWidget {
  @override
  _FeedCarouselState createState() => _FeedCarouselState();
}

class _FeedCarouselState extends State<FeedCarousel> {
  @override
  Widget build(BuildContext context) {
    List<AnimalLocationModel> nearbyContainers =
        Provider.of<AnimalLocation>(context).nearbyContainers;
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...nearbyContainers
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          color: Constants.primaryColorDark),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate("feedScreen_lastFeedingTime"),
                            style: TextStyle(color: Constants.hintColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            e.lastFeedingDate.substring(0, 10) +
                                "  " +
                                e.lastFeedingDate.substring(11, 19),
                            style: TextStyle(color: Constants.focusColor,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              height: 60,
                              child: Image(
                                image: AssetImage(e.imageAssetPath),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(e.distance.round().toString() + " m",style: TextStyle(color: Constants.hintColor,fontWeight: FontWeight.bold),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AdaptiveWidgets.adaptiveRaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      FeedScreen.routeName,
                                      arguments: e);
                                },
                                child: FittedBox(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .translate("feedScreen_feed"),
                                  style: TextStyle(color: Constants.primaryColorDark),
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
