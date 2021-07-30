
import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  static SharedPreferences preferences;

  static Future init() async {
    preferences = await SharedPreferences.getInstance();
  }
}

enum SharedKeys { wathcedIntro  ,rememberMe}
