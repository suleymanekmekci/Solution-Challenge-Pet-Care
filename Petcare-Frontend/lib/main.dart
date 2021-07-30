import 'package:PetCare/providers/animalLocation.dart';
import 'package:PetCare/providers/currentUser.dart';
import 'package:PetCare/screens/animalDetailScreen.dart';
import 'package:PetCare/screens/feedScreen.dart';
import 'package:PetCare/screens/loadingScreen.dart';
import 'package:PetCare/screens/loginScreen.dart';
import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/services/sharedPreferences.dart';
import 'package:PetCare/services/wrapper.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
  await SharedManager.init();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>AnimalLocation(),
          child: ChangeNotifierProvider(
        create: (_) => CurrentUser(),
        child: GestureDetector(
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: AdaptiveWidgets.app(
            navigatorObservers: [],
            debugShowCheckedModeBanner: false,
            supportedLocales: [Locale("en", "UK"), Locale("tr", "TR")],
            localizationsDelegates: [
                        GlobalCupertinoLocalizations.delegate,
                        DefaultCupertinoLocalizations.delegate,
                        DefaultWidgetsLocalizations.delegate,
                        DefaultCupertinoLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        AppLocalizations.delegate,

            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.countryCode == locale[0].countryCode &&
                    supportedLocale.languageCode == locale[0].languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            home: FutureBuilder(
              future: Firebase.initializeApp(),
              builder: (context, snaphot) {
                if (snaphot.connectionState == ConnectionState.done) {
                  return Wrapper();
                } else {
                  return Loading(false);
                }
              },
            ),
            routes: {
              FeedScreen.routeName: (ctx) => FeedScreen(),
              AnimalDetailScreen.routeName: (ctx)=>AnimalDetailScreen(),
            },
          ),
        ),
      ),
    );
  }
}
