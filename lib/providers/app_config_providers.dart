import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/templates/shared_preference_utils.dart';
class AppConfigProviders extends ChangeNotifier{
  String language = 'en';
  ThemeMode appMode = ThemeMode.light;
  Future<void> getData()async{
    //todo=> We want to update the values of our variables to be able to retrieve them every time we open the application
    language = SharedPreferenceUtils.getData(key:'language') as String;
    appMode = SharedPreferenceUtils.getData(key:'theme') == "dark" ?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
  Future<void> changeLanguage(String newLanguage)async{
    if(newLanguage==language){
      return ;
    }
    await SharedPreferenceUtils.saveData(key:'language', value: newLanguage);
    language = newLanguage;
    notifyListeners();
  }
  Future<void> changeMode(ThemeMode newMode)async{
    if(newMode==appMode) {
      return ;
    }
    await SharedPreferenceUtils.saveData(key: 'theme', value: newMode == ThemeMode.dark? "dark" : "light"); //no themeMode Saving in SharedPreference so we will save it as String by checking the mode
    appMode = newMode;
    notifyListeners();
      }
}