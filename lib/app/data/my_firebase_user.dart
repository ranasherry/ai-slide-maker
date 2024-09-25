import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String id;
  String? name;
  String email;
  String gender;
  String revenueCatUserId;
  String? profilePicUrl;
  String? dob;
  Timestamp joinDate;

  //TODO: Add join Date TimeStamp

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.revenueCatUserId,
    required this.gender,
    this.dob,
    this.profilePicUrl,
    required this.joinDate,
  });

  // Convert a UserData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'dob': dob,
      'revenueCatUserId': revenueCatUserId,
      'profilePicUrl': profilePicUrl,
      'joinDate': joinDate,
    };
  }

  // Create a UserData object from a Map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String,
      name: map['name'] ?? "" as String?,
      email: map['email'] as String,
      gender: map['gender'] ?? "" as String,
      revenueCatUserId: map['revenueCatUserId'] as String,
      dob: map['dob'] ?? null as String?,
      profilePicUrl: map['profilePicUrl'] ?? "" as String,
      joinDate: map['joinDate'] != null
          ? (map['joinDate'] as Timestamp)
          : Timestamp.fromDate(DateTime(2024, 9, 23)),
    );
  }
}
