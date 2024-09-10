import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/providers/app_config_providers.dart';
class ThemeBottomSheet extends StatelessWidget {
  late bool isDark;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    isDark = Theme.of(context).brightness == Brightness.dark;
    var provider = Provider.of<AppConfigProviders>(context);
    return Container(
      height:height*0.17,
      child:Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: InkWell(
              onTap:(){
                provider.changeMode(ThemeMode.light);
              },
              child: provider.appMode== ThemeMode.light?getSelected(context,AppLocalizations.of(context)!.light):getUnselected(context,AppLocalizations.of(context)!.light)
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(20.0),
            child: InkWell(
              onTap:(){
                provider.changeMode(ThemeMode.dark);
              },
              child: provider.appMode== ThemeMode.dark?getSelected(context,AppLocalizations.of(context)!.dark):getUnselected(context,AppLocalizations.of(context)!.dark)
            ),
          )
        ],
      ),
    );
  }
  getSelected(BuildContext context,String mode){
    return Row(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      children: [
        Text(mode,style:Theme.of(context).textTheme.bodySmall!.copyWith(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor,fontWeight:FontWeight.bold)),
        Icon(Icons.check,color:isDark?AppColors.primaryColorDark:AppColors.primaryColor)
      ],
    );
  }
  getUnselected(BuildContext context,String mode){
    return Row(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      children: [
        Text(mode,style:Theme.of(context).textTheme.bodySmall!.copyWith(color:isDark?AppColors.white:AppColors.black,fontWeight:FontWeight.bold)),
      ],
    );
  }
}
