import 'package:PetCare/providers/currentUser.dart';
import 'package:PetCare/screens/homeScreen.dart';
import 'package:PetCare/screens/loadingScreen.dart';
import 'package:PetCare/screens/loginScreen.dart';
import 'package:PetCare/screens/registerScreen.dart';
import 'package:PetCare/services/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

//This class is for wrapping the home , login and register screens
class Wrapper extends StatefulWidget {
  final AuthService _auth = AuthService();
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoading = false;

  bool showLogin = true;

  Future<dynamic> isLoggedIn;

  SharedPreferences prefs;
  bool watchedIntro;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  Future<bool> loggedIncheck() async {
    /*
    prefs = await SharedPreferences.getInstance();
    watchedIntro = prefs.getBool('watchedIntro') ?? false;
    */

    prefs = SharedManager.preferences;

    if (prefs.getBool(SharedKeys.rememberMe.toString()) == null) {
      await prefs.setBool(SharedKeys.rememberMe.toString(), false);
    }

    if (prefs.getBool(SharedKeys.wathcedIntro.toString()) == null) {
      await prefs.setBool(SharedKeys.wathcedIntro.toString(), false);
    }

    watchedIntro = prefs.getBool(SharedKeys.wathcedIntro.toString()) ?? false;

/*
    if (prefs.getBool(SharedKeys.rememberMe.toString()) == false) {
      await Provider.of<CurrentUser>(context, listen: false).logout();
      return true;
    }
    */

    var result = await Provider.of<CurrentUser>(context, listen: false)
        .setCurrentUserInfo(context);
    if (result != 200) {
      Provider.of<CurrentUser>(context, listen: false).logout();
      return false;
    }
    return true;
  }

  initState() {
    super.initState();
    isLoggedIn = loggedIncheck();
  }

  Widget build(BuildContext context) {
    //return home or login
    return FutureBuilder(
      future: isLoggedIn,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading(false);
        } else {
          if (Provider.of<CurrentUser>(context).currentUser == null) {
            if (showLogin) {
              return LoginScreen(
                  toggleView: toggleView,
                  );
            } else {
              return RegisterScreen(
                  toggleView: toggleView,
                  );
            }
          } else {
            return HomeScreen();
          }
        }
      },
    );
  }
}
