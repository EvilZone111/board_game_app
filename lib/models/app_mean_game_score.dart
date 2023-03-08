import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class AppMeanGameScore {
  double value;
  int number;

  AppMeanGameScore({
    required this.value,
    required this.number,
  });

  factory AppMeanGameScore.fromJson(Map<String, dynamic> json){
    return AppMeanGameScore(
      value: json['score_value'].toDouble(),
      number: json['score_number'].toInt(),
    );
  }
}