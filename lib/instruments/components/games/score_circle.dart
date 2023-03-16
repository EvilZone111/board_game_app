import 'package:board_game_app/instruments/helpers.dart';
import 'package:flutter/material.dart';

class ScoreCircle extends StatelessWidget {
  double gameScore;
  String stringScore='-';
  Color scoreCircleColor=Colors.grey;
  double radius;
  double fontSize;
  bool isUserScore;


  ScoreCircle({required this.gameScore, this.radius=20, this.fontSize=17, required this.isUserScore}){

      if (gameScore != 0.0) {
        if(isUserScore){
          stringScore = gameScore.toStringAsFixed(0);
        } else {
          stringScore = gameScore.toStringAsFixed(1);
        }
        scoreCircleColor = getScoreColor(gameScore);
      } else {
        stringScore = '—';
      }
  }
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: scoreCircleColor,
      radius: radius,
      child: Center(
        child: Text(
          stringScore,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
