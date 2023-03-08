import 'package:json_annotation/json_annotation.dart';
part 'errors_model.g.dart';


@JsonSerializable()
class Errors {
  List<dynamic>? email;
  List<dynamic>? password;
  List<dynamic>? confirm_password;

  Errors({
    this.email,
    this.password,
    this.confirm_password,
  });

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorsToJson(this);
}