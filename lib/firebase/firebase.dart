import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:todo_app/models/users.dart';
class FireBaseConfig{
   static CollectionReference<TasksModel> createCollectionTask(String uId){
     ///Return FirebaseFirestore.instance.collection -> before filtering tasks based on user
    return  createUsersCollection().doc(uId).collection(TasksModel.collectionName).withConverter<TasksModel>(
        fromFirestore:((snapshot,options)=>TasksModel.fromFireStore(snapshot.data()!)),
     toFirestore:((tasks,options)=>tasks.toFireStore()));
  }
  static Future<void> addTask(TasksModel task,String uId){
   var taskCollection = createCollectionTask(uId);  //collection
   var taskDoc = taskCollection.doc();  //document
   task.id = taskDoc.id;  //auto id
    return taskDoc.set(task);
  }
  static Future<void>  deleteTask(BuildContext context,TasksModel task,String uId){
    return createCollectionTask(uId).doc(task.id).delete();
  }
  static Future<void> editTask(BuildContext context,TasksModel task,String taskKey,var value,String uId){
     var taskCollection = createCollectionTask(uId);
     var taskDoc = taskCollection.doc(task.id);
     return taskDoc.update({taskKey:value});
  }
  static CollectionReference <Users> createUsersCollection(){
     return FirebaseFirestore.instance.collection(Users.collectionName).withConverter(
         fromFirestore:(snapshot,options)=>Users.fromFireStore(snapshot.data()!),
         toFirestore:(user,_)=>user.toFireStore());
  }
  static Future<void> addUserToCollection(Users user){  /// after register
     return createUsersCollection().doc(user.id).set(user);
  }
  static Future<Users?> readUsersFromCollection(String uId)async{ /// after login
     var snapshot = await createUsersCollection().doc(uId).get();
     return snapshot.data();
     /// We returned user's data not only user as in some apps we need these credentials => personal info page
    ///  Type Users? => Users might be null (no users)
  }
  }
