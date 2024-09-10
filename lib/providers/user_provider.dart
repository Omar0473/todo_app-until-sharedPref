import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/users.dart';
class UserProvider extends ChangeNotifier{
  ///=>Variable and function that changes the variable
  Users? currentUser ;   ///Object => The user itself and may be null
  void updateUser(Users newUser){ ///Function to update user with each login
    currentUser = newUser;
    notifyListeners();
  }
}