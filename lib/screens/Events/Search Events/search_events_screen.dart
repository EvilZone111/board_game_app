import 'package:board_game_app/instruments/components/search_page_layout.dart';
import 'package:board_game_app/models/event_model.dart';
import 'package:board_game_app/screens/Events/Search%20Events/filters_popup_screen.dart';
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

  Widget buildItem(eventData, index){
    if(events.length-1<index){
      events.add(eventData);
    }
    var formattedData=events[index].formattedStringData();
    Event event = events[index];
    //TODO: картинки одинакового размера
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            final result = await Navigator.push( context, MaterialPageRoute(
                builder: (context) => EventPage(event: event,))
            );
            setState(() {
              events[index]=result;
            });
          },
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Image.network(
                          event.gameThumbnail,
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
              ],
            ),
          ),
        ),
        kDivider,
      ],
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



// return Scaffold(
//   appBar: AppBar(
//     title: const Text(
//       'Список мероприятий',
//       style: kAppBarTextStyle,
//     ),
//     actions: [
//       IconButton(
//         onPressed: searchWithFilters,
//         icon: Icon(
//           Icons.filter_list,
//           color: appliedFilters==null? Colors.white : Colors.blue,
//         ),
//       ),
//     ],
//   ),
//   body: isSearching ?
//   FutureBuilder(
//     future: futureEvents,
//     initialData: const [],
//     builder: (BuildContext ctx, AsyncSnapshot snapshot) {
//       if (snapshot.connectionState != ConnectionState.done) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       } else if (snapshot.data==null){
//         return const Center(
//           child: Text(
//             'По вашему запросу ничего не найдено',
//             style: kTextStyle,
//           ),
//         );
//       } else {
//         return ListView.builder(
//           itemCount: snapshot.data.length,
//           itemBuilder: (ctx, index)
//           {
//             var event = snapshot.data[index] as Event;
//             //double imageHeight = MediaQuery.of(context).size.width/7*2;
//             //double imageWidth = MediaQuery.of(context).size.width/2;
//             var data = formattedStringData(event);
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: (){
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     Navigator.push( context, MaterialPageRoute(
//                         builder: (context) => EventPage(event: event,)
//                     ));
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           event.name,
//                           style: kHeavyTextStyle,
//                         ),
//                         kHorizontalSizedBoxDivider,
//                         IntrinsicHeight(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Expanded(
//                                 child: Image.network(
//                                   event.gameThumbnail,
//                                   // height: imageHeight,
//                                   // width: imageWidth,
//                                 ),
//                               ),
//                               kVerticalSizedBoxDivider,
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           event.gameName,
//                                           style: const TextStyle(
//                                             fontSize: 23,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           DateFormat('dd.MM.yyyy')
//                                               .format(DateFormat('yyyy-MM-dd')
//                                               .parse(event.date)),
//                                           style: kGreyBigText
//                                         ),
//                                         Text(
//                                           data['timeRange']!,
//                                           // '${startTime-$endTime',
//                                           style: kGreyBigText,
//                                         ),
//                                       ],
//                                     ),
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(right: 12.0),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             color: data['participatorsCardColor'],
//                                             borderRadius: BorderRadius.circular(15.0),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                               left: 8.0,
//                                               right: 5.0,
//                                               top: 4.0,
//                                               bottom: 6.0,
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Text(
//                                                   // '$participatorsCount/${event.maxPlayers}',
//                                                   data['participatorsInfo'],
//                                                   style: kBigTextStyle,
//                                                 ),
//                                                 const Icon(
//                                                   Icons.person,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 kDivider,
//               ],
//             );
//           },
//         );
//       }
//     },
//   ) :
//   const Center(
//     child: Text(
//       'Здесь будут выведены результаты поиска',
//       style: kTextStyle,
//     ),
//   ),
// );