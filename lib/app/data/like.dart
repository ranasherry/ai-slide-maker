import 'dart:convert';

class Like{
  int userId,likeId,createdAt;
  
  Like(
    {required this.userId,
    required this.likeId,
    required this.createdAt,
  });

  Map<String,dynamic> toMapDatabase(){
    return {
      'userId': userId,
      'likeId': likeId,
      'createdAt':  createdAt
    };
  }

  factory Like.fromMapDatabase(Map<String, dynamic> map){
    return Like(
      userId : map['userId'],
      likeId : map['likeId'],
      createdAt: map['createdAt']
    );
  } 

  String toJson() => json.encode(toMapDatabase());

  factory Like.fromJson(String source) =>
  Like.fromMapDatabase(json.decode(source) as Map<String, dynamic>);
}