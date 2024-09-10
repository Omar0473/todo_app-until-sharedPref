class TasksModel{
  static const String collectionName = 'tasks';
  String title;
  String description;
  String id;
  bool isDone;
  DateTime taskDate;
  TasksModel({this.id='',required this.title,required this.description,this.isDone=false,required this.taskDate});
  TasksModel.fromFireStore(Map<String,dynamic>dataTask):this(
      description:dataTask['description'] as String,
      taskDate:DateTime.fromMicrosecondsSinceEpoch(dataTask['taskDate']),
      title:dataTask['title'],
      id:dataTask['id'],
      isDone:dataTask['isDone']
  );
  Map<String,dynamic> toFireStore(){
   return {
      'id':id,
     'title':title,
     'description':description,
     'taskDate':taskDate.microsecondsSinceEpoch,
     'isDone':isDone
    };
  }
}