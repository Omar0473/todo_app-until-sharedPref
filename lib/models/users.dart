class Users{
  static const String collectionName = 'users';
  String id;
  String name;
  String email;
  Users({required this.id,required this.name,required this.email});
  Users.fromFireStore(Map<String,dynamic> userData):this(
  id:userData['id'],
  name:userData['name'],
  email:userData['email']
  );
   Map<String,dynamic>toFireStore(){
    return {
      'id'  :id,
      'name':name,
    'email' :email
    };
  }
}