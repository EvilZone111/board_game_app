import 'package:flutter/material.dart';

import '../../constants.dart';

class ShowAllPageLayout extends StatefulWidget {

  List items;
  String appBarText;
  Widget Function(dynamic, int index) buildItem;


  ShowAllPageLayout({
    required this.items,
    required this.appBarText,
    required this.buildItem,
  });

  @override
  State<ShowAllPageLayout> createState() => _ShowAllPageLayoutState();
}

class _ShowAllPageLayoutState extends State<ShowAllPageLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarText,
          style: kAppBarTextStyle,
        ),
        // actions: <Widget>[
        //   if(isMine)
        //     Padding(
        //       padding: const EdgeInsets.only(right: 10.0),
        //       child: IconButton(
        //         icon: const Icon(Icons.settings,
        //           size: 40.0,
        //         ),
        //         onPressed: () {
        //           Navigator.push( context, MaterialPageRoute(
        //               builder: (context) => SettingsPage())
        //           );
        //         },
        //       ),
        //     ),
        // ],
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (ctx, index)
        {
          var data = widget.items[index];
          return widget.buildItem(data, index);
        },
      ),
    );
  }
}
