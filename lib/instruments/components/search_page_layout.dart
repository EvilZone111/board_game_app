import 'package:flutter/material.dart';

import '../constants.dart';
import 'close_popup_button.dart';

class SearchPageLayout extends StatefulWidget {

  Widget searchField;
  Widget Function(dynamic, int index) searchResults;
  Future? future;
  bool isSearching;
  bool isPopup;


  SearchPageLayout({
    required this.searchField,
    required this.searchResults,
    this.future,
    required this.isSearching,
    required this.isPopup,
  });


  @override
  State<SearchPageLayout> createState() => _SearchPageLayoutState();
}

class _SearchPageLayoutState extends State<SearchPageLayout> {

  Widget showResults() {
    return FutureBuilder(
      future: widget.future,
      initialData: const [],
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        // print(snapshot.data);
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data==null){
          return const Center(
            child: Text(
              'По вашему запросу ничего не найдено',
              style: kTextStyle,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, index)
            {
              var data = snapshot.data[index];
              return widget.searchResults(data, index);
            },
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.isPopup ? null : PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:  widget.searchField,
        ),
        body: widget.isPopup ?
        Column(
          children: [
            Expanded(
              flex: 1,
              child: ClosePopupButton(
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: widget.searchField,
            ),
            Expanded(
              flex: 10,
              child: widget.isSearching ? showResults() : Container(),
            )
            // if(widget.isSearching)
            //     child: showResults(),
            //   )
          ],
        ) :
        widget.isSearching ? showResults() : const Center(
          child: Text(
            'Здесь будут выведены результаты поиска',
            style: kTextStyle,
          ),
        ),
      ),
    );
  }
}
