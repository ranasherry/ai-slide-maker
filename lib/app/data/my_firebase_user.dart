class UserData {
  String id;
  String? name;
  String email;
  String revenueCatUserId;
  String? profilePicUrl;

  UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.revenueCatUserId,
      this.profilePicUrl});

  // Convert a UserData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'revenueCatUserId': revenueCatUserId,
      'profilePicUrl': profilePicUrl,
    };
  }

  // Create a UserData object from a Map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String,
      name: map['name'] as String?,
      email: map['email'] as String,
      revenueCatUserId: map['revenueCatUserId'] as String,
      profilePicUrl: map['profilePicUrl'] ?? "" as String,
    );
  }
}
