import 'package:PetCare/providers/currentUser.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/services/auth.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'loadingScreen.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  RegisterScreen({
    this.toggleView,
  });
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String error = "";
  bool isLoading = false;
  AuthService _auth = AuthService();

  Future register() async {
    if (fullNameController.text == "") {
      setState(() {
        error = AppLocalizations.of(context)
            .translate("registerScreen_error_nameEmpty");
      });
    } else if (emailController.text == "") {
      setState(() {
        error = AppLocalizations.of(context)
            .translate("registerScreen_error_emailEmpty");
      });
    } else if (passwordController.text == "") {
      setState(() {
        error = AppLocalizations.of(context)
            .translate("registerScreen_error_passwordEmpty");
      });
    } else {
      setState(() {
        error = "";
        isLoading = true;
      });
      dynamic result = await _auth.registerWithEmailAndPassword(
          emailController.text, passwordController.text);

      if (result == null) {
        setState(() {
          error = AppLocalizations.of(context)
              .translate("registerScreen_error_thisEmailIsTaken");

          isLoading = false;
        });
      } else {
        dynamic databaseResult =
            await Provider.of<CurrentUser>(context, listen: false)
                .registerUser(fullNameController.text);

        if (databaseResult == 200 || databaseResult == 503) {
          Provider.of<CurrentUser>(context, listen: false)
              .setCurrentUserInfo(context);
        } else {
          setState(() {
            _auth.signOut();
            error = AppLocalizations.of(context)
                .translate("registerScreen_error_error");
            isLoading = false;
          });
        }
      }
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Loading(false);
    }
    var mediaQuery = MediaQuery.of(context);
    return AdaptiveWidgets.adaptiveScaffold(
      backgroundColor: Constants.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: mediaQuery.size.height,
                width: mediaQuery.size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          "assets/background/loginScreenBackground.png"),
                      alignment: Alignment.topCenter),
                )),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("registerScreen_topText"),
                          style: TextStyle(
                              fontSize: 25,
                              color: Constants.focusColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (error != "")
                        Column(
                          children: [
                            SizedBox(
                              height: 14.5,
                            ),
                            Text(
                              error,
                              style: TextStyle(
                                  color: Constants.focusColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: error == "" ? 50 : 14.5,
                      ),
                      AdaptiveWidgets.adaptiveTextField(
                          labelTextWidth: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          width: mediaQuery.size.width - 60,
                          controller: fullNameController,
                          height: 50,
                          hintText: "",
                          labelText: AppLocalizations.of(context)
                              .translate("registerScreen_nameTextField_label"),
                          maxLines: 1,
                          obscureText: false,
                          submitFunction: register,
                          iconData: null,
                          onChanged: null,
                          textInputType: TextInputType.emailAddress),
                      SizedBox(
                        height: 25,
                      ),
                      AdaptiveWidgets.adaptiveTextField(
                          labelTextWidth: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          width: mediaQuery.size.width - 60,
                          controller: emailController,
                          height: 50,
                          hintText: "",
                          labelText: AppLocalizations.of(context)
                              .translate("loginScreen_emailTextField_label"),
                          maxLines: 1,
                          obscureText: false,
                          submitFunction: register,
                          iconData: null,
                          onChanged: null,
                          textInputType: TextInputType.emailAddress),
                      SizedBox(
                        height: 25,
                      ),
                      AdaptiveWidgets.adaptiveTextField(
                          labelTextWidth: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          width: mediaQuery.size.width - 60,
                          controller: passwordController,
                          height: 50,
                          hintText: "",
                          labelText: AppLocalizations.of(context)
                              .translate("loginScreen_passwordTextField_label"),
                          maxLines: 1,
                          obscureText: true,
                          submitFunction: register,
                          iconData: null,
                          onChanged: null,
                          textInputType: TextInputType.emailAddress),
                      SizedBox(
                        height: 100,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: AdaptiveWidgets.adaptiveRaisedButton(
                            onPressed: register,
                            child: Text(AppLocalizations.of(context)
                                .translate("registerScreen_registerText")),
                            color: Constants.focusColor,
                            context: context),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: mediaQuery.size.width - 40,
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context).translate(
                                          "registerScreen_alreadyHaveAnAccountText"),
                                      style: TextStyle(
                                          color: Constants.focusColor,
                                          fontWeight: FontWeight.w300)),
                                  TextSpan(
                                      text: AppLocalizations.of(context)
                                          .translate(
                                              "registerScreen_signInText"),
                                      style: TextStyle(
                                          color: Constants.focusColor,
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
