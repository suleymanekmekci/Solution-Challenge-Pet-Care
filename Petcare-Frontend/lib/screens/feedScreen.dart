import 'package:PetCare/models/animalLocationModel.dart';
import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  static String routeName = "/feedScreen";

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    AnimalLocationModel animalLocationModel =
        ModalRoute.of(context).settings.arguments;
    return AdaptiveWidgets.adaptiveScaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AdaptiveWidgets.adaptiveAppBar(
            actions: [],
            title: Text(animalLocationModel.description),
            backgroundColor: Constants.primaryColorDark,
            actionsColor: Constants.focusColor),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: ListView(
            children: [
              Image(
                image: AssetImage(animalLocationModel.imageAssetPath),
                height: 180,
              ),
              SizedBox(
                height: 20,
              ),
              AdaptiveWidgets.adaptiveRaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await Provider.of<AnimalLocation>(context,
                                  listen: false)
                              .feedAnimal(animalLocationModel.id);
                          if (this.mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  child: Text(
                    AppLocalizations.of(context).translate("feedScreen_feed"),
                    style: TextStyle(color: Constants.focusColor, fontSize: 18),
                  ),
                  color: Constants.primaryColorDark,
                  width: MediaQuery.of(context).size.width - 200,
                  context: context),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context).translate("feedScreen_lastFeedingTime"),
                    style: TextStyle(color: Constants.focusColor, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          animalLocationModel.lastFeedingDate.substring(0, 10) +
                              "  "),
                      Text(animalLocationModel.lastFeedingDate
                          .substring(11, 19)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
