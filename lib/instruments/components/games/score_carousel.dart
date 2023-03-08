import 'dart:math';

import 'package:board_game_app/instruments/helpers.dart';
import 'package:flutter/material.dart';

class ScoreCarousel extends StatefulWidget {
  /// constructor
  ScoreCarousel(
      {this.scaleFraction = 1,
        this.fullScale = 1.0,
        this.pagerHeight = 200.0,
        this.currentPage = 2,
        required this.indexChanged,
        required this.userScore,
        required this.circleColor,
      });
  @override
  _ScoreCarouselState createState() => _ScoreCarouselState();

  /// scale fraction
  final double scaleFraction;

  /// full scale
  final double fullScale;

  /// pager height
  final double pagerHeight;

  /// current page
  final int currentPage;

  final List<String> data = ['–','1','2','3','4','5','6','7','8','9','10'];

  /// index changed
  final Function(int index) indexChanged;

  final int userScore;

  Color circleColor;

}

class _ScoreCarouselState extends State<ScoreCarousel> {
  // control parameters
  final double _viewPortFraction = 0.25;
  late PageController _pageController;
  int _currentPage = 2;
  double _page = 2;
  bool isUserScore=true;

  @override
  void initState() {
    _currentPage = widget.currentPage;
    _page = _currentPage.toDouble();
    // circleColor  = getScoreColor(_currentPage.toDouble());
    _pageController = PageController(
        initialPage: _currentPage, viewportFraction: _viewPortFraction);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        const SizedBox(
          // height: 20,
        ),
        Container(
          height: widget.pagerHeight,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {
                  _page = _pageController.page!;
                });
              }

              return true;
            },
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: widget.pagerHeight,
                    height: widget.pagerHeight,
                    decoration: BoxDecoration(
                      color: widget.circleColor,
                      // color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                PageView.builder(
                onPageChanged: (int pos) {
                  setState(() {
                    _currentPage = pos;
                    widget.indexChanged(pos);
                    if(_currentPage==widget.userScore){
                      widget.circleColor = getScoreColor(double.parse(widget.userScore.toString()));
                    } else {
                      widget.circleColor = Colors.black;
                    }
                  });
                },
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Color textColor;
                  if(index == widget.userScore){
                    textColor = Colors.white;
                  } else {
                    textColor = getScoreColor(double.parse(index.toString()));
                  }
                  final double scale = max(
                      widget.scaleFraction,
                      (widget.fullScale - (index - _page).abs()) +
                          _viewPortFraction);
                  if(_currentPage== widget.userScore) {
                    return circleOffer(widget.data[index], scale, textColor);
                  } else {
                    return circleOffer(widget.data[index], scale,
                        getScoreColor(double.parse(index.toString())));
                  }
                },
              ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget circleOffer(String score, double scale, textColor) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: widget.pagerHeight * scale,
        width: widget.pagerHeight * scale,
        child: Center(
          child: Text(
            score,
            style: TextStyle(
              fontSize: 50.0 * scale,
              fontWeight: FontWeight.w900,
              color: score=='–' ? Colors.grey : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
