class UserData {
  final String id;
  final String? name;
  final String email;
  final String revenueCatUserId;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.revenueCatUserId,
  });

  // Convert a UserData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'revenueCatUserId': revenueCatUserId,
    };
  }

  // Create a UserData object from a Map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String,
      name: map['name'] as String?,
      email: map['email'] as String,
      revenueCatUserId: map['revenueCatUserId'] as String,
    );
  }
}
