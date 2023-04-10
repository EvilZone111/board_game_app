import 'package:board_game_app/instruments/constants.dart';
import 'package:board_game_app/models/game_model.dart';
import 'package:flutter/material.dart';
import '../../instruments/api.dart';
import '../../instruments/components/custom_search_field.dart';
import '../../instruments/components/games/list_game_item.dart';
import '../../instruments/components/search_page_layout.dart';

import 'game_screen.dart';

class SearchGamesPage extends StatefulWidget {

  @override
  State<SearchGamesPage> createState() => _SearchGamesPageState();
}

class _SearchGamesPageState extends State<SearchGamesPage> {
  Future<List<Game>>? futureGames;

  final ApiService _apiService = ApiService();

  bool inSearchMode = false;
  Widget appBarTitle = const Text(
      'Поиск',
      style:  kAppBarTextStyle,
  );


  Icon appBarIcon = kSearchIcon;
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

  Widget buildItem(game, int index){
    return ListGameItem(
      game: game,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.push( context, MaterialPageRoute(
            builder: (context) => GamePage(game: game,)
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchPageLayout(
      searchField: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                if(inSearchMode){
                  appBarTitle = const Text(
                    'Поиск',
                    style:  kAppBarTextStyle,
                  );
                  appBarIcon = kSearchIcon;
                  isSearching = false;
                }
                else{
                  appBarTitle = CustomSearchField(
                    onTextChanged: search,
                    hint: 'Введите название игры',
                    height: 49,
                  );
                  appBarIcon = kCloseIcon;
                }
                inSearchMode=!inSearchMode;
              });
            },
            icon: appBarIcon,
          ),
        ],
      ),
      future: futureGames,
      searchResults: buildItem,
      isSearching: isSearching,
      isPopup: false,
    );
  }
}
