// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:djubli/class/user.dart';

class Comment {
  final int id;
  final int userid;
  final String message;

  const Comment({
    required this.id,
    required this.userid,
    required this.message,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json["id"], userid: json["userId"], message: json["text"]);
  }
}
