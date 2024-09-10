import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase/firebase.dart';
import 'package:todo_app/login/login_screen.dart';
import 'package:todo_app/models/users.dart';
import 'package:todo_app/templates/shared_preference_utils.dart';
import 'package:todo_app/templates/text_form_field_temp.dart';

import '../models/colors.dart';
class Register extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
///object from the controller
  TextEditingController emailController = TextEditingController();
///object from the controller
  TextEditingController passController = TextEditingController();
///object from the controller
  TextEditingController confirmPassController = TextEditingController();
///object from the controller
  bool showPass = true;
  bool showConfirmPass = true;
  late bool isDark;
  @override
  Widget build(BuildContext context) {
    isDark = Theme.of(context).brightness == Brightness.dark;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight:MediaQuery.of(context).size.height*0.1804597701149425,
        // title:Text('Create Account'),
        //centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                  key:formKey,
                  child: Container(
                    margin: EdgeInsets.all(3),
                    child: Column(
                children: [
                    Column(
                      children: [
                        Text('Sign up',textAlign:TextAlign.center,
                            style:TextStyle(
                                fontSize:40,
                                fontWeight:FontWeight.bold)),
                        SizedBox(height:5),
                        Text("Create an account, it's totally free!", textAlign:TextAlign.center,
                            style:TextStyle(
                                fontSize: 20
                            )),
                      ],
                    ),
                    SizedBox(height:15),
                    Container(
                        margin:EdgeInsets.all(7),
                        child: Image.asset('assets/images/reg.png',height:height*0.17)),
                    TextForm(
                        textLabel:'Username',
                        label:'Username',controller:nameController,
                        validator:(text){
                          if(text == null || text.isEmpty){
                            return 'Please enter your Username';
                          }
                          return null; ///valid✔️
                        }),
                    TextForm(
                        textLabel:'Email',
                        label:'Email',controller:emailController,
                        keyboardType:TextInputType.emailAddress,
                        validator:(text){
                          if(text == null || text.isEmpty){
                            return 'Please enter your Email';
                          }
                          final bool emailValid =
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(emailController.text);
                          if(emailValid==false){
                            return 'Please enter a valid Email';
                          }
                          return null; ///valid✔️
                        }),
                    TextForm(
                        textLabel:'Password',
                        rightIcon: InkWell(
                            onTap:(){
                              showPass = !showPass; ///convert the value to it's alternative
                              setState(() {

                              });
                            },
                            child:
                                showPass==true?
                            Icon(Icons.visibility_off):Icon(Icons.visibility)
                        ),
                        label:'Password',controller:passController,
                        keyboardType:TextInputType.phone,
                        obscure:showPass,
                        validator:(text){
                          if(text == null || text.trim().isEmpty){
                            return 'Please enter your Password';
                          }
                          if(passController.text.length<6){
                            return 'Password must be at least 6 characters!';
                          }
                          return null; ///valid✔️
                        }),
                    TextForm(
                        textLabel:'Confirm Password',
                        rightIcon: InkWell(
                            onTap:(){
                              showConfirmPass = !showConfirmPass; ///convert the value to it's alternative
                              setState(() {

                              });
                            },
                            child:
                                showConfirmPass==true?
                            Icon(Icons.visibility_off):Icon(Icons.visibility)
                        ),
                        label:'Confirm Password',controller:confirmPassController,
                        keyboardType:TextInputType.phone,
                        obscure:showConfirmPass,
                        validator:(text){
                          if(text == null || text.trim().isEmpty){
                            return 'Please confirm your Password';
                          }
                          if(passController.text.length<6){
                            return 'Password must be at least 6 characters!';
                          }
                          if(text!=passController.text){
                            return "Password doesn't match";
                          }
                          return null; ///valid✔️
                        }),
                ],
              ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    onPressed: (){
                      register();
                      SharedPreferenceUtils.removeValue(key: 'email');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('Create Account',style:TextStyle(
                        fontSize: 20,
                        fontWeight:FontWeight.bold,
                      )),
                    )),
              ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text('Already have an account?',style:TextStyle(
                     fontSize:17,
                     fontWeight:FontWeight.w300
                 )),
                 TextButton(onPressed:
                     (){Navigator.pushReplacementNamed(context, Login.routeName);},
                     child:Text('Log in',style:TextStyle(
                         fontSize: 20,
                         fontWeight:FontWeight.w700,
                         color:isDark?AppColors.primaryColorDark:AppColors.primaryColor
                     )))
               ],
             )
            ],
          ),
        ),
      ),
    );
  }

  void register()async{
    if(formKey.currentState!.validate()==true){
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );
        /// After creating user with email and password => hide loading and add to collection
        Users user = Users(
            id: credential.user?.uid ?? '', /// From credentials => auto id created by firebase auth
            name: nameController.text,
            email: emailController.text
        );
        FireBaseConfig.addUserToCollection(user);
        print(credential.user?.uid ?? 'Nothing');
        Navigator.pushNamed(context, Login.routeName);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
