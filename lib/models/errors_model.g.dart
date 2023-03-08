// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errors_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Errors _$ErrorsFromJson(Map<String, dynamic> json) => Errors(
      email: json['email'] as List<dynamic>?,
      password: json['password'] as List<dynamic>?,
      confirm_password: json['confirm_password'] as List<dynamic>?,
    );

Map<String, dynamic> _$ErrorsToJson(Errors instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirm_password': instance.confirm_password,
    };
