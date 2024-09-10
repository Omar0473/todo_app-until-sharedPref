import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/add_task_bottom_sheet.dart';
import 'package:todo_app/login/login_screen.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/settings_tab/settings_tab.dart';
import 'package:todo_app/task_list_tab/task_list_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/list_provider.dart';
import '../providers/user_provider.dart';
class HomeScreen extends StatefulWidget {
  static const routeName = 'home_screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    UserProvider uProvider = Provider.of<UserProvider>(context,listen:false);
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
              margin: EdgeInsets.all(7),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                  onTap:(){
                    showDialog(context: context, builder:(BuildContext context)=>AlertDialog(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark?AppColors.blackDark:AppColors.white,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      content: Container(
                          height:75,
                          child: Column(
                            children: [
                              Icon(Icons.logout_outlined),
                              Text('Sign Out?',textAlign:TextAlign.center),
                            ],
                          )),
                      actions: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: [
                           ElevatedButton(
                               onPressed: ()async{
                                 var lProvider = Provider.of<listProvider>(context,listen: false);
                                 lProvider.tasks = [];
                                 Navigator.pushReplacementNamed(context,Login.routeName);
                               },
                               child: Text('Yes'),
                               style:ElevatedButton.styleFrom(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                           TextButton(
                               onPressed: (){
                                 Navigator.pop(context);
                               },
                               child: Text('No')
                           )
                         ],
                       )
                      ],
                      actionsAlignment: MainAxisAlignment.center,
                    ));
                  },
                  child: Icon(Icons.logout_outlined)))
        ],
        toolbarHeight:MediaQuery.of(context).size.height*0.1804597701149425,
        title: Text(selectedIndex == 0
            ? (uProvider.currentUser != null
            ? '${AppLocalizations.of(context)!.todo_list} > ${uProvider.currentUser!.name}'
            : 'Guest User') // Fallback text when currentUser is null
            : AppLocalizations.of(context)!.settings,
            style: Theme.of(context).textTheme.titleLarge),
        elevation:0,
      ),
      bottomNavigationBar:BottomAppBar(
        height:MediaQuery.of(context).size.height*0.0988505747126437,
        shape: CircularNotchedRectangle(),
        notchMargin:8,
        child: BottomNavigationBar(

          currentIndex: selectedIndex,
          onTap:(index){
            selectedIndex=index;
            setState(() {});
          },
          iconSize:30,
          items: [
               BottomNavigationBarItem(
                //icon: Icon(Icons.list),
                 icon: ImageIcon(AssetImage('assets/images/list icon.png')),
                 label:AppLocalizations.of(context)!.tasks_list
            ),
               BottomNavigationBarItem(
                 icon:ImageIcon(AssetImage('assets/images/settings icon.png')),
                 label:AppLocalizations.of(context)!.settings
            )
          ],

        ),
      ),
      floatingActionButton:
      Container(
         decoration:  BoxDecoration(
          color:Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color:Colors.white70,
              //blurStyle: BlurStyle.inner,
              spreadRadius:0.7,
              blurRadius:3,
            )
          ]
        ),
         child: FloatingActionButton(
          onPressed:(){
            addTaskBottomSheet();
          },
          child:Icon(Icons.add,size:27),
        ),
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      body:selectedIndex==0?TaskListTab():SettingsTab(),
    );
  }

  void addTaskBottomSheet() {
    showModalBottomSheet(context: context, builder: (context)=>AddTaskBottomSheet());
  }
}
///if more thant two => List<Widget>tabs=[TaskListTab(),SettingsTab(),...(),...()] and use index of list to access
