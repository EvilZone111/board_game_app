import 'package:board_game_app/instruments/components/profiles/profile_card.dart';
import 'package:board_game_app/instruments/constants.dart';
import 'package:flutter/material.dart';

class ProfileVerticalListView extends StatefulWidget {

  Future future;
  String title;
  String listIsEmptyText;
  double itemTileHeight;
  void Function(List) goToShowAll;
  Widget Function(dynamic) itemWidget;

  ProfileVerticalListView({
    required this.future,
    required this.title,
    required this.listIsEmptyText,
    required this.itemTileHeight,
    required this.goToShowAll,
    required this.itemWidget
  });

  @override
  State<ProfileVerticalListView> createState() => _ProfileVerticalListViewState();
}

class _ProfileVerticalListViewState extends State<ProfileVerticalListView> {

  static const divider = Divider(
    thickness: 2,
  );

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: kBigTextStyle,
          ),
          divider,
          FutureBuilder(
            future: widget.future,
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if(snapshot.data==null){
                  return SizedBox(
                    height: 50,
                    child: Text(
                      widget.listIsEmptyText,
                      style: kTextStyle,
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 185,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 8,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(width: 10,);
                            },
                            itemBuilder: (context, index) {
                              var item = snapshot.data[index];
                              return widget.itemWidget(item);
                            },
                          ),
                        ),
                        divider,
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              widget.goToShowAll(snapshot.data);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Показать все',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
