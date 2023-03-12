import 'dart:async';
import 'dart:convert';
import 'package:board_game_app/instruments/helpers.dart';
import 'package:board_game_app/models/participation_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_mean_game_score.dart';
import '../models/game_model.dart';
import '../models/user_model.dart';
import 'constants.dart';
import 'package:xml2json/xml2json.dart';
import 'package:board_game_app/models/event_model.dart';
import 'package:board_game_app/api_key.dart';

class ApiService {

  String? token = '';

  //аутентификация
  Future<dynamic> authenticate(email, password) async {
    final response = await http.post(Uri.parse('${urlPrefix}token/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', body['access']);
      prefs.setString('refresh_token', body['refresh']);
      prefs.setInt('id', body['id']);
      return {
        'statusCode': response.statusCode,
        'id': body['id']
      };
    }
    var body = json.decode(response.body);
    return {
      'statusCode': response.statusCode,
      'detail': body['detail']
    };
  }

  //TODO: возвращается пароль, сделать чтоб возвращался хэш
  //регистрация
  Future<dynamic> register(email, password, confirmPassword, firstName, lastName, city, cityId) async{
    final response = await http.post(Uri.parse('${urlPrefix}register/'),
      headers: {
        "content-type": "application/json"
      },
      body: json.encode({
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        'first_name': firstName,
        'last_name': lastName,
        'city': city,
        'city_id': cityId,
      }),
    );
    if (response.statusCode == 201) {
      final loginResponse = await http.post(Uri.parse('${urlPrefix}token/'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      var body = json.decode(loginResponse.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', body['access']);
      prefs.setString('refresh_token', body['refresh']);
      prefs.setInt('id', body['id']);
      print(loginResponse.statusCode);
      return loginResponse.statusCode;
    }
    else {
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  //получение игры
  Future<Game> getGame(id) async {
    final response = await http.get(Uri.parse('https://boardgamegeek.com/xmlapi2/thing?id=$id&stats=1'));
    final myTransformer = Xml2Json();
    myTransformer.parse(response.body);
    var data = myTransformer.toGData();
    var responseData = json.decode(data);
    Game game = Game.fromJson(responseData['items']['item']);
    return game;
  }

  //поиск игр
  Future<List<Game>> searchGames(search) async {
    final response = await http.get(Uri.parse(
        'https://boardgamegeek.com/xmlapi2/search?query=$search&type=boardgame,boardgameexpansion'
    ));
    final myTransformer = Xml2Json();
    myTransformer.parse(response.body);
    var data = myTransformer.toGData();
    var responseData = json.decode(data);
    List<Game> games=[];
    String ids='';
    for(var item in responseData['items']['item']){
      ids='$ids${item['id']},';
    }
    final response2 = await http.get(Uri.parse('https://boardgamegeek.com/xmlapi2/thing?id=$ids&stats=1'));
    final myTransformer2 = Xml2Json();
    myTransformer2.parse(response2.body);
    var data2 = myTransformer2.toGData();
    var responseData2 = json.decode(data2);
    for(int i=0; i<responseData['items']['item'].length;i++){
      Game singleGame = Game.fromJson(responseData2['items']['item'][i]);
      games.add(singleGame);
    }
    return games;
  }

  //получение оценки авторизованного пользователя на данную игру
  Future<int> getMyGameScore(int gameId) async{
    token = await getToken();
    final response = await http.get(Uri.parse('${urlPrefix}scores/my_score/$gameId/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    var responseData = json.decode(response.body);
    if(responseData['score']==null){
      return 0;
    }
    return responseData['score'];
  }

  //выставление оценки игре
  Future<dynamic> rateGame(int gameId, int score) async{
    token = await getToken();
    if(score!=0) {
      final response = await http.post(
        Uri.parse('${urlPrefix}scores/rate/$gameId/'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "score": score,
        }),
      );
      return response.statusCode;
    } else {
      final response = await http.delete(Uri.parse('${urlPrefix}scores/delete/$gameId/'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode;
    }
  }

  //получение средней оценки игры
  Future<AppMeanGameScore?> getAppMeanGameScore(int gameId) async{
    token = await getToken();
    final response = await http.get(Uri.parse('${urlPrefix}scores/score/$gameId/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if(response.statusCode==204){
      return null;
    }
    var responseData = json.decode(response.body);
    return AppMeanGameScore.fromJson(responseData);
  }

  //получение информации о пользователе
  Future<User> getUserInfo(int userId) async {
    token = await getToken();
    final response = await http.get(Uri.parse('${urlPrefix}profiles/$userId/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    return User.fromJson(responseData);
  }

  //обновление информации о пользователе
  Future<dynamic> updateUserInfo([birthDate, sex, bio, profilePicture]) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    final response = await http.patch(Uri.parse('${urlPrefix}profiles/$id/'),
      headers: {
        "content-type": "application/json"
      },
      body: json.encode({
        'date_of_birth': birthDate,
        'sex': sex==null ? sex : 'U',
        'bio': bio,
        'profilePicture': profilePicture,
      }),
    );
    if (response.statusCode == 200) {
      return {
        'statusCode': response.statusCode,
        'id': id
      };
    }
    else {
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  //создание мероприятия
  Future<Event> createEvent(Event event) async{
    token = await getToken();
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('id')!;
    User organizer = await getUserInfo(id);
    event.city=organizer.city;
    event.cityId=organizer.cityId;
    final response = await http.post(Uri.parse('${urlPrefix}events/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(event.toJson()),
    );
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    var createdEvent = Event.fromJson(responseData);
    List<User> participators=[organizer];
    createdEvent.participators = participators;
    return createdEvent;
  }

  //изменение мероприятия
  Future<Event> editEvent(Event event, int eventId) async{
    token = await getToken();
    final response = await http.put(Uri.parse('${urlPrefix}events/$eventId/edit/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(event.toJson()),
    );
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    var editedEvent = Event.fromJson(responseData);
    return editedEvent;
  }

  //поиск мероприятия по фильтрам
  Future<List<Event>?> searchEvent(var filters) async{
    token = await getToken();
    final response = await http.get(
      Uri.parse('${urlPrefix}events/?'
        'game=${filters['game']}&'
        'city_id=${filters['cityId']??''}&'
        'date__gte=${filters['minDate']}&'
        'date__lte=${filters['maxDate']}&'
        'is_active=${filters['is_active']}/'
      ),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    List<Event> events=[];
    for(var event in responseData){
      User organizer = await getUserInfo(event['organizer']);
      List<User> participators = await getEventParticipators(event['id']);
      participators.insert(0, organizer);
      Event singleEvent = Event.fromJson(event);
      singleEvent.participators = participators;
      events.add(singleEvent);
    }
    if(events.isEmpty){
      return null;
    }
    return events;
  }

  //отправление заявки на участие
  Future<dynamic> sendParticipationRequest(int eventId, String message) async{
    token = await getToken();
    final response = await http.post(
      Uri.parse('${urlPrefix}requests/participate/$eventId/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "message": message,
      }),
    );
    return response.statusCode;
  }

  //отмена заявки на участие
  Future<dynamic> cancelParticipationRequest(int eventId) async {
    token = await getToken();
    final response = await http.delete(
      Uri.parse('${urlPrefix}requests/delete/$eventId/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode;
  }

  //получение статуса заявки авторизованного пользователя
  Future<ParticipationRequest?> getMyRequestStatus(int eventId) async {
    token = await getToken();
    final response = await http.get(Uri.parse('${urlPrefix}requests/event/$eventId/my_request/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if(response.statusCode==204) {
      return null;
    }
    // if(response.statusCode==200) {
    var responseData = json.decode(response.body);
    return ParticipationRequest.fromJson(responseData[0]);
    // }
    // return response.statusCode;
  }

  //получение заявок на участие в данном мероприятии
  Future<List<ParticipationRequest>?> getEventParticipationRequests(int eventId) async {
    token = await getToken();
    final response = await http.get(Uri.parse('${urlPrefix}requests/event/$eventId/unhandled_requests/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if(response.statusCode==204) {
      return null;
    }
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    List<ParticipationRequest> userRequests = [];
    for(var request in responseData){
      ParticipationRequest singleRequest = ParticipationRequest.fromJson(request);
      User user = await getUserInfo(singleRequest.userId);
      singleRequest.user=user;
      userRequests.add(singleRequest);
    }
    return userRequests;
  }

  //получение списка участников
  Future<List<User>> getEventParticipators(int eventId) async {
    token = await getToken();
    final response = await http.get(
      Uri.parse('${urlPrefix}requests/event/$eventId/participators/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    List<User> participators = [];
    if (response.statusCode == 204) {
      return participators;
    }
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    for (var request in responseData) {
      ParticipationRequest singleRequest = ParticipationRequest.fromJson(
          request);
      User user = await getUserInfo(singleRequest.userId);
      participators.add(user);
    }
    return participators;
  }

  //ответ на заявку на участие
  Future<dynamic> respondToRequest(userId, eventId, isAccepted, [answer]) async{
    final response = await http.patch(Uri.parse('${urlPrefix}requests/respond/$eventId/$userId/'),
      headers: {
        "content-type": "application/json"
      },
      body: json.encode({
        'answer': answer,
        'is_accepted': isAccepted,
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    }
    else {
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  Future<List<Map<String, dynamic>>?> searchCity(String query) async{
    String apiKey = citySearchApiKey;
    final response = await http.get(Uri.parse('https://api.vk.com/method/database.getCities?country_id=1&q=$query&need_all=0&count=100&access_token=$apiKey&v=5.131&lang=ru'));
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    List<Map<String, dynamic>> cities = [];
    for(var dataObject in responseData['response']['items']){
      cities.add({
        'id': dataObject['id'],
        'city': '${dataObject['title']}',
        'additional': '${dataObject['area']!=null ? '${dataObject['area']}' : ''}${dataObject['area']!=null && dataObject['region']!=null ? ', ' : ''}${dataObject['region']!=null ? '${dataObject['region']}' : null}',
      });
    }
    if(cities.isEmpty){
      return null;
    }
    return cities;
  }
}