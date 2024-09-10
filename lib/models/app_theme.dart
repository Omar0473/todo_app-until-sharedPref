import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/colors.dart';
class AppTheme{
  static final ThemeData light = ThemeData(
      brightness:Brightness.light,
      iconTheme:IconThemeData(size:30,color:AppColors.primaryColorDark),
      scaffoldBackgroundColor:AppColors.backgroundLight,
      appBarTheme:AppBarTheme(
      color:AppColors.primaryColor,
    ),
      textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
          fontSize:22,
          fontWeight: FontWeight.bold,
          color:AppColors.white
  ),
          titleMedium: GoogleFonts.poppins(
              fontSize:22,
              fontWeight: FontWeight.bold,
              color:AppColors.black,
          ),
          bodyMedium:GoogleFonts.poppins(
            fontSize:20,
            fontWeight:FontWeight.bold,
            color:AppColors.black,
          ),
        bodySmall: GoogleFonts.arimo(
          fontSize:20,
          fontWeight:FontWeight.normal,
          color:AppColors.primaryColor
        )
  ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation:0,
        showUnselectedLabels: false,
        unselectedItemColor: AppColors.lightIconBorder,
        selectedItemColor: AppColors.primaryColor
    ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
         shape:StadiumBorder(
           side:BorderSide(width:3.5,color:AppColors.white)
         ),
         // shape:RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30),
       //   side:BorderSide(width: 6,color: AppColors.white)
      //container,stadium,shape
    ),
      bottomAppBarTheme: BottomAppBarTheme(
      color: AppColors.white
    ),
      bottomSheetTheme:BottomSheetThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),backgroundColor:AppColors.white)
  );
  static final ThemeData Dark  = ThemeData(
      brightness:Brightness.dark,
      iconTheme:IconThemeData(size:30,color:AppColors.primaryColorDark),
      scaffoldBackgroundColor:AppColors.backgroundDark,
      appBarTheme:AppBarTheme(
        color:AppColors.primaryColorDark,
      ),
      textTheme: TextTheme(
      titleLarge: GoogleFonts.poppins(
        fontSize:22,
        fontWeight: FontWeight.bold,
        color:AppColors.backgroundDark
      ),
      titleMedium:GoogleFonts.poppins(
  fontSize:22,
  fontWeight: FontWeight.bold,
  color:AppColors.white
      ),
      bodyMedium:GoogleFonts.poppins(
        fontSize:20,
        fontWeight:FontWeight.bold,
        color:AppColors.white,
      ),
        bodySmall: GoogleFonts.arimo(
            fontSize:20,
            fontWeight:FontWeight.normal,
            color:AppColors.primaryColorDark
        ),
    ),
      bottomNavigationBarTheme:  BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation:0,
          showUnselectedLabels: false,
          unselectedItemColor: AppColors.white,
        selectedItemColor: AppColors.primaryColorDark

  ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),side:BorderSide(color:AppColors.blackDark,width:4)),

    ),
      bottomAppBarTheme: BottomAppBarTheme(
      color: AppColors.blackDark
    ),
      bottomSheetTheme:BottomSheetThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),backgroundColor:AppColors.blackDark,)
  );
}
