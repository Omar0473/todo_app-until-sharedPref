import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase/firebase.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/providers/user_provider.dart';
class EditTaskBottomSheet extends StatefulWidget{
  TasksModel task ;
  EditTaskBottomSheet(this.task);
  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  @override
  void initState() {
    super.initState();
    selectDate = widget.task.taskDate ?? DateTime.now();
  }
  late DateTime selectDate;
  late bool isDark;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var uProvider = Provider.of<UserProvider>(context);
    String formattedDate = DateFormat.yMd().format(selectDate);
    listProvider lProvider = Provider.of<listProvider>(context);
    double height = MediaQuery.of(context).size.height;
    isDark =  Theme.of(context).brightness == Brightness.dark;
    return Container(
      height:height*0.5,
      // decoration: BoxDecoration(
      //   border: Border.all(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor,width: 1),
      //   borderRadius: BorderRadius.circular(20)
      // ),
      margin: EdgeInsets.all(2),
      padding:EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)!.task_details,textAlign: TextAlign.center,style:Theme.of(context).textTheme.titleLarge!.copyWith(color:isDark?Colors.grey:Colors.black54)),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Text('${AppLocalizations.of(context)!.title} : ${widget.task.title}',style:Theme.of(context).textTheme.titleLarge!.copyWith(color:isDark?Colors.grey:Colors.black54)
              ),
              InkWell(
                splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: ()async{
                  titleController.text = widget.task.title;  ///initialize the controller with our title value instead of being empty
                  await showBox('Task Title',context,titleController);
                  await FireBaseConfig.editTask(context,widget.task,'title',titleController.text,uProvider.currentUser!.id);
                  widget.task.title = titleController.text;
                  lProvider.getDataFromFirestore(uProvider.currentUser!.id);
                  setState(() {

                  });// Refresh the task list
                  },
                  child: Icon(Icons.edit_note))
            ],
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('${AppLocalizations.of(context)!.description} : ${widget.task.description}',style:Theme.of(context).textTheme.titleLarge!.copyWith(color:isDark?Colors.grey:Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  maxLines:3),
              ),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: ()async{
                    descriptionController.text = widget.task.description;
                    await showBox('Task Description', context,descriptionController);
                    await FireBaseConfig.editTask(context,widget.task,'description',descriptionController.text,uProvider.currentUser!.id);
                    widget.task.description = descriptionController.text;
                    lProvider.getDataFromFirestore(uProvider.currentUser!.id);
                    setState(() {

                    });
                  },
                  child: Icon(Icons.edit_note))
            ],
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Text('${AppLocalizations.of(context)!.date} : ${formattedDate}',style:Theme.of(context).textTheme.titleLarge!.copyWith(color:isDark?Colors.grey:Colors.black54 )),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                onTap: ()async{
                    ///==================Ask
                     await showCalender();
                     widget.task.taskDate = selectDate;
                     await FireBaseConfig.editTask(context,widget.task,'taskDate',selectDate.microsecondsSinceEpoch,uProvider.currentUser!.id);
                     listProvider.dataFetched=false;
                     lProvider.getDataFromFirestore(uProvider.currentUser!.id);
                     setState(() {

                     });

                },
                  child: Icon(Icons.edit_calendar))
            ],
          ),
          ElevatedButton(
              onPressed: (){Navigator.pop(context);},
              child: Text('Done'),
              style:ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              )
          )
        ],
      ),
    );
  }
  Future<void> showBox(String label,BuildContext context,var controller)async{
    double height = MediaQuery.of(context).size.height;
    await showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark?AppColors.blackDark:AppColors.white,
        content: Container(
          height:height*0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                maxLines:3,
               controller:controller,
               decoration: InputDecoration(labelText:label),
      ),
              ElevatedButton(
                  onPressed: (){
                    ///This condition is necessary in order to affect the right parameter not only title or desc
                    if (label == 'Task Title') {
                      widget.task.title = controller.text;
                    } else if (label == 'Task Description') {
                      widget.task.description = controller.text;
                    }
                    Navigator.pop(context);
                    },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor:isDark?AppColors.primaryColorDark:AppColors.primaryColor
                  ))
            ],
          ),
        ),
    ));
  }
  ///========================================Ask
  Future<void> showCalender() async{
    var chosenDate =  await showDatePicker(context: context,
        initialDate:DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days:365)),
        builder:(context,child){
          return Theme(data: Theme.of(context).copyWith(
            colorScheme: isDark?ColorScheme.dark(primary:AppColors.primaryColorDark,surface:AppColors.primaryColorDark):ColorScheme.light(primary:AppColors.primaryColorDark,surface:AppColors.primaryColorDark),
          )
              , child: child!);
        }
    );
    if (chosenDate != null) {
      selectDate = chosenDate;
      setState(() {

      });
    }
  }
}
///var = await Future<void>xxxxxxxxxx
///await on something not happening in one moment but don't assign to a variable
///init=>I couldn't use widget. outside widget build =>state initialization
///show calender must be Future<void> because the response is not at the moment from the user We must wait until the user selects date
///and wait in calling until selection is done