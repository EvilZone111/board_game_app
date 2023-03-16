import 'package:board_game_app/instruments/helpers.dart';
import 'package:board_game_app/screens/Games/game_full_description_screen.dart';
import 'package:board_game_app/screens/Games/score_game_screen.dart';
import 'package:flutter/material.dart';

import '../../instruments/api.dart';
import '../../instruments/components/custom_button.dart';
import '../../instruments/components/games/score_card.dart';
import '../../instruments/constants.dart';
import '../../models/game_model.dart';

class GamePage extends StatefulWidget {
  final Game game;

  GamePage({required this.game});

  @override
  State<GamePage> createState() => _GamePageState();
}


class _GamePageState extends State<GamePage> {
  late Color scoreColor;
  final ApiService _apiService = ApiService();
  int userScore=0;
  bool isRated=false;
  bool isLoaded=false;

  String appMeanScore='–';
  int appUsersRated=0;

  @override
  void initState() {
    super.initState();
    _apiService.getMyGameScore(widget.game.id).then((int val) =>
        setState(()
        {
          setScore(val);
        })
    );
    _apiService.getAppMeanGameScore(widget.game.id).then((score) =>
        setState(()
        {
          if(score!=null) {
            appMeanScore = score.value.toString();
            appUsersRated = score.number;
          }
        })
    );
  }

  Widget getScoreCard(){
    if(isLoaded) {
      //Вернуть поле с оценкой
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Моя оценка',
            style: kHeavyTextStyle,
          ),
          kHorizontalSizedBoxDivider,
          Container(
            decoration: BoxDecoration(
              color: scoreColor,
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 5.0),
              child: scoreWidget,
            ),
          ),
          kHorizontalSizedBoxDivider,
          CustomButton(
            onPressed: () {
              goToScorePage(context);
            },
            text: isRated ? 'Изменить оценку' : 'Оценить',
            color: isRated ? const Color(0xFF707070) : Colors.orange,
            textColor: Colors.white,
            isLoading: false,
          ),
        ],
      );
    }
    else {
      //Вернуть индикатор загрузки
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  late Widget scoreWidget;


  //устанавливает различные настройки виджета в зависимости от значения оценки
  void setScore(int score){
    userScore = score;
    if (score!=0) {
      isRated=true;
      scoreColor = getScoreColor(userScore.toDouble());
      scoreWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 20.0,
          ),
          const SizedBox(width: 5.0),
          Text(
            userScore.toString(),
            style: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
    } else {
      isRated=false;
      scoreColor = const Color(0xFF454545);
      scoreWidget = const Text(
        '-',
        style: TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
    isLoaded=true;
  }

  void goToScorePage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreGamePage(game: widget.game, score: userScore),
        ));
    setState(() {
      setScore(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Game game=widget.game;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          game.name,
          style: kAppBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: kDefaultPagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${game.name}(${game.yearPublished})',
                            style: kHeavyTextStyle,
                          ),
                          Text(
                            'Число игроков: ${game.minPlayers}–${game.maxPlayers}',
                            style: kTextStyle,
                          ),
                          Text(
                            (game.minPlayTime!=game.maxPlayTime)
                                ? 'Время игры: ${game.minPlayTime}–${game.maxPlayTime} минут'
                            : 'Время игры: ${game.minPlayTime} минут',
                            style: kTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        game.thumbnail,
                      ),
                    ),
                  ],
                ),
              ),
              kHorizontalSizedBoxDivider,
              kDivider,
              kHorizontalSizedBoxDivider,
              Text(
                game.description!,
                overflow: TextOverflow.fade,
                maxLines: 8,
                style: kTextStyle,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Navigator.push( context, MaterialPageRoute(
                      builder: (context) => GameFullDescriptionPage(
                        description: game.description!,
                        bggUrl: game.bggUrl,
                      ))
                  );
                },
                child: Row(
                  children: const [
                    Text(
                      'Читать полное описание',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              kDivider,
              const Text(
                'Оценки',
                style: kHeavyTextStyle,
              ),
              Column(
                children: [
                  kHorizontalSizedBoxDivider,
                  Container(
                    color: const Color(0xFF454545),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: getScoreCard(),
                    ),
                  ),
                  kHorizontalSizedBoxDivider,
                  Row(
                    children: [
                      Expanded(
                        child: ScoreCard(
                          score: game.bggRating.toStringAsFixed(1),
                          numberOfScores: game.bggUsersRated,
                          label: 'Рейтинг BGG',
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: ScoreCard(
                          score: appMeanScore,
                          numberOfScores: appUsersRated,
                          //TODO: отредачить label когда придумаю название
                          label: 'Рейтинг DWM',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
