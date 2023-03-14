import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class User {
  int? id;
  String firstName;
  String lastName;
  String? bio;
  String city;
  int cityId;
  String sex;
  String? profilePicture;
  String? dateOfBirth;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.bio,
    required this.city,
    required this.cityId,
    required this.sex,
    this.profilePicture,
    this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'],
      city: json['city'],
      cityId: json['city_id'],
      sex: json['sex'],
      // profilePicture: json['profilePicture'] ?? 'assets/images/blank_pfp.png',
      profilePicture: json['profilePicture'],
      dateOfBirth: json['date_of_birth'],
    );
  }


}