import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SnackBarTemp{
  static SnackBar SnackBarTempelate({required String content, required Color backgroundColor, String actionLabel = '', Color labelColor = Colors.white, Function?actionsFunction}){
    return SnackBar(
      content:Text('$content',style:TextStyle(color:Colors.white)),
      backgroundColor:backgroundColor,
      action: SnackBarAction(
        label:actionLabel,
        textColor:labelColor,
        onPressed:(){
          actionsFunction?.call();
        },
      ),
    );
  }
}

