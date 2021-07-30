import 'package:PetCare/providers/currentUser.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/services/auth.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loadingScreen.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  LoginScreen({
    this.toggleView,
  });
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String error = "";
  bool isLoading = false;
  AuthService _auth = AuthService();

  Future login() async {
    if (emailController.text == "") {
      setState(() {
        error = AppLocalizations.of(context)
            .translate("loginScreen_error_emptyEmail");
      });
    } else if (passwordController.text == "") {
      setState(() {
        error = AppLocalizations.of(context)
            .translate("loginScreen_error_emptyPassword");
      });
    } else {
      setState(() {
        error = "";
        isLoading = true;
      });
      dynamic result =
          await _auth.signIn(emailController.text, passwordController.text);
      if (result == null) {
        setState(() {
          error = AppLocalizations.of(context)
              .translate("loginScreen_error_cannotLogin");
          isLoading = false;
        });
      } else {
        result = await Provider.of<CurrentUser>(context, listen: false)
            .setCurrentUserInfo(context);
        /*
        if (result != 200) {
          await Provider.of<CurrentUser>(context, listen: false).logout();
          setState(() {
            error = "Sunucuya bağlanılamadı";
            isLoading = false;
          });
        }
        */
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
                          AppLocalizations.of(context).translate("loginScreen_topText"),
                          style: TextStyle(
                              fontSize: 25,
                              color: Constants.focusColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (error != "")
                        Column(
                          children: [
                            SizedBox(height: 14.5,),
                            Text(
                              error,
                              style: TextStyle(
                                  color: Constants.focusColor, fontSize: 18,fontWeight: FontWeight.bold),
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
                          controller: emailController,
                          height: 50,
                          hintText: "",
                          labelText: AppLocalizations.of(context).translate("loginScreen_emailTextField_label"),
                          maxLines: 1,
                          obscureText: false,
                          submitFunction: login,
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
                          labelText: AppLocalizations.of(context).translate("loginScreen_passwordTextField_label"),
                          maxLines: 1,
                          obscureText: true,
                          submitFunction: login,
                          iconData: null,
                          onChanged: null,
                          textInputType: TextInputType.emailAddress),
                      SizedBox(
                        height: 100,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: AdaptiveWidgets.adaptiveRaisedButton(
                            onPressed: login,
                            child: Text(AppLocalizations.of(context).translate("loginScreen_loginButton")),
                            color: Constants.focusColor,
                            context: context),
                      ),
                      SizedBox(height: 40,),
                      Container(
                        width: mediaQuery.size.width-40,
                        alignment: Alignment.bottomRight,
                        child:                         GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context).translate(
                                          "loginScreen_dontHaveAnAccountText"),
                                      style: TextStyle(color: Constants.focusColor,fontWeight: FontWeight.w300)),
                                  TextSpan(
                                      text: AppLocalizations.of(context)
                                          .translate("loginScreen_signUpText"),
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
