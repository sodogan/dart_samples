typedef formatterFunction = String Function(String,String);

class User{
  final String firstName;
  final String lastName;
  final formatterFunction formatter;
  User({required this.firstName,required this.lastName, required this.formatter,});

  String display(){
    return formatter(firstName,lastName);
  }

}

