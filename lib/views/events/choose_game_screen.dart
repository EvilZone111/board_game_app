import 'package:flutter/material.dart';

import '../../instruments/api.dart';
import '../../instruments/components/custom_search_field.dart';
import '../../instruments/components/games/list_game_item.dart';
import '../../instruments/components/search_page_layout.dart';
import '../../models/game_model.dart';

class ChooseGamePage extends StatefulWidget {
  const ChooseGamePage({Key? key}) : super(key: key);

  @override
  State<ChooseGamePage> createState() => _ChooseGamePageState();
}

class _ChooseGamePageState extends State<ChooseGamePage> {
  Future<List<Game>>? futureGames;

  final ApiService _apiService = ApiService();

  bool isSearching = false;
  void search(text) async{
    setState(() {
      if(!text.isEmpty) {
        isSearching = true;
        futureGames = _apiService.searchGames(text);
      }
      else{
        isSearching = false;
      }
    });
  }

  Widget buildItem(game, int index) {
    return ListGameItem(
      game: game,
      onTap: () {
        Navigator.pop(context, game);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchPageLayout(
      future: futureGames,
      isSearching: isSearching,
      searchField: Hero(
        tag: 'gameSearchField',
        child: CustomSearchField(
          onTextChanged: search,
          hint: 'Введите название игры',
        ),
      ),
      searchResults: buildItem,
      isPopup: true,
    );
  }
}


