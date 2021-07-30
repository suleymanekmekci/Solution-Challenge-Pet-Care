import 'package:PetCare/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

class AdaptiveWidgets {
  static final bool isIos = Platform.isIOS;

  static Widget app(
      {@required
          bool debugShowCheckedModeBanner,
      @required
          Iterable<Locale> supportedLocales,
      @required
          Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
      @required
          Locale Function(List<Locale>, Iterable<Locale>)
              localeResolutionCallback,
      @required
          Widget home,
      @required
          dynamic routes,
      @required
          List<NavigatorObserver> navigatorObservers}) {
    return isIos
        ? CupertinoApp(
            navigatorObservers: navigatorObservers,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            home: home,
            supportedLocales: supportedLocales,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeResolutionCallback,
            routes: routes,
          )
        : MaterialApp(
            navigatorObservers: navigatorObservers,
            home: home,
            routes: routes,
            localeListResolutionCallback: localeResolutionCallback,
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          );
  }

  static Widget adaptiveAppBar(
      {@required List<Widget> actions,
      @required Text title,
      @required Color backgroundColor,
      @required Color actionsColor}) {
    return isIos
        ? CupertinoNavigationBar(
            //actionsForegroundColor: actionsColor,
            backgroundColor: backgroundColor,
            middle: title,
            trailing: Container(
              width: 88,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ),
          )
        : AppBar(
            actionsIconTheme: IconThemeData(color: actionsColor),
            backgroundColor: backgroundColor,
            title: title,
            actions: actions,
          );
  }

  static Widget adaptiveNavigationbar(
      {@required Function onTap,
      @required Color backgroundColor,
      @required int currentIndex,
      @required Color selectedItemColor,
      @required List<BottomNavigationBarItem> items}) {
    return isIos
        ? CupertinoTabBar(
            inactiveColor: Constants.focusColor,
            items: items,
            backgroundColor: backgroundColor,
            currentIndex: currentIndex,
            onTap: onTap,
            activeColor: selectedItemColor,
          )
        : BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedItemColor: Constants.focusColor,
            onTap: onTap,
            backgroundColor: backgroundColor,
            currentIndex: currentIndex,
            selectedItemColor: selectedItemColor,
            items: items,
          );
  }

  static Widget adaptiveScaffoldWithBottomNavigationBar(
      {@required List<Widget> pageList,
      @required Color backgroundColor,
      @required body,
      @required dynamic bottomNavigationBar}) {
    return isIos
        ? CupertinoTabScaffold(
            tabBar: bottomNavigationBar,
            tabBuilder: (context, index) {
              return pageList[index];
            },
            backgroundColor: backgroundColor,
          )
        : Scaffold(
            backgroundColor: backgroundColor,
            body: body,
            bottomNavigationBar: bottomNavigationBar,
          );
  }

  static Widget adaptiveCheckBox(
      {@required Function onChanged,
      @required bool value,
      @required Color checkColor,
      @required Color activeColor}) {
    return isIos
        ? CupertinoSwitch(
            value: value,
            trackColor: checkColor,
            activeColor: activeColor,
            onChanged: onChanged)
        : Checkbox(
            value: value,
            checkColor: checkColor,
            activeColor: activeColor,
            onChanged: onChanged,
          );
  }

  static Widget adaptiveSwitch(
      {@required Function onChanged,
      @required bool value,
      @required Color checkColor,
      @required Color activeColor}) {
    return isIos
        ? CupertinoSwitch(
            value: value,
            trackColor: checkColor,
            activeColor: activeColor,
            onChanged: onChanged)
        : Switch(
            inactiveTrackColor: checkColor,
            value: value,
            activeTrackColor: activeColor,
            activeColor: Constants.focusColor,
            onChanged: onChanged,
          );
  }

  static Widget adaptiveDropdownButton({
    @required String value,
    @required Color textColor,
    @required Color buttonColor,
    @required List<String> list,
    @required Function updateFunction,
    @required BuildContext context,
    @required String preText,
    @required double width,
  }) {
    return isIos
        ? AdaptiveWidgets.adaptiveRaisedButton(
            context: context,
            width: width,
            //(mediaQuery.size.width - mediaQuery.size.width * .28) / 2 > 120
            //? 120
            //: (mediaQuery.size.width - mediaQuery.size.width * .28) / 2,
            color: buttonColor,
            child: FittedBox(
              child: Text(preText + " " + value,
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ),
            onPressed: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return CupertinoPicker(
                      itemExtent: 30,
                      children: list.map((e) => Text(e)).toList(),
                      onSelectedItemChanged: (index) {
                        updateFunction(list[index]);
                      },
                    );
                  }).then((value) {});
            })
        : Row(
            children: [
              SizedBox(
                  width: width - 150,
                  child:
                      FittedBox(fit: BoxFit.scaleDown, child: Text(preText,style: TextStyle(color: textColor, fontWeight: FontWeight.bold),))),
              SizedBox(
                width: 150,
                //(mediaQuery.size.width - mediaQuery.size.width * .28) / 2 > 160
                //? 160
                //: (mediaQuery.size.width - mediaQuery.size.width * .28) / 2,
                child: FittedBox(
                  child: DropdownButton(
                    value: value,
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                            width: 150,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                            )),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      updateFunction(value);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  static Widget adaptiveFlatButton(
      {@required Widget child, @required Function function}) {
    return isIos
        ? CupertinoButton(
            child: child,
            onPressed: function,
          )
        : FlatButton(onPressed: function, child: child);
  }

  static Widget adaptiveIcon(
      {IconData iosIcon, IconData androidIcon, Color color}) {
    return Icon(
      isIos ? iosIcon : androidIcon,
      color: color,
    );
  }

  static Widget adaptiveIconButton(
      {@required Widget child, @required Function onPressed}) {
    return isIos
        ? CupertinoButton(
            child: child,
            onPressed: onPressed,
            padding: EdgeInsets.all(0),
          )
        : IconButton(icon: child, onPressed: onPressed);
  }

  static Widget adaptiveProgressIndicator() {
    return isIos ? CupertinoActivityIndicator() : CircularProgressIndicator();
  }

  static Widget adaptiveRaisedButton(
      {@required Function onPressed,
      @required Widget child,
      @required Color color,
      double width,
      double height,
      @required BuildContext context,ShapeBorder shape}) {
    return Container(
      width: width != null ? width : MediaQuery.of(context).size.width / 1.5,
      height: height != null ? height : 40,
      child: isIos
          ? CupertinoButton(
              onPressed: onPressed,
              child: child,
              color: color,
              padding: EdgeInsets.all(10),
            )
          : RaisedButton(shape:shape ,
              onPressed: onPressed,
              child: child,
              color: color,
            ),
    );
  }

  static Widget adaptiveScaffold(
      {@required Widget body,
      dynamic appBar,
      @required Color backgroundColor}) {
    return isIos
        ? CupertinoPageScaffold(
            child: body,
            backgroundColor: backgroundColor,
            navigationBar: appBar,
          )
        : Scaffold(
            body: body, backgroundColor: backgroundColor, appBar: appBar);
  }

  static Widget adaptiveSlider({
    @required Function updateFunction,
    @required double max,
    @required double min,
    @required double range,
  }) {
    return isIos
        ? CupertinoSlider(
            value: range,
            onChanged: (newRange) {
              if (newRange < 5 && newRange != 1) {
                newRange = 5;
              } else if (newRange % 5 != 0 && newRange != 1) {
                newRange = newRange - newRange % 5;
              }
              updateFunction(newRange);
            },
            min: min,
            max: max,
          )
        : Slider(
            value: range,
            onChanged: (newRange) {
              if (newRange < 5 && newRange != 1) {
                newRange = 5;
              } else if (newRange % 5 != 0 && newRange != 1) {
                newRange = newRange - newRange % 5;
              }
              updateFunction(newRange);
            },
            divisions: 100,
            label: "${range.round()} km",
            min: min,
            max: max,
          );
  }

  static Widget adaptiveTextField(
      {
        List<TextInputFormatter> inputFormatter,
        @required String labelText,
      @required Function submitFunction,
      TextInputType textInputType,
      @required bool obscureText,
      @required TextEditingController controller,
      IconData iconData,
      @required int maxLines,
      @required String hintText,
      @required double height,
      Function onChanged,
      @required width , @required BoxDecoration decoration,@required double labelTextWidth}) {
    Constants constants = Constants();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        labelText == ""
            ? SizedBox.shrink()
            : Container(
                width: labelTextWidth,
                child: Text(
                  labelText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Constants.focusColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
        labelText == ""
            ? SizedBox.shrink()
            : SizedBox(
                width: 10,
              ),
        Container(
            decoration: decoration,
            alignment: Alignment.centerLeft,
            height: height,
            width: width - labelTextWidth,
            child: isIos
                ? CupertinoTextField(
                  inputFormatters: inputFormatter,
                    onChanged: onChanged,
                    minLines: 1,
                    maxLines: maxLines,
                    placeholder: hintText,
                    placeholderStyle: constants.kHintTextStyle,
                    cursorColor: Constants.focusColor,
                    prefix: Padding(
                      padding: EdgeInsets.only(
                        left: iconData == null ? 0 : 10,
                      ),
                      child: iconData == null
                          ? null
                          : Icon(
                              iconData,
                              color: Colors.white,
                            ),
                    ),
                    onSubmitted: (val) {
                      submitFunction();
                    },
                    obscureText: obscureText,
                    keyboardType: textInputType,
                    style: TextStyle(color: Constants.focusColor),
                    decoration: BoxDecoration(),
                    controller: controller,
                  )
                : TextFormField(
                  inputFormatters: inputFormatter,
                    onChanged: onChanged,
                    onFieldSubmitted: (val) {
                      submitFunction();
                    },
                    minLines: 1,
                    maxLines: maxLines,
                    cursorColor: Constants.primaryColorDark,
                    obscureText: obscureText,
                    keyboardType: textInputType,
                    style: TextStyle(color: Constants.primaryColorDark),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          top: iconData == null ? 0 : 14,
                          left: iconData == null ? 10 : 0),
                      prefixIcon: iconData == null
                          ? null
                          : Icon(
                              iconData,
                              color: Constants.focusColor,
                            ),
                      hintText: hintText,
                      hintStyle: constants.kHintTextStyle,
                    ),
                    controller: controller,
                  ))
      ],
    );
  }

  static Widget loadingWidget() {
    return Container(
      color: Constants.backgroundColor,
      child: Center(
        child: isIos
            ? SpinKitCircle(
                color: Constants.primaryColorDark,
                size: 100,
              )
            : SpinKitDualRing(
                color: Constants.primaryColorDark,
                size: 100,
              ),
      ),
    );
  }

  static Widget adaptiveProfilePageButtons(
      {@required String label,
      @required IconData iconData,
      @required Function onPressed,
      @required BuildContext context}) {
    return adaptiveRaisedButton(
        height: 60,
        width: MediaQuery.of(context).size.width,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  iconData,
                  color: Constants.cardColor,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  label,
                  style: TextStyle(color: Constants.primaryColorDark),
                ),
              ],
            ),
            Icon(
              Icons.arrow_right,
              color: Colors.grey,
            ),
          ],
        ),
        color: Constants.focusColor,
        context: context);
  }

  static Widget alertDialog({
    @required Text title,
    @required Widget content,
  }) {
    return isIos
        ? CupertinoAlertDialog(title: title, content: content)
        : AlertDialog(
            title: title,
            content: content,
          );
  }
}
