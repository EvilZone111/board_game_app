import 'package:board_game_app/views/Events/event_form.dart';
import 'package:flutter/material.dart';

import '../../../instruments/api.dart';
import '../../../models/event_model.dart';
import '../Event screen/event_screen.dart';

class CreateEventScreen extends StatelessWidget {

  // late Event event;

  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    // Future<Event> create(event) async {
    //   var newEvent = await apiService.createEvent(event);
    //   return newEvent;
    // }
    return EventForm(
      widgetText: 'Создать мероприятие',
      onSuccess: (Event event) async {
        var newEvent = await apiService.createEvent(event);
        if(context.mounted) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventPage(event: newEvent)
            ),
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(
              const SnackBar(content: Text('Мероприятие успешно создано')));
        }
      },
    );
  }
}
