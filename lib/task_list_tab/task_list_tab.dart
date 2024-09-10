import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/colors.dart';
import 'package:todo_app/providers/app_config_providers.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/templates/tasks_item.dart';
class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}
class _TaskListTabState extends State<TaskListTab> {
  String?currentSelectedItem = 'title';
  //bool isFetchingData = false; // Add a flag to track data fetching state
  @override
  Widget build(BuildContext context) {
    var uProvider = Provider.of<UserProvider>(context);
    var lProvider = Provider.of<listProvider>(context);
    var selectDated = DateTime.now();
    ///problem with this condition that in second time condition wll not be met as list will not be empty so we will not call the function
    // Fetch data only if tasks are empty and data is not already being fetched

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    var provider = Provider.of<AppConfigProviders>(context);
    List<String> dropList = [provider.language=='en'?'title':'العنوان',provider.language=='en'?'date':'التاريخ'];
    if (provider.language == 'ar') {
      dropList = [
        'العنوان', // localized version of 'title'
        'التاريخ'  // localized version of 'date'
      ];
    }
    if (!dropList.contains(currentSelectedItem)) {
      currentSelectedItem = dropList.first;
    }
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:BoxConstraints(
          minHeight:MediaQuery.of(context).size.height
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: EasyDateTimeLine(
               initialDate: DateTime.now(),
               onDateChange: (selectedDate) {
                 ///Changed current data to the date selected by user
                 lProvider.changeSelectedDate(selectedDate,uProvider.currentUser!.id);
                 setState(() {

                 });
                 // if (!isFetchingData) { // Only fetch data if not already fetching
                 //   setState(() {
                 //     isFetchingData = true;
                 //   });
                 //
                 //   lProvider.getDataFromFirestore(uProvider.currentUser!.id);
                 //   setState(() {
                 //     isFetchingData = false;
                 //   });
                 // }
                                           },
               locale:provider.language,
               headerProps:  EasyHeaderProps(
                 selectedDateStyle: TextStyle(color:isDark?AppColors.white:AppColors.black),
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: FullDateDMonthAsStrYFormatter(),
                                                 ),
               dayProps: EasyDayProps(
                 dayStructure: DayStructure.dayStrDayNumMonth,
                 todayStyle: DayStyle(dayNumStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                     dayStrStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                     monthStrStyle:TextStyle(color:isDark?AppColors.white:AppColors.black)),
                 activeDayStyle: DayStyle(
                     dayNumStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                     dayStrStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                     monthStrStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(7),
                         color: isDark?AppColors.primaryColorDark:AppColors.primaryColor),
                 ),
                 inactiveDayStyle: DayStyle(
                   dayNumStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                   dayStrStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                   monthStrStyle:TextStyle(color:isDark?AppColors.white:AppColors.black),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(7),
                     color: isDark?AppColors.blackDark:AppColors.white,

                   )
                 )
                 // activeDayStyle: DayStyle(
                 //   decoration: BoxDecoration(
                 //     borderRadius: BorderRadius.all(Radius.circular(7)),
                 //   ),
                 // ),
                                           ),
                                           ),
            ),
             lProvider.tasks.isEmpty?
                 Container(
                     margin:EdgeInsets.only(top:150),
                     child: provider.language=='en'?Text('Add your first task!',
                         style:TextStyle(fontSize:30,
                             color:isDark?AppColors.primaryColorDark:AppColors.primaryColor,
                         fontWeight: FontWeight.bold)):Text('اضف مهمتك الاولي!',
                         style:TextStyle(fontSize:30,
                             color:isDark?AppColors.primaryColorDark:AppColors.primaryColor,
                             fontWeight: FontWeight.bold))
                 ):
             Container(
               margin:EdgeInsets.all(15),
               child: Row(
                 mainAxisAlignment:MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                       provider.language=='en'?
                       'Sort by':'الترتيب',
                       style:TextStyle(color:isDark?AppColors.white:AppColors.blackDark)
                   ),
                   DropdownButton<String>(
                     borderRadius: BorderRadius.circular(20),
                     dropdownColor:isDark?AppColors.backgroundDark:AppColors.backgroundLight,
                     elevation: 3,
                     items: dropList.map((String dropDownItem){
                       return DropdownMenuItem<String>(
                         value:dropDownItem,
                         child:Text(dropDownItem),
                       );
                     }).toList(),
                     onChanged:(String ? newSelectedItem){
                       this.currentSelectedItem = newSelectedItem;
                       lProvider.sortOptions(this.currentSelectedItem);
                       setState(() {
                       });
                     },
                     value:currentSelectedItem,
                     iconEnabledColor:isDark?AppColors.primaryColorDark:AppColors.primaryColor,
                     underline:Container(),

                   )
                 ],
               ),
             ),
             ListView.builder(
                 physics:NeverScrollableScrollPhysics(), //disables list view own scrolling
                 shrinkWrap:true, //allows listview to be wrapped inside scrollview
                 itemBuilder:(context,index){
               return Tasks(task:lProvider.tasks[index]) ;
             },
               itemCount:lProvider.tasks.length,
        )
          ],
        ),
      ),
    );
  }
}
