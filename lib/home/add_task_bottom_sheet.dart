import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase/firebase.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/templates/snack_bar_temp.dart';
import '../providers/app_config_providers.dart';
class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late var provider;

  DateTime selectDate = DateTime.now();

  String title = '';

  String description = '';

  var formKey = GlobalKey<FormState>();

  late bool isDark;

  late var lProvider;
  @override
  Widget build(BuildContext context) {
     lProvider = Provider.of<listProvider>(context);
     provider = Provider.of<AppConfigProviders>(context);
     isDark = Theme.of(context).brightness == Brightness.dark;
     String formattedDate = DateFormat.yMd().format(selectDate);
     return Container(
      margin:EdgeInsets.all(35),
      child:SingleChildScrollView(
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.add_new_task,style:Theme.of(context).textTheme.titleMedium!.copyWith(fontSize:27)),
            Form(
              key:formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(decoration:InputDecoration(labelText:AppLocalizations.of(context)!.enter_your_task,),style:GoogleFonts.tajawal(fontSize:20,fontWeight:FontWeight.bold),
                    validator:(text){if(text==null || text.isEmpty){return(provider.language=='en'?"Please enter your task!":"من فضلك ادخل مهمتك!");}},
                    onChanged:(text){title=text;}),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                TextFormField(
                  decoration:InputDecoration(
                      labelText:AppLocalizations.of(context)!.task_description
                )
                  ,style:GoogleFonts.tajawal(fontSize:20,fontWeight:FontWeight.bold),maxLines:5,
                  onChanged:(text){description=text;},
                  validator:(text){
                    if(text == null || text.isEmpty){
                      return (provider.language=='en'?"Please enter title description!":"من فضلك ادخل الوصف !");
                    }
                  },

                ),

              ),
                    Text(AppLocalizations.of(context)!.select_time,
                        style:Theme.of(context).textTheme.bodyMedium!.
                        copyWith(color:isDark?Colors.grey:Colors.black45),
                        textAlign:TextAlign.center),
                    InkWell(
                        onTap:(){
                          showCalender();
                        },
                        child:Text(formattedDate,
                            style:Theme.of(context).textTheme.bodyMedium!.
                            copyWith(color:isDark?Colors.grey:Colors.black45),
                            textAlign:TextAlign.center),
                    )
                        // child: Text("${selectDate.day}/${selectDate.month}/${selectDate.year}",style:TextStyle(fontSize:19,fontWeight:FontWeight.normal,color:Colors.grey),textAlign:TextAlign.center,)),
                        ,
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                          style:ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                          ,onPressed: (){
                                addTask();
                      },
                          child: Text(AppLocalizations.of(context)!.add,style:Theme.of(context).textTheme.bodyMedium!.copyWith(color:Colors.white))),
                    )
                ]
              ),
            ),
          ],
        ),
      ),
    );


  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      TasksModel task = TasksModel(title: title, description: description, taskDate: selectDate);
      var uProvider = Provider.of<UserProvider>(context,listen:false);
      ///I am certain that there is a user as we are in the home screen now so we used !
      FireBaseConfig.addTask(task,uProvider.currentUser!.id).then((value) {
        listProvider.dataFetched=false;
        lProvider.getDataFromFirestore(uProvider.currentUser!.id);
        // final snackBar = SnackBar(
        //   content: provider.language == 'en'
        //       ? Text('Task Added Successfully!', style: TextStyle(color: Colors.white))
        //       : Text('تم اضافة المهمة!', style: TextStyle(color: Colors.white)),
        //   action: SnackBarAction(
        //     label: provider.language == 'en' ? 'Undo!' : 'الغاء',
        //     textColor: Colors.white,
        //     onPressed: () {
        //       // Add your undo logic here if needed.
        //     },
        //   ),
        //   backgroundColor: Colors.green,
        // );
        final snackBar = SnackBarTemp.SnackBarTempelate(
          content:provider.language == 'en'?'Task Added Successfully!':'تم اضافة المهمة!',
          backgroundColor: AppColors.green,
          labelColor: Colors.white,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      });
    }
  }


  void showCalender() async {
  var chosenDate =  await showDatePicker(context: context,
        initialDate:selectDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days:365)),
      builder:(context,child){
      return Theme(data: Theme.of(context).copyWith(
        colorScheme: isDark?ColorScheme.dark(primary:AppColors.primaryColorDark,surface:AppColors.primaryColorDark):ColorScheme.light(primary:AppColors.primaryColorDark,surface:AppColors.primaryColorDark),
      )
          , child: child!);
      }
    );
  // if(chosenDate!=null){
  //   selectDate = chosenDate;
  // }
  selectDate = chosenDate ??selectDate;
  setState(() {});
  }
  // void unUsedCode(){
  //   showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
  //     backgroundColor:isDark?AppColors.primaryColorDark:AppColors.primaryColor,
  //     title: provider.language=='en'?Text("ToDo App",
  //         style:Theme.of(context).textTheme.titleMedium!.copyWith(
  //             color:isDark?AppColors.blackDark:AppColors.white),
  //         textAlign:TextAlign.center):Text("برنامج المهام",
  //         style:Theme.of(context).textTheme.titleMedium!.copyWith(
  //             color:isDark?AppColors.blackDark:AppColors.white),textAlign:TextAlign.center),
  //     content:provider.language=='en'?Text('Task Added Successfully ✔',
  //         style:Theme.of(context).textTheme.titleMedium!.copyWith(
  //             color:isDark?AppColors.blackDark:AppColors.white),
  //         textAlign:TextAlign.center):
  //     Text('تم اضافة المهمة ✔',
  //         style:Theme.of(context).textTheme.titleMedium!.copyWith(
  //             color:isDark?AppColors.blackDark:AppColors.white),
  //         textAlign:TextAlign.center)
  //     ,actions:<Widget>[TextButton(child:provider.language=='en'?Text('Ok',style:Theme.of(context).textTheme.titleMedium!.copyWith(
  //       color:isDark?AppColors.blackDark:AppColors.white)):Text('تم',style:Theme.of(context).textTheme.titleMedium!.copyWith(
  //       color:isDark?AppColors.blackDark:AppColors.white)),onPressed: (){Navigator.of(context).pop();})]
  //     ,shape: RoundedRectangleBorder(
  //       side: BorderSide(width:3,color: Colors.grey),borderRadius:BorderRadius.circular(20)
  //   )
  //     ,));
  //
  // }
}




