import 'package:board_game_app/instruments/components/events/list_event_item.dart';
import 'package:board_game_app/instruments/components/search_page_layout.dart';
import 'package:board_game_app/models/event_model.dart';
import 'package:board_game_app/views/Events/Search%20Events/filters_popup_screen.dart';
import 'package:flutter/material.dart';
import '../../../instruments/api.dart';
import '../../../instruments/constants.dart';
import '../Event screen/event_screen.dart';

class SearchEventsPage extends StatefulWidget {

  @override
  State<SearchEventsPage> createState() => _SearchEventsPageState();
}

class _SearchEventsPageState extends State<SearchEventsPage> {
  Future<List<Event>?>? futureEvents;

  final ApiService _apiService = ApiService();

  bool isSearching = false;

  Map<String, dynamic>? appliedFilters;

  void searchWithFilters() async {
    final filters = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        builder: (_) {
          return FiltersPopupPage(appliedFilters: appliedFilters);
        });
    if(filters!=null) {
      setState(() {
        appliedFilters=filters;
        isSearching=true;
        futureEvents = _apiService.searchEvent(appliedFilters);
      });
    }
  }

  List<Event> events=[];

  Widget buildItem(eventData, index) {
    if (events.length - 1 < index) {
      events.add(eventData);
    }
    Event event = events[index];
    return ListEventItem(
        event: event,
        onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final result = await Navigator.push( context, MaterialPageRoute(
            builder: (context) => EventPage(event: event,))
        );
        setState(() {
          events[index]=result;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchPageLayout(
      searchField: AppBar(
        title: const Text(
          'Список мероприятий',
          style: kAppBarTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: searchWithFilters,
            icon: Icon(
              Icons.filter_list,
              color: appliedFilters==null? Colors.white : Colors.blue,
            ),
          ),
        ],
      ),
      future: futureEvents,
      searchResults: buildItem,
      isSearching: isSearching,
      isPopup: false,
    );
  }
}