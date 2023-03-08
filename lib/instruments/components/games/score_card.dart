import 'package:flutter/material.dart';

import '../../constants.dart';

class ScoreCard extends StatelessWidget {
  String score;
  int numberOfScores;
  String label;

  ScoreCard({required this.score, required this.numberOfScores, required this.label});

  String rightCase(int number){
    int lastDigit = number%10;
    if(number%100~/10==1) {
      return 'оценок';
    }
    else {
      if (lastDigit == 0 || lastDigit == 5 || lastDigit == 6 || lastDigit == 7 ||
          lastDigit == 8 || lastDigit == 9) {
        return 'оценок';
      }
      if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) {
        return 'оценки';
      }
      return 'оценка';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF454545),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                score,
                style: kHeavyTextStyle,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${numberOfScores.toString()} ${rightCase(numberOfScores)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
