import 'package:flutter/material.dart';
import 'package:todo_app/models/colors.dart';
typedef MyValidatorType = String? Function(String?);
class TextForm extends StatelessWidget {
  String label;
  String textLabel;
  ///object from TextEditingController
  TextEditingController controller;
  ///optional named if not sent make the default .text=>normal keyboard
  TextInputType keyboardType;
  ///if true text will not appear as in password and if not sent a default of false will be sent
  bool obscure;
  MyValidatorType validator;
   var rightIcon;
   var leftIcon;
  TextForm({required this.label,required this.controller,this.keyboardType = TextInputType.text,this.obscure = false,required this.validator,this.rightIcon,this.leftIcon,required this.textLabel});
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(textLabel),
          TextFormField(
            decoration: InputDecoration(
              suffixIcon:rightIcon,
              prefixIcon: leftIcon,
              hintText: label,
              hintStyle:TextStyle(fontSize:20),
              enabled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.red)
              ),
              errorMaxLines: 2,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.red)
              ),
            ),
            controller:controller,
            keyboardType:keyboardType,
            obscureText:obscure,
            validator:validator,
          ),
        ],
      ),
    );
  }
}
