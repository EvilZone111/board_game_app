import 'package:board_game_app/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class ParticipationRequest {
  int eventId;
  int userId;
  String? message;
  bool isAccepted;
  String? answer;
  bool isHandled;
  User? user;

  ParticipationRequest({
    required this.eventId,
    required this.userId,
    this.message,
    required this.isAccepted,
    this.answer,
    required this.isHandled,
    this.user,
  });

  factory ParticipationRequest.fromJson(Map<String, dynamic> json){
    return ParticipationRequest(
      eventId: json['event'],
      userId: json['user'],
      message: json['message'],
      isAccepted: json['is_accepted'],
      answer: json['answer'],
      isHandled: json['is_handled'],
    );
  }
}