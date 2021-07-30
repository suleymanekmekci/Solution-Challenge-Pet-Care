import 'package:PetCare/models/animalModel.dart';
import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalDetailScreen extends StatefulWidget {
  static String routeName = "/animalDetailScreen";

  @override
  _AnimalDetailScreenState createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    AnimalModel animalModel = ModalRoute.of(context).settings.arguments;
    return AdaptiveWidgets.adaptiveScaffold(
        backgroundColor: Colors.grey[800],
        appBar: AdaptiveWidgets.adaptiveAppBar(
            actions: [],
            title: Text(animalModel.description),
            backgroundColor: Constants.primaryColorDark,
            actionsColor: Constants.focusColor),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: ListView(
            children: [
              Image(
                image: AssetImage("assets/icons/animalSad" +
                    animalModel.animalTypeId.toString() +
                    ".png"),
                height: 120,
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
                          int result = await Provider.of<AnimalLocation>(
                                  context,
                                  listen: false)
                              .helpAnimal(animalModel.id);
                          if (result == 200) {
                            Navigator.of(context).pop();
                          } else {
                            if (this.mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                  child: Text(
                    AppLocalizations.of(context).translate("helpScreen_help"),
                    style: TextStyle(color: Constants.focusColor, fontSize: 18),
                  ),
                  color: Constants.primaryColorDark,
                  width: MediaQuery.of(context).size.width - 200,
                  context: context),
              SizedBox(
                height: 40,
              ),
              Container(
                  decoration: BoxDecoration(color: Colors.blueGrey[800]),
                  padding: EdgeInsets.all(9),
                  height: 280,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate("helpScreen_description"),
                        style: TextStyle(
                            color: Constants.hintColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 80),
                          child: SingleChildScrollView(
                              child: Text(
                            animalModel.description,
                            style: TextStyle(color: Constants.focusColor),
                          ))),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          child: CachedNetworkImage(
                            imageUrl: animalModel.photoUrl,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
