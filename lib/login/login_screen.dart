import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase/firebase.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/register/register_screen.dart';
import 'package:todo_app/templates/shared_preference_utils.dart';
import 'package:todo_app/templates/text_form_field_temp.dart';

import '../models/users.dart';
class Login extends StatefulWidget {
  static const routeName = 'login_screen';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userName = TextEditingController();

  TextEditingController password = TextEditingController();

  bool showPass = true;

  late bool isDark;

  var formKey = GlobalKey<FormState>();
 @override
  void initState() {
    // TODO: The initState method is a special method in Flutter used to initialize a stateful widget. It is called once when the widget is inserted into the widget tree, and it's typically used to perform tasks that need to happen when the widget is first created, like:
   // Initialize data: If you need to fetch some data or set up variables before rendering, you can do it in initState.
   // Set up listeners: If you are listening to streams, animations, or other events, you usually set up those listeners in initState.
   // Initialize controllers: If your widget uses things like TextEditingController or AnimationController, they are often created and initialized in initState.
    super.initState();
    getEmail();
  }
 void getEmail()async{
   String? savedEmail = SharedPreferenceUtils.getData(key: 'email') as String;
   userName.text = savedEmail;
 }


  @override
  Widget build(BuildContext context) {
    var uProvider = Provider.of<UserProvider>(context);
    var lProvider = Provider.of<listProvider>(context);
    double height = MediaQuery.of(context).size.height;
    isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      //  toolbarHeight:MediaQuery.of(context).size.height*0.1804597701149425,
      //   title:Text('Login',
      //       style:TextStyle(fontSize:30)),
        elevation:0,
      ),
      body:Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Login',
                        textAlign:TextAlign.center,
                        style:TextStyle(
                            fontSize:40,
                            fontWeight:FontWeight.bold)),
                    SizedBox(height:5),
                    Text("Glad you're back 😄",
                        textAlign:TextAlign.center,
                        style:TextStyle(
                            fontSize: 20
                        )),
                  ],
                ),
              ),

              // Text(AppLocalizations.of(context)!.welcome_back,
              //     textAlign:TextAlign.center,
              //     style:Theme.of(context).textTheme.titleLarge!.
              //     copyWith(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor)),
              Form(
                key:formKey,
                child: Column(
                  children: [
                    TextForm(
                      textLabel:'Username',
                      leftIcon:Icon(Icons.person),
                        label: 'enter your username',
                        controller: userName,
                        validator: (text){if(text==null || text.isEmpty){return 'Please enter your Username';}}),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextForm(
                          leftIcon:Icon(Icons.lock),
                            rightIcon:
                            InkWell(
                                onTap:(){
                                  showPass = !showPass;
                                  setState(() {

                                  });
                                },
                                child:
                                    showPass == false?
                                Icon(Icons.visibility):Icon(Icons.visibility_off)),
                            textLabel: 'Password',
                            label: 'enter your password',
                            keyboardType:TextInputType.phone,
                            controller: password,
                            obscure:showPass,
                            validator: (text){
                            if(text==null || text.trim().isEmpty){
                              return 'Please enter your Password';
                            }
                            if(password.text.length<6){
                              return 'Password must be at least 6 characters!';
                            }
                          }
                          ),
                            // TextButton(onPressed: (){}, child:Text('Forgot Password?',
                            //     style:TextStyle(color:isDark?AppColors.white:AppColors.blackDark,fontWeight:FontWeight.bold)))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: (){
                      ///When a new user enters => tasks from previous users was still in the list when he adds it vanishes so to solve this we empty the task once a user enters the app
                      login(context);
                      },
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('Login',
                          style:TextStyle(
                            fontSize: 20,
                            fontWeight:FontWeight.bold,
                          )),
                    ),
                    style:ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(20)
                        ),
                      backgroundColor: isDark?AppColors.primaryColorDark:AppColors.primaryColor
                    )
                ),
              ),
              Text('Or',
                textAlign:TextAlign.center,
                style:TextStyle(fontSize:15)),
              Text('Sign in with',
                  textAlign:TextAlign.center,
                  style:TextStyle(fontSize:17),
                  ),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/fb.png',height:height*0.07),
                  Image.asset('assets/images/google.png',height:height*0.07),
                ],
              ),
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style:TextStyle(
                        fontSize:17,
                        fontWeight:FontWeight.w300
                      )),
                  TextButton(
                      onPressed:(){Navigator.pushReplacementNamed(context,Register.routeName);},
                      child:Text('Sign up',
                          style:TextStyle(
                            fontSize: 20,
                            fontWeight:FontWeight.w700,
                            color:isDark?AppColors.primaryColorDark:AppColors.primaryColor
                          ))),
                ],
              ),
              SizedBox(height:5),
              Align(
                  alignment:Alignment.bottomCenter,
                  child: Image.asset('assets/images/login.png')),
            ],
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async{
    if(formKey.currentState!.validate()==true){
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userName.text,
            password: password.text
        );
        /// After signing in successfully => get user from collection
        var user = await FireBaseConfig.readUsersFromCollection(credential.user?.uid ?? '');
        /// Get user id from credentials if null => return ' '
        /// Listen:false => I don't need any update in UI => Just het user data by login button
        UserProvider uProvider = Provider.of<UserProvider>(context,listen:false);
        uProvider.updateUser(user!);
        if(user == null){
          return;       /// Don't move to rest of code
        }
        print(credential.user?.uid ?? 'Nothing');
        var lProvider = Provider.of<listProvider>(context,listen: false);
        //lProvider.tasks = [];
        var selectedDate = DateTime.now();
        if (lProvider.tasks.isEmpty){ //&& isFetching
          //isFetchingData = true;
          lProvider.changeSelectedDate(selectedDate, uProvider.currentUser!.id);
          setState(() {
            // isFetchingData = false;
          });
        }
        await SharedPreferenceUtils.saveData(key:'email', value:credential.user?.email);
        //Get the current user
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          // Retrieve the user's token asynchronously and wait for the result
          var token = await currentUser.getIdToken();
          print('User token: $token');
          await SharedPreferenceUtils.saveData(key:'token', value:token);
          // Use the token as needed
        } else {
          print('No user is currently signed in.');
        }
        Navigator.pushReplacementNamed(context,HomeScreen.routeName);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
