import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/login/login_screen.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/register/register_screen.dart';
class HomeLogin extends StatelessWidget {
  static const String routeName = 'home_screen_login';
  late bool isDark;
  @override
  Widget build(BuildContext context) {
    isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:isDark?AppColors.primaryColorDark:AppColors.primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text('Welcome',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  )),
                Text('The Art of Accomplishment : ToDo Lists that Inspire',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize:20,
                        color:Colors.teal)),
              ],
            ),
            Image.asset('assets/images/welcome.png',alignment:Alignment.center),
            ElevatedButton(
                onPressed:(){Navigator.pushNamed(context, Login.routeName);},
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text('Login',
                      style:TextStyle(
                          color:isDark?AppColors.white:AppColors.blackDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: isDark?AppColors.backgroundDark:AppColors.backgroundLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(color:isDark?AppColors.white:AppColors.blackDark))),
            ElevatedButton(
                onPressed: (){Navigator.pushNamed(context, Register.routeName);},
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text('Sign up',
                      style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )),
                ),
                style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: isDark?AppColors.primaryColorDark:AppColors.primaryColor
                ))
          ],
        ),
      ),
    );
  }
}
