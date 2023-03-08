import 'package:board_game_app/instruments/helpers.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ScoreCircle extends StatelessWidget {
  double gameScore;
  String stringScore='-';
  Color scoreCircleColor=Colors.grey;
  double radius;
  double fontSize;


  ScoreCircle({required this.gameScore, this.radius=20, this.fontSize=17}){
    // print(gameScore);
    if(gameScore!=0.0) {
      stringScore =gameScore.toStringAsFixed(1);
      scoreCircleColor=getScoreColor(gameScore);
    } else {
      stringScore = '—';
    }
  }
  // void setParameters(score){
  //   if(score!=0.0) {
  //     score>7.0
  //         ? scoreCircleColor=Colors.green
  //         : (score<5.0 ? scoreCircleColor=Colors.red : scoreCircleColor=Colors.grey);
  //   } else {
  //     gameScore = '—';
  //   }
  // }
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
