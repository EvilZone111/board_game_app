import 'package:board_game_app/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class FriendRequest {
  int senderId;
  int recipientId;
  String? message;
  bool isAccepted;
  bool isHandled;
  User? user;

  FriendRequest({
    required this.senderId,
    required this.recipientId,
    this.message,
    required this.isAccepted,
    required this.isHandled,
    this.user,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json){
    return FriendRequest(
      senderId: json['sender'],
      recipientId: json['recipient'],
      message: json['message'],
      isAccepted: json['is_accepted'],
      isHandled: json['is_handled'],
    );
  }
}