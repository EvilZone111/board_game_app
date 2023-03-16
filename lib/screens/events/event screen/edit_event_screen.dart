import 'package:board_game_app/screens/Events/event_form.dart';
import 'package:flutter/material.dart';

import '../../../instruments/api.dart';
import '../../../models/event_model.dart';

class EditEventPage extends StatelessWidget {

  late Event event;

  EditEventPage({required this.event});

  // const EditEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    return EventForm(
      widgetText: 'Изменить мероприятие',
      event: event,
      onSuccess: (Event event) async {
        await apiService.editEvent(event, event.id!);
        var newEvent = event;
        if(context.mounted) {
          Navigator.pop(context, newEvent);
          ScaffoldMessenger.of(context)
              .showSnackBar(
              const SnackBar(content: Text('Мероприятие успешно изменено')));
        }
      },
    );
  }
}
