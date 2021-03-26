import 'package:PetCare/services/app_localizations.dart';
import 'package:PetCare/utilities/constants.dart';
import 'package:PetCare/widgets/adaptiveWidgets.dart';
import 'package:PetCare/widgets/addFeed.dart';
import 'package:PetCare/widgets/addNeedHelp.dart';
import 'package:PetCare/widgets/mainMap.dart';
import 'package:PetCare/widgets/profileWidget.dart';
import 'package:PetCare/widgets/searchWidget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _pages = [];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.length == 0) {
      _pages = [
        MainMapWidget(),
        ProfileWidget(),
        SearchWidget(),
        AddFeed(
          selectPage: _selectPage,
        ),
        AddNeedHelp(
          selectPage: _selectPage,
        ),
      ];
    }
    return AdaptiveWidgets.adaptiveScaffoldWithBottomNavigationBar(
      pageList: _pages,
      bottomNavigationBar: AdaptiveWidgets.adaptiveNavigationbar(
        onTap: _selectPage,
        backgroundColor: Constants.focusColor,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Constants.cardColor,
        items: [
          BottomNavigationBarItem(
              activeIcon: Column(
                children: [
                  Container(
                    child: Image(image: AssetImage("assets/icons/homeActive.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_home"),style: TextStyle(color: Constants.cardColor),)
                ],
              ),
              icon: Column(
                children: [
                  Container(
                    child:  Image(image: AssetImage("assets/icons/homeInactive.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_home"),style: TextStyle(color: Colors.grey,))
                ],
              ),
              label: ""),
          BottomNavigationBarItem(
              activeIcon: Column(
                children: [
                  Container(
                    child: Image(image: AssetImage("assets/icons/profileActive.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_profile"),style: TextStyle(color: Constants.cardColor),)
                ],
              ),
              icon: Column(
                children: [
                  Container(
                    child:  Image(image: AssetImage("assets/icons/profileInactive.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_profile"),style: TextStyle(color: Colors.grey,))
                ],
              ),
              label: ""),
          BottomNavigationBarItem(
              activeIcon: Column(
                children: [
                  Container(
                    child: Image(image: AssetImage("assets/icons/activeSearch.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_search"),style: TextStyle(color: Constants.cardColor),)
                ],
              ),
              icon: Column(
                children: [
                  Container(
                    child:  Image(image: AssetImage("assets/icons/inactiveSearch.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_search"),style: TextStyle(color: Colors.grey,))
                ],
              ),
              label: ""),
          BottomNavigationBarItem(
              activeIcon: Column(
                children: [
                  Container(
                    child: Image(image: AssetImage("assets/icons/activeFood.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_feedlog"),style: TextStyle(color: Constants.cardColor),)
                ],
              ),
              icon: Column(
                children: [
                  Container(
                    child:  Image(image: AssetImage("assets/icons/inactiveFood.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_feedlog"),style: TextStyle(color: Colors.grey),)
                ],
              ),
              label: ""),
          BottomNavigationBarItem(
              activeIcon: Column(
                children: [
                  Container(
                    child: Image(image: AssetImage("assets/icons/activeAddHelp.png"),),
                    height: 20,
                    width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_introduce"),style: TextStyle(color: Constants.cardColor),)
                ],
              ),
              icon: Column(
                children: [
                  Container(
                    child:  Image(image: AssetImage("assets/icons/inactiveAddHelp.png"),),
                        height: 20,
                        width: 20,
                  ),
                  Text(AppLocalizations.of(context).translate("mainScreen_introduce"),style: TextStyle(color: Colors.grey,))
                ],
              ),
              label: ""),
        ],
      ),
      backgroundColor: Constants.backgroundColor,
      body: _pages[_selectedPageIndex],
    );
  }
}
