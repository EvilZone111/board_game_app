import 'package:board_game_app/instruments/components/games/score_circle.dart';
import 'package:flutter/material.dart';

import '../../../models/game_model.dart';
import '../../constants.dart';

class SearchGameItem extends StatelessWidget {

  Game game;
  VoidCallback onTap;

  SearchGameItem({required this.game, required this.onTap});


  @override
  Widget build(BuildContext context) {
    double gameScore;
    game.score==0.0 ? gameScore = game.bggRating : gameScore = game.score;
    double tileHeight = MediaQuery.of(context).size.width/7*2*0.7;
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ScoreCircle(gameScore: gameScore),
                  ),
                ),
              ],
            ),
          ),
        ),
        kDivider,
      ],
    );
  }
}
