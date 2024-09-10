import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/providers/app_config_providers.dart';
import 'package:todo_app/settings_tab/languages_bottom_sheet.dart';
import 'package:todo_app/settings_tab/theme_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProviders>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness==Brightness.dark;
    return Container(
      margin:EdgeInsets.only(left:width*0.0922330097087379,top:height*0.032183908045977),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(AppLocalizations.of(context)!.language,style:Theme.of(context).textTheme.bodyMedium),
          ),
          Container(
            margin:EdgeInsets.only(left:width*0.0436893203883495,top:height*0.0264367816091954,right:width*0.0898058252427184,bottom:height*0.0252873563218391),
            decoration:BoxDecoration(
                color:isDark?AppColors.blackDark:AppColors.white,borderRadius:BorderRadius.circular(0),border:Border.all(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor)),
            child: InkWell(
              onTap:(){
                languagesBottomSheet(context);
              },
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                       padding:EdgeInsets.only(left:16,top:16,bottom:16,right:16),
                      child: Text(provider.language=='en'?AppLocalizations.of(context)!.english:AppLocalizations.of(context)!.arabic,style:Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight:FontWeight.bold))
                  ),
                  Icon(Icons.keyboard_arrow_down,size:27,color:isDark?AppColors.primaryColorDark:AppColors.primaryColor)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(AppLocalizations.of(context)!.mode,style:Theme.of(context).textTheme.bodyMedium),
          ),
          Container(
            margin:EdgeInsets.only(left:width*0.0436893203883495,top:height*0.0264367816091954,right:width*0.0898058252427184,bottom:height*0.0252873563218391),
            decoration:BoxDecoration(
                color:isDark?AppColors.blackDark:AppColors.white,borderRadius:BorderRadius.circular(0),border:Border.all(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor)),
            child: InkWell(
              onTap:(){
                themeBottomSheet(context);
              },
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding:EdgeInsets.only(left:16,top:16,bottom:16,right:16),
                      child: Text(provider.appMode==ThemeMode.light?AppLocalizations.of(context)!.light:AppLocalizations.of(context)!.dark,style:Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight:FontWeight.bold))
                  ),
                  Icon(Icons.keyboard_arrow_down,size:27,color:isDark?AppColors.primaryColorDark:AppColors.primaryColor)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void languagesBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder:(context)=>LanguagesBottomSheet(),shape:Theme.of(context).bottomSheetTheme.shape);
  }

  void themeBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context)=>ThemeBottomSheet(),shape:Theme.of(context).bottomSheetTheme.shape);
  }
}
