import 'package:flutter/material.dart';

import '../instruments/api.dart';
import '../instruments/components/custom_search_field.dart';
import '../instruments/components/search_page_layout.dart';
import '../instruments/constants.dart';

class ChooseCityPage extends StatefulWidget {
  const ChooseCityPage({Key? key}) : super(key: key);

  @override
  State<ChooseCityPage> createState() => _ChooseCityPageState();
}

class _ChooseCityPageState extends State<ChooseCityPage> {
  Future<List<Map<String,dynamic>>?>? futureCities;

  final ApiService _apiService = ApiService();

  bool isSearching = false;

  void search(text) async {
    setState(() {
      if (!text.isEmpty) {
        isSearching = true;
        futureCities = _apiService.searchCity(text);
      }
      else {
        isSearching = false;
      }
    });
  }

  Widget buildItem(city, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            Navigator.pop(context, city);
            // print(snapshot.data.items![index].geometry[0].point);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 8.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  city['city'],
                  style: kBigTextStyle,
                ),
                if(city['additional']!=null)
                  Text(
                    city['additional'],
                    style: kGreyTexStyle,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchPageLayout(
      future: futureCities,
      isSearching: isSearching,
      searchField: Hero(
        tag: 'citySearchField',
        child: CustomSearchField(
          onTextChanged: search,
          hint: 'Введите город',
        ),
      ),
      searchResults: buildItem,
      isPopup: true,
    );
  }
}