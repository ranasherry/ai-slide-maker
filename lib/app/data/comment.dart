import 'dart:convert';

class Comment{
  int userId,commentId,createdAt;
  String text;
  
  Comment(
    {required this.userId,
    required this.commentId,
    required this.createdAt,
    required this.text
  });

  Map<String,dynamic> toMapDatabase(){
    return {
      'userId': userId,
      'commentId': commentId,
      'createdAt':  createdAt,
      'text': text,
    };
  }

  factory Comment.fromMapDatabase(Map<String, dynamic> map){
    return Comment(
      userId : map['userId'],
      commentId : map['commentId'],
      createdAt: map['createdAt'],
      text: map['text'],
    );
  } 

  String toJson() => json.encode(toMapDatabase());

  factory Comment.fromJson(String source) =>
  Comment.fromMapDatabase(json.decode(source) as Map<String, dynamic>);
}