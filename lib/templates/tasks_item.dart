import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase/firebase.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:todo_app/providers/app_config_providers.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/task_list_tab/edit_task_bottom_sheet.dart';
import 'package:todo_app/templates/snack_bar_temp.dart';
class Tasks extends StatefulWidget {
  TasksModel task;
  Tasks({required this.task});
  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  late var lProvider;

  late bool isDark;

  @override
  Widget build(BuildContext context) {
    var uProvider = Provider.of<UserProvider>(context);
    CollectionReference tasks = FireBaseConfig.createCollectionTask(uProvider.currentUser!.id);
    var provider = Provider.of<AppConfigProviders>(context);
    lProvider=Provider.of<listProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    isDark =  Theme.of(context).brightness == Brightness.dark;
    return
      Container(
        margin:EdgeInsets.all(10),
        child:
        Slidable(
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          extentRatio:0.3,
          // A motion is a widget used to control how the pane animates.
          motion: const BehindMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              borderRadius:BorderRadius.circular(25),
              onPressed:(_){
                showDialog(
                    context: context,
                    builder:(BuildContext context)=>AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      content:Container(
                        height:75,
                        child: Column(
                          children: [
                            Icon(Icons.delete_outline),
                            provider.language=='en'?
                            Container(
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text('Delete this task?'))):Text('هل تريد ازالة هذه المهمة؟')
                          ],
                        ),
                      ),
                      backgroundColor:isDark?AppColors.blackDark:Colors.white,
                      // contentTextStyle: ,
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              // margin:EdgeInsets.only(top:20),
                              child: Container(
                                margin:EdgeInsets.only(top:0),
                                child: ElevatedButton(
                                  onPressed: (){
                                  FireBaseConfig.deleteTask(context,widget.task,uProvider.currentUser!.id).then((value){
                                    listProvider.dataFetched=false;
                                    lProvider.getDataFromFirestore(uProvider.currentUser!.id);
                                    final snackBar = SnackBarTemp.SnackBarTempelate(
                                        content:  provider.language == 'en'?
                                        'Task deleted Successfully!':
                                          'تم ازالة المهمة!',
                                        backgroundColor: AppColors.red,
                                   );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.pop(context);
                                  }).timeout(Duration(seconds:1),
                                      onTimeout:(){
                                        print('Task deleted');
                                      });
                                }, child:
                                provider.language == 'en'?
                                Text('Yes'):Text('نعم'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:isDark?AppColors.primaryColorDark:AppColors.primaryColor,
                                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                ),
                              ),
                            ),
                            Container(
                                margin:EdgeInsets.only(left:7,right:7,bottom: 7),
                                child: TextButton(onPressed: (){Navigator.pop(context);}, child:
                                provider.language == 'en'?
                                Text('No'):Text('لا')))
                          ],
                        ),
                      )
                      ],
                    ));
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label:
              provider.language == 'en'?
              'Delete':'مسح',
            ),
          ],
        ),
        // The end action pane is the one at the right or the bottom side.
        endActionPane:  ActionPane(
          extentRatio:0.3,
          motion:BehindMotion(),
          children: [
            SlidableAction(
              borderRadius:BorderRadius.circular(25),
              // An action can be bigger than the others.
              flex: 2,
              onPressed:(context){
                showTaskEdit(context);
              },
              backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.edit_note,
              label:
              provider.language == 'en'?
              'Edit':'تعديل',
            ),
          ],
        ),
        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: Container(
          height:height*0.140,
          decoration:BoxDecoration(
            color: isDark?AppColors.blackDark:AppColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                 widget.task.isDone == true?
            Container(
            margin:EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color:AppColors.green
            ),
            height:height*0.2,
            width:width*0.015,
          )
                     : ///2nd condition when isDone = false
                Container(
                      margin:EdgeInsets.all(3),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color:isDark?AppColors.primaryColorDark:AppColors.primaryColor
                    ),
                    height:height*0.2,
                  width:width*0.015,
                ),
                widget.task.isDone == true ?
                Expanded(
                  child: Container(
                    margin:EdgeInsets.all(3),
                    padding:EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(widget.task.title,style:Theme.of(context).textTheme.bodyMedium!.copyWith(color:AppColors.green)),
                        // Text(widget.task.description,style:Theme.of(context).textTheme.bodySmall!.copyWith(color:AppColors.green))
                        Row(
                          children: [
                            Icon(Icons.access_time,color:isDark?Colors.grey:Colors.black54,size:23),
                            SizedBox(width:3),
                            Text(DateFormat('hh:mm a').format(widget.task.taskDate),
                              style:Theme.of(context).textTheme.bodyMedium!.copyWith(color:isDark?Colors.grey:Colors.black54))
                          ],
                        )
                      ],
                    ),
                  ),
                ):
                    ///2nd condition when isDone = false
                Expanded(
                  child: Container(
                    margin:EdgeInsets.all(3),
                    padding:EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(widget.task.title,style:Theme.of(context).textTheme.bodyMedium!.copyWith(color:isDark?AppColors.primaryColorDark:AppColors.primaryColor)),
                        // Text(widget.task.description,style:Theme.of(context).textTheme.bodySmall!.copyWith(color:isDark?AppColors.white:AppColors.black))
                        Row(
                          children: [
                            Icon(Icons.access_time,color:isDark?Colors.grey:Colors.black54,size:23),
                            SizedBox(width:3),
                            Text(DateFormat('hh:mm a').format(widget.task.taskDate),
                              style:TextStyle(fontSize:20,color:isDark?Colors.grey:Colors.black54))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ///first
                widget.task.isDone == true?
                    provider.language=='en'?
               InkWell(
                   onTap: (){
                     showDialog(
                         context: context,
                         builder:(BuildContext context)=>AlertDialog(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(30),
                           ),
                           content:Container(
                             height:75,
                             child: Column(
                               children: [
                                 Icon(Icons.undo),
                                 Container(
                                     child: Container(
                                         margin: EdgeInsets.all(5),
                                         child: Text('Still Working?')))
                               ],
                             ),
                           ),
                           backgroundColor:isDark?AppColors.blackDark:Colors.white,
                           // contentTextStyle: ,
                           actionsAlignment: MainAxisAlignment.center,
                           actions: [
                             Container(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.stretch,
                                 children: [
                                   Container(
                                     margin:EdgeInsets.only(top:0),
                                     child: ElevatedButton(
                                       onPressed: (){
                                         widget.task.isDone = false;
                                         tasks.doc(widget.task.id).update({'isDone':false}).timeout(Duration(seconds: 1),onTimeout:(){print('updated');});
                                         setState(() {
                                         });
                                         Navigator.pop(context);
                                       }, child:
                                     Text('Yes'),
                                       style: ElevatedButton.styleFrom(
                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                           backgroundColor:isDark?AppColors.primaryColorDark:AppColors.primaryColor),
                                     ),
                                   ),
                                   Container(
                                       margin:EdgeInsets.only(left:7,right:7,bottom: 7),
                                       child: TextButton(onPressed: (){Navigator.pop(context);}, child:
                                       Text('No')))
                                 ],
                               ),
                             )
                           ],
                         ));
                     ///================================================================
                   },
                   child: Text('Done!',style:TextStyle(color: AppColors.green,fontWeight: FontWeight.bold,fontSize: 23))):
                    InkWell(
                        onTap:(){
                          showDialog(
                              context: context,
                              builder:(BuildContext context)=>AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                content:Container(
                                  height:75,
                                  child: Column(
                                    children: [
                                      Icon(Icons.undo),
                                      Container(
                                          child: Container(
                                              margin: EdgeInsets.all(3),
                                              child: Text('مازلت تعمل؟')))
                                    ],
                                  ),
                                ),
                                backgroundColor:isDark?AppColors.blackDark:Colors.white,
                                // contentTextStyle: ,
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          margin:EdgeInsets.only(top:0),
                                          child: ElevatedButton(
                                            onPressed: (){
                                              widget.task.isDone = false;
                                              tasks.doc(widget.task.id).update({'isDone':false}).timeout(Duration(seconds: 1),onTimeout:(){print('updated');});
                                              setState(() {
                                              });
                                              Navigator.pop(context);
                                            }, child:
                                          Text('نعم'),
                                            style: ElevatedButton.styleFrom(backgroundColor:isDark?AppColors.primaryColorDark:AppColors.primaryColor),
                                          ),
                                        ),
                                        Container(
                                            margin:EdgeInsets.only(left:7,right:7,bottom: 7),
                                            child: TextButton(onPressed: (){Navigator.pop(context);}, child:
                                            Text('لا')))
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        },
                        child: Text('تمت!',style:TextStyle(color: AppColors.green,fontWeight: FontWeight.bold,fontSize: 23))):
                ElevatedButton(onPressed: (){
                  widget.task.isDone = true;
                  tasks.doc(widget.task.id).update({'isDone':true}).timeout(Duration(seconds: 1),onTimeout:(){print('updated');});
                  setState(() {

                  });
                }
                  , child: Icon(Icons.check,size:45),
                    style:ButtonStyle(
                    backgroundColor:MaterialStateProperty.all<Color>(isDark?AppColors.primaryColorDark:AppColors.primaryColor),
                    shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)))
                  ),
                )
            ]
            )
          ),
        ),
    ),
      );
  }

  void showTaskEdit(BuildContext context) {
    showModalBottomSheet(isScrollControlled:true,context: context, builder:(context)=>EditTaskBottomSheet(widget.task));
  }
}
