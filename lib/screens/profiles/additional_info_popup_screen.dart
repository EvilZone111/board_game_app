import 'package:board_game_app/instruments/constants.dart';
import 'package:board_game_app/instruments/helpers.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class AdditionalInfoPopupPage extends StatelessWidget {

  User user;

  AdditionalInfoPopupPage({required this.user});

  Row infoField(icon, text){
    return Row(
      children: [
        Icon(
          icon,
        ),
        kVerticalSizedBoxDivider,
        Text(
          text,
          style: kTextStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Подробнее',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40,),
              infoField(Icons.location_on_outlined, 'Город: ${user.city}'),
              kHorizontalSizedBoxDivider,
              if(user.dateOfBirth!=null)
                infoField(
                  Icons.cake_outlined,
                  'День рождения: ${getFormattedDate(user.dateOfBirth!)}',
                ),
              if(user.dateOfBirth!=null)
                kHorizontalSizedBoxDivider,
              infoField(
                Icons.person,
                'Пол: ${user.sex=='U' ? 'Не указан' : user.sex=='M' ?'Мужской' : 'Женский'
                }',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
