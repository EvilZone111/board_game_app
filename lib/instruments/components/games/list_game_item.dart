import 'package:board_game_app/instruments/components/games/score_circle.dart';
import 'package:flutter/material.dart';

import '../../../models/game_model.dart';
import '../../constants.dart';
import '../../helpers.dart';

class ListGameItem extends StatelessWidget {

  Game game;
  VoidCallback onTap;
  int? userScore;

  ListGameItem({required this.game, required this.onTap, this.userScore});


  @override
  Widget build(BuildContext context) {
    double gameScore;
    game.score==0.0 ? gameScore = game.bggRating : gameScore = game.score;
    double tileHeight = MediaQuery.of(context).size.width/7*2*0.7;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    game.thumbnail,
                    height: tileHeight,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.name,
                            style: kTextStyle,
                          ),
                          Text(
                            game.yearPublished.toString(),
                            style: kGreyTextStyle,
                          ),
                        ],
                      ),
                      if(userScore!=null)
                        SizedBox(
                          height: 17,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Text(
                                gameScore.toStringAsFixed(1),
                                style: TextStyle(
                                  color: getScoreColor(gameScore),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                game.bggUsersRated.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ScoreCircle(
                      gameScore: userScore== null? gameScore : userScore!.toDouble(),
                      isUserScore: userScore==null? false : true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
