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
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => kDivider,
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
