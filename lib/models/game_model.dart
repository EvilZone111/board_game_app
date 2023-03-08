import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:html_character_entities/html_character_entities.dart';

String dummyImg='https://sun9-38.userapi.com/impf/c850036/v850036117/10c860/JmkK0CGsNFg.jpg?size=1200x1600&quality=96&sign=a40ead7fbee9d80cd28e3cca129fd7ee&type=album';

@JsonSerializable()
class Game {
  final int id;
  String thumbnail;
  String image;
  String name; //name[0]
  String? description; //description
  int? yearPublished;
  int? minPlayers;
  int? maxPlayers;
  int? minPlayTime;
  int? maxPlayTime;
  int? minAge;
  // List<String>? category;
  double bggRating; //['statistics']['ratings']['average']
  int bggUsersRated;
  double score=0;
  // int usersScored;
  final String bggUrl;

  Game({
    required this.id,
    required this.thumbnail,
    required this.image,
    required this.name,
    this.description,
    this.yearPublished,
    // required this.BGGScore,
    // this.score,
    this.minPlayers,
    this.maxPlayers,
    this.minPlayTime,
    this.maxPlayTime,
    this.minAge,
    // this.category,
    required this.bggRating,
    required this.bggUsersRated,
    required this.bggUrl,
  });

  factory Game.fromJson(Map<String, dynamic> json){
    return Game(
      id: int.parse(json['id']),
      thumbnail: json['thumbnail']!=null && json['thumbnail']['\$t']!=null ? (json['thumbnail']['\$t'] as String) : dummyImg,
      //thumbnail:dummyImg,
      image: json['image']!=null && json['image']['\$t']!=null ? (json['image']['\$t'] as String) : dummyImg,
      // image: dummyImg,
      name: json['name'][0]==null ? (json['name']['value'] as String) : (json['name'][0]['value'] as String),
      description: HtmlCharacterEntities.decode(json['description']['\$t']).replaceAll('&#10;', '\n'),
      yearPublished: int.parse(json['yearpublished']['value']),
      minPlayers: int.parse(json['minplayers']['value']),
      maxPlayers: int.parse(json['maxplayers']['value']),
      minPlayTime: int.parse(json['minplaytime']['value']),
      maxPlayTime: int.parse(json['maxplaytime']['value']),
      minAge: int.parse(json['minage']['value']),
      // category: json['boardgamecategory'] as List<String>,
      bggRating: double.parse(json['statistics']['ratings']['average']['value']),
      bggUsersRated: int.parse(json['statistics']['ratings']['usersrated']['value']),
      bggUrl: 'https://boardgamegeek.com/boardgame/${json['id']}',
    );
  }
}