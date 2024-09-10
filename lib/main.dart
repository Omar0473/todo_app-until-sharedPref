import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/home_screen_first_login.dart';
import 'package:todo_app/login/login_screen.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/register/register_screen.dart';
import 'package:todo_app/models/app_theme.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/providers/app_config_providers.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/templates/shared_preference_utils.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceUtils.init();
  // Platform.isAndroid?  await Firebase.initializeApp(
  //   options:FirebaseOptions(apiKey: 'AIzaSyBGF-ECxb1LOjhEWxHVLT9KSjb7lBqznTg', appId: 'com.example.todo_app', messagingSenderId: '762314732370', projectId: 'todo-app-5bf28')
  // ):  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // await FirebaseFirestore.instance.disableNetwork();
  ///Provider affects all application => Put in runApp()
  String route;
  var token = SharedPreferenceUtils.getData(key: 'token');
  print('token = $token');
  if(token == null){
    route = Login.routeName;
    print(route);
  }
  else{
    route = HomeScreen.routeName;
    print('home = ${HomeScreen.routeName}');
  }
  runApp(
      MultiProvider(providers:[
        ChangeNotifierProvider(create:(context)=>AppConfigProviders()..getData()),  //todo => call function every time calling the provider
        ChangeNotifierProvider(create:(context)=>listProvider()),
        ChangeNotifierProvider(create:(context)=>UserProvider())
  ],
        child:MyApp(route:route),
      )
  );
  }
class MyApp extends StatelessWidget {
  MyApp({required this.route});
  String route;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProviders>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale:Locale(provider.language),
      debugShowCheckedModeBanner:false,
      initialRoute:route,
      routes:{
        HomeScreen.routeName : (context)=>HomeScreen(),
        Register.routeName : (context)=>Register(),
        Login.routeName : (context)=>Login(),
        HomeLogin.routeName : (context)=>HomeLogin()
      },
      theme:AppTheme.light,
      darkTheme:AppTheme.Dark,
      themeMode: provider.appMode,
      //ThemeMode.light
    );
  }
}
///update/edit task
///authentication page
///localizations ==>ar
///clean code
///alertdialog class(reusable widget)
///save date state
///update function
///
///
///
/// update date
/// Ask Eng Amira
/// repair exceptions
/// clean code
/// alertdialog
/// last session