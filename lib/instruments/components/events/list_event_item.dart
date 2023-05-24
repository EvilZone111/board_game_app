import 'package:flutter/material.dart';
import '../../../models/event_model.dart';
import '../../constants.dart';

class ListEventItem extends StatelessWidget {
  Event event;
  VoidCallback onTap;

  ListEventItem({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var formattedData = event.formattedStringData();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style: kHeavyTextStyle,
            ),
            kHorizontalSizedBoxDivider,
            IntrinsicHeight(
              child: SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.network(
                          event.gameThumbnail,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    kVerticalSizedBoxDivider,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.gameName,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                event.getFormattedDate(),
                                style: kGreyBigTextStyle,
                              ),
                              Text(
                                formattedData['timeRange']!,
                                style: kGreyBigTextStyle,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: formattedData['participatorsCardColor'],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 5.0,
                                    top: 4.0,
                                    bottom: 6.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        formattedData['participatorsInfo'],
                                        style: kBigTextStyle,
                                      ),
                                      const Icon(
                                        Icons.person,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
