import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../constants.dart';

class ListProfileItem extends StatelessWidget {
  User user;
  VoidCallback onTap;

  ListProfileItem({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 32.0,
                backgroundImage: user.getProfilePicture(),
              ),
              const SizedBox(width: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: kHeavyTextStyle,
                    ),
                    // Text(
                    //   data.message,
                    //   style: const TextStyle(
                    //     fontSize: 20.0,
                    //     fontWeight: FontWeight.w300,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
