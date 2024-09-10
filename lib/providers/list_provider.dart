import 'package:flutter/cupertino.dart';
import '../firebase/firebase.dart';
import '../models/tasks.dart';

class listProvider extends ChangeNotifier{
  ///provider needs the variable and the function that changes the variable
  List<TasksModel>tasks=[];
  static bool dataFetched = false;
  void getDataFromFirestore(String uId)async{
    if (dataFetched) {
      // Data has already been fetched for the current date
      return;
    }
    var querySnapshot = await FireBaseConfig.createCollectionTask(uId).get();
    ///List<QueryDocumentSnapshot<TasksModel>> get docs =>Tasks //map
    tasks = querySnapshot.docs.map((doc){
      return doc.data();
    }).toList();
    ///infinite loop will be generated bec every time we call the function we call setState so it recalls the build widget and function will be called again
    ///handle it using conditions
    // for(int i=0;i<tasks.length;i++){
    //   print(tasks[i].title);
    // }
    for(int i =0;i<tasks.length;i++){
      print(tasks[i].title);
    }
    filterDate();
    dataFetched = true;
    tasks.sort(
            (task1,task2)=>task1.title.compareTo(task2.title));
    notifyListeners();
    ///where => loop on each task to check if it's date == date selected by user
    ///update value of our list
    ///We could have used FirebaseFirestore.instance
    //   .collection('users')
    //   .where('age', isGreaterThan: 20)
    //   .get()
    //   .then(...);
  }
  void filterDate(){
    tasks=tasks.where((task){
      if(selectedDate.day==task.taskDate.day&&
          selectedDate.month==task.taskDate.month&&
          selectedDate.year==task.taskDate.year){
        return true;
      }
      return false;
    }
    ).toList();
    notifyListeners();
    ///Sort by date
    ///We could have used FirebaseFirestore.instance
    //   .collection('users')
    //   .orderBy('age', descending: true)
    //   .get()
    //   .then(...);
  }
  var selectedDate = DateTime.now();
  void changeSelectedDate(DateTime newDate,String uId){
    if (selectedDate != newDate) {
      selectedDate = newDate;
      dataFetched = false; // Reset the fetched flag for new date
      getDataFromFirestore(uId);
    }
    ///call the function to get all tasks and give the function the data (when changed) to filter based on it
    ///not necessary as we called notifyListeners() in get function
    //notifyListeners();
  }
  void sortOptions(String?selectedSortWay){
    if(selectedSortWay=='title' || selectedSortWay=='العنوان'){
      tasks.sort(
              (task1,task2)=>task1.title.compareTo(task2.title));

      ///don't ever forget notifyListeners😊
      notifyListeners();
    }
    else if(selectedSortWay=='date' || selectedSortWay =='التاريخ'){
      tasks.sort(
              (task1,task2)=>task1.taskDate.compareTo(task2.taskDate));

      ///don't ever forget notifyListeners😊
      notifyListeners();
    }
  }
}