import 'package:board_game_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../instruments/helpers.dart';


@JsonSerializable()
class Event {
  int? id;
  int gameId;
  int minPlayTime;
  int maxPlayTime;
  int minPlayers;
  int maxPlayers;
  String date;
  String time;
  String address;
  String? addressAdditionalInfo;
  String? city;
  int? cityId;
  String? description;
  String name;
  int? organizerId;
  bool? isActive;

  String gameThumbnail;
  String gameName;
  List<User>? participators;

  String getFormattedDate(){
    return DateFormat('dd.MM.yyyy')
        .format(DateFormat('yyyy-MM-dd')
        .parse(date));
  }

  Map<String, dynamic> formattedStringData(){
    int participatorsCount = 0;
    final participators = this.participators;
    participatorsCount+=participators!.length;
    String participatorsInfo='$participatorsCount/$maxPlayers';
    TimeOfDay startTime = TimeOfDay(
        hour:int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1])
    );
    TimeOfDay endTime=TimeOfDay(
      hour: startTime.hour+maxPlayTime~/60,
      minute: startTime.minute+maxPlayTime%60,
    );
    String timeRange = '${to24hours(startTime)}—${to24hours(endTime)}';
    Color participatorsCardColor = participatorsCount<maxPlayers
        ? Colors.green
        : Colors.red;
    return {
      'participatorsInfo': participatorsInfo,
      'timeRange': timeRange,
      'participatorsCardColor': participatorsCardColor,
    };
  }

  String minutesRightCase(){
    int lastDigit = maxPlayTime%10;
    if(maxPlayTime%100~/10==1) {
      return 'минут';
    }
    else {
      if (lastDigit == 0 || lastDigit == 5 || lastDigit == 6 || lastDigit == 7 ||
          lastDigit == 8 || lastDigit == 9) {
        return 'минут';
      }
      if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) {
        return 'минуты';
      }
      return 'минута';
    }
  }

  String participatorsRightCase(){
    int lastDigit = maxPlayers%10;
    if(maxPlayers%100~/10==1) {
      return 'участников';
    }
    else {
      if (lastDigit == 0 || lastDigit == 5 || lastDigit == 6 || lastDigit == 7 ||
          lastDigit == 8 || lastDigit == 9) {
        return 'участников';
      }
      if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) {
        return 'участника';
      }
      return 'участник';
    }
  }

  Event({
    this.id,
    required this.gameId,
    required this.minPlayTime,
    required this.maxPlayTime,
    required this.minPlayers,
    required this.maxPlayers,
    required this.date,
    required this.time,
    required this.address,
    this.addressAdditionalInfo,
    this.city,
    this.cityId,
    this.description,
    required this.name,
    this.organizerId,
    this.isActive,

    required this.gameName,
    required this.gameThumbnail,
    this.participators,
  });

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json['id']!=null ? json['id'] as int : null,
      gameId: json['game'],
      minPlayTime: json['min_play_time'],
      maxPlayTime: json['max_play_time'],
      minPlayers: json['min_players'],
      maxPlayers: json['max_players'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
      addressAdditionalInfo: json['address_additional_info'],
      city: json['city'],
      cityId: json['city_id']!=null ? json['city_id'] : null,
      description: json['description'],
      name: json['name'],
      organizerId: json['organizer'],
      isActive: json['is_active'],

      gameName: json['game_name'],
      gameThumbnail: json['game_thumbnail'],
      // participators: json['participators'],
    );
  }

  Map<String, dynamic> toJson() => {
    'game': gameId,
    'min_play_time': minPlayTime,
    'max_play_time': maxPlayTime,
    'min_players': minPlayers,
    'max_players': maxPlayers,
    'date': date,
    'time': time,
    'address': address,
    'address_additional_info': addressAdditionalInfo,
    'city': city,
    'city_id': cityId,
    'description': description,
    'name': name,
    'game_name': gameName,
    'game_thumbnail': gameThumbnail,
    'organizer': organizerId
  };
}