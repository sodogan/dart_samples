import 'package:intl/intl.dart';

class Planet9User{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final String createdBy;
final String updatedBy;
final String firstName;
final String lastName;
final String emailAddress;
final String mobileNumber;
final String backupMobileNumber;
final bool isExternal;
final String roleID;

Planet9User({required this.id,required this.lastName,required this.firstName,required this.backupMobileNumber,
             required this.createdAt,required this.createdBy,required this.emailAddress,
             required this.isExternal,required this.mobileNumber,required this.roleID,required this.updatedAt,required this.updatedBy
             });


factory Planet9User.fromJson(Map<String,dynamic> json)=>Planet9User(id: json['id'],
    lastName:  json['lastName'] ,
    firstName: json['firstName'] ,
    backupMobileNumber: json['firstName'],
    createdAt: DateTime.fromMicrosecondsSinceEpoch(json['createdAt']),
    createdBy: json['createdBy'] ,
    emailAddress: json['emailAddress'] ,
    isExternal: json['isExternal'] ,
    mobileNumber: json['mobileNumber'] ,
    roleID: json['roleID'] ,
    updatedAt: json['updatedAt'] is int ?DateTime.fromMicrosecondsSinceEpoch(json['createdAt']):DateTime.now(),
    updatedBy: json['updatedBy']
);

@override
  String toString() {
      final formatted = DateFormat.yMEd().format(createdAt);
    return     'firstName: $firstName'
                'created At: $formatted.'
    ;
  }

}