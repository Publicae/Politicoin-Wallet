// To parse this JSON data, do
//
//     final facebookProfileModel = facebookProfileModelFromJson(jsonString);

import 'dart:convert';

FacebookProfileModel facebookProfileModelFromJson(String str) =>
    FacebookProfileModel.fromJson(json.decode(str));

String facebookProfileModelToJson(FacebookProfileModel data) =>
    json.encode(data.toJson());

class FacebookProfileModel {
  String name;
  String firstName;
  String lastName;
  String email;
  String id;

  FacebookProfileModel({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  factory FacebookProfileModel.fromJson(Map<String, dynamic> json) =>
      FacebookProfileModel(
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "id": id,
      };
}
