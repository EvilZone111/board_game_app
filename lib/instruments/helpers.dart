import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'constants.dart';
import 'package:geolocator/geolocator.dart';

Future<String?> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if(pref.getString('token')!= null){
    if(JwtDecoder.isExpired(pref.getString('token')!)){
      String refreshToken = pref.getString('refresh_token')!;
      final response = await http.post(Uri.parse('${urlPrefix}token/refresh/'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          'refresh': refreshToken,
        }),
      );
      pref.setString('token', json.decode(response.body)['access']);
    }
    return pref.getString('token');
  }
  return null;
}

Color getScoreColor(double score){
  Color color;
  score>=7.0
      ? color=Colors.green
      : (score>=5.0 ? color=Colors.grey : color=Colors.red);
  return color;
}

class Location {

  late double latitude;
  late double longitude;

  Future getCurrentLocation() async{
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch(e){
      print(e);
    }
  }
}

String getFormattedAddress(address){
  String? textResult ='';
  if(address.addressComponents[SearchComponentKind.street] != null){
    textResult+=address.addressComponents[SearchComponentKind.street]!;
    if(address.addressComponents[SearchComponentKind.house] != null){
      textResult+=', ';
      textResult+=address.addressComponents[SearchComponentKind.house]!;
    }
  }
  else {
    if (address.addressComponents[SearchComponentKind.district] != null) {
      textResult +=address.addressComponents[SearchComponentKind.district]!;
    } else {
      if (address.addressComponents[SearchComponentKind.vegetation] != null){
        textResult += address.addressComponents[SearchComponentKind.vegetation]!;
      }
      else {
        textResult += address.formattedAddress;
      }
    }
  }
  return textResult;
}

String to24hours(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, "0");
  final min = time.minute.toString().padLeft(2, "0");
  return "$hour:$min";
}

enum RequestStatus {notSend, accepted, notAccepted}

enum RequestResponse {accept, decline}

ImageProvider getProfilePicture(String? picture){
  if(picture==null){
    return const AssetImage('assets/images/blank_pfp.png');
  }
  return NetworkImage(picture);
}

String getFormattedDate(String date){
  List<String> months = [
    'Января',
    'Февраля',
    'Марта',
    'Апреля',
    'Мая',
    'Июня',
    'Июля',
    'Августа',
    'Сентября',
    'Октября',
    'Ноября',
    'Декабря'
  ];
  List<String> dateParts=date.split('-');
  return '${dateParts[2][0]=='0'? dateParts[2][1] : dateParts[0]} ${months[int.parse(dateParts[1])-1]} ${dateParts[0]}';
}

