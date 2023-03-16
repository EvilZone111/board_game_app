import 'package:board_game_app/instruments/components/close_popup_button.dart';
import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:flutter/material.dart';

import '../../instruments/api.dart';
import '../../instruments/components/games/score_carousel.dart';
import '../../instruments/constants.dart';
import '../../instruments/helpers.dart';
import '../../models/game_model.dart';

class ScoreGamePage extends StatefulWidget {

 Game game;
 int score;

 ScoreGamePage({required this.game, required this.score});

  @override
  State<ScoreGamePage> createState() => _ScoreGamePageState();
}

class _ScoreGamePageState extends State<ScoreGamePage> {

  // bool _reloadHistoryList=false;
  late int _selectedChildIndex;

  final ApiService _apiService = ApiService();


  @override
  void initState() {
    super.initState();
    setCircleColor();
    _selectedChildIndex = widget.score;
  }

  void rateGame(int score) async {
    if(widget.score==score){
      closePage();
    } else {
      var response = await _apiService.rateGame(widget.game.id, score);
      if (response == 200 || response == 201 || response == 204) {
        setState(() {
          widget.score = score;
          setCircleColor();
          buttonText = 'Назад';
        });
      }
    }
  }

  void closePage() {
    Navigator.pop(context, widget.score);
  }

  String buttonText='Назад';

  void setButtonText(int score) {
    if(score==0){
      buttonText = 'Удалить оценку';
    } else if(widget.score==score){
      buttonText = 'Назад';
    } else {
      buttonText = 'Оценить';
    }
  }

  late Color circleColor;

  void setCircleColor(){
    if(widget.score!=0) {
      circleColor = getScoreColor(widget.score.toDouble());
    } else {
      circleColor = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.score);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClosePopupButton(onTap: closePage),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                      child: Image.network(
                        widget.game.image,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        height: MediaQuery.of(context).size.height/3,
                      ),
                    ),
                    Text(
                      widget.game.name,
                      style: kHeavyTextStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.game.yearPublished.toString(),
                      style: const TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
                kWideHorizontalSizedBoxDivider,
                SizedBox(
                  height: 140.0,
                  child: ScoreCarousel(
                    //pagerHeight: (MediaQuery.of(context).size.height) * 0.25,
                    pagerHeight: 140.0,
                    currentPage: widget.score,
                    indexChanged: (int index) {
                      setState(() {
                        _selectedChildIndex = index;
                        // _reloadHistoryList = true;
                        setButtonText(index);
                        if(widget.score==index) {
                          circleColor = getScoreColor(widget.score.toDouble());
                        } else {
                          circleColor = Colors.black;
                        }
                      });
                    },
                    userScore: widget.score,
                    circleColor: circleColor,
                  ),
                ),
                kWideHorizontalSizedBoxDivider,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomButton(
                    onPressed: (){
                      setState(() {
                        rateGame(_selectedChildIndex);
                      });
                    },
                    text: buttonText,
                    color: kDefaultButtonColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
