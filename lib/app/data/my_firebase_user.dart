class UserData {
  String id;
  String? name;
  String email;
  String gender;
  String revenueCatUserId;
  String? profilePicUrl;
  String? dob;

  //TODO: Add join Date TimeStamp

  UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.revenueCatUserId,
      required this.gender,
      this.dob,
      this.profilePicUrl});

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
    );
  }
}
