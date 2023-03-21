import 'dart:io';
import 'package:board_game_app/instruments/components/games/list_game_item.dart';
import 'package:board_game_app/instruments/components/profiles/profile_card.dart';
import 'package:board_game_app/instruments/components/profiles/show_all_layout.dart';
import 'package:board_game_app/instruments/constants.dart';
import 'package:board_game_app/models/friend_request_model.dart';
import 'package:board_game_app/screens/Profiles/additional_info_popup_screen.dart';
import 'package:board_game_app/screens/Profiles/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../instruments/api.dart';
import '../../instruments/components/events/list_event_item.dart';
import '../../instruments/components/profiles/profile_vertical_list_view.dart';
import '../../instruments/helpers.dart';
import '../../models/event_model.dart';
import '../../models/game_model.dart';
import '../../models/user_model.dart';
import 'package:image_picker/image_picker.dart';

import '../Events/Event screen/event_screen.dart';
import '../Games/game_screen.dart';

class ProfilePage extends StatefulWidget {
  int userId;

  ProfilePage({required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//TODO: уведомления

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();
  late Future<User> user;
  late Future<List<Game>> games;
  late Future<List<Event>?> events;
  late Future<FriendRequest?> friendRequest;
  String appBarText = 'Загрузка...';
  double circleRadius=60.0;
  double padding = 30;
  bool isMine=false;
  late ImageProvider profilePicture;

  @override
  void initState(){
    super.initState();
    setState(() {
      user = setUser();
      user.then((val) {
        setState(() {
          appBarText = '${val.firstName} ${val.lastName}';
          profilePicture = getProfilePicture(val.profilePicture);
          games = _apiService.getRatedGames(val.id);
          events = _apiService.getUserEvents(val.id);
          friendRequest = _apiService.getFriendshipStatus(val.id);
        });
      });
    });
  }

  Future<User> setUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('id')!;
    isMine=id==widget.userId;
    return _apiService.getUserInfo(widget.userId);
  }

  Future<File?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image!=null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }

  void goToGamePage(game){
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.push( context, MaterialPageRoute(
        builder: (context) => GamePage(game: game)
    ));
  }

  void goToEventPage(event){
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.push( context, MaterialPageRoute(
        builder: (context) => EventPage(event: event)
    ));
  }

  Widget getFriendRequestButton(userId, FriendRequest? requestStatus){
    VoidCallback onPressedCallback=(){};
    Color buttonColor=Colors.grey;
    String buttonText='';
    IconData buttonIcon=Icons.person;

    if(requestStatus==null){
      onPressedCallback=() async { await _apiService.sendFriendRequest(userId); };
      buttonColor = Colors.blue;
      buttonText = 'Добавить в друзья';
      buttonIcon = Icons.person_add_outlined;
    }
    //TODO: отмена заявки
    else if (requestStatus.isAccepted==false){
      buttonColor=Colors.grey;
      buttonText='Отменить заявку';
      buttonIcon = Icons.person;
      //TODO: удаление из друзей
    } else {
      buttonColor = Colors.red;
      buttonText = 'Удалить из друзей';
      buttonIcon = Icons.person_off_outlined;
    }
    return TextButton(
      onPressed: onPressedCallback,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child:Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              buttonIcon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 3),
            Align(
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            appBarText,
            style: kAppBarTextStyle,
          ),
          actions: <Widget>[
            if(isMine)
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.settings,
                    size: 40.0,
                  ),
                  onPressed: () {
                    Navigator.push( context, MaterialPageRoute(
                        builder: (context) => SettingsPage())
                    );
                  },
                ),
              ),
          ],
        ),
      body: SingleChildScrollView(
        child: FutureBuilder<User>(
          future: user,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var user = snapshot.data;
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SizedBox(
                    height: 70+padding,
                    width: double.infinity,
                    child: Image.network(
                      //TODO: изменить картинку на фоне
                      'https://e.snmc.io/i/600/w/1eedaa4059b152941f79581614fb28b8/10135733/krallice-years-past-matter-Cover-Art.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: circleRadius+padding),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white10,
                      ),
                      width: double.infinity,
                      // height: 1000,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: kDefaultBackgroundColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: circleRadius+10, bottom: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  showModalBottomSheet<Map<String, dynamic>>(
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
                                      return AdditionalInfoPopupPage(user: user);
                                    },
                                  );
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: kHeavyTextStyle,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 5,),
                                          Text(
                                            user.city,
                                            style: kGreyTextStyle,
                                          ),
                                          const SizedBox(width: 10,),
                                          const Icon(
                                            Icons.info_outline,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 5,),
                                          const Text(
                                            'Подробнее',
                                            style: kGreyTextStyle,
                                          ),
                                        ],
                                      ),
                                      if(!isMine)
                                        FutureBuilder(
                                          future: friendRequest,
                                          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState != ConnectionState.done) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8,
                                                  right: 8,
                                                  top: 10,
                                                ),
                                                child: getFriendRequestButton(user.id, snapshot.data),
                                              );
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          //TODO: френдлист
                          ProfileCard(
                            content: Text(
                              '31 друг',
                              style: kTextStyle,
                            ),
                          ),
                          ProfileVerticalListView(
                            future: games,
                            title: 'Игры пользователя',
                            listIsEmptyText: '${user.firstName} ${user.lastName} пока не оценил ни одной игры',
                            itemTileHeight: 190,
                            goToShowAll: (gameList){
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.push( context, MaterialPageRoute(
                                builder: (context) => ShowAllPageLayout(
                                  items: gameList,
                                  appBarText: 'Игры',
                                  buildItem: (game, index){
                                    return ListGameItem(
                                      game: game,
                                      onTap: (){
                                        goToGamePage(game);
                                      },
                                      userScore: game.currentUserScore,
                                    );
                                  },
                                ),
                              ));
                            },
                            itemWidget: (game){
                              return GestureDetector(
                                onTap: (){
                                  goToGamePage(game);
                                },
                                child: SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.network(
                                            game.thumbnail,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      kHorizontalSizedBoxDivider,
                                      Flexible(
                                        child: Text(
                                          game.name,
                                          style: kTextStyle,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          // overflow: ,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          ProfileVerticalListView(
                            future: events,
                            title: 'Мероприятия пользователя',
                            itemTileHeight: 150,
                            listIsEmptyText: '${user.firstName} ${user.lastName} не зарегестрирован на мероприятия',
                            goToShowAll: (eventList){
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.push( context, MaterialPageRoute(
                                  builder: (context) => ShowAllPageLayout(
                                    items: eventList,
                                    appBarText: 'Мероприятия',
                                    buildItem: (event, index){
                                      return ListEventItem(
                                        event: event,
                                        onTap: (){
                                          goToEventPage(event);
                                        },
                                      );
                                    },
                                  )
                              ));
                            },
                            itemWidget: (event){
                              return GestureDetector(
                                onTap: () {
                                  goToEventPage(event);
                                },
                                child: SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.network(
                                            event.gameThumbnail,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      kHorizontalSizedBoxDivider,
                                      Flexible(
                                        child: Text(
                                          event.name,
                                          style: kTextStyle,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          // overflow: ,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          event.getFormattedDate(),
                                          style: kTextStyle,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          // overflow: ,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: padding),
                    child: GestureDetector(
                      onTap: () async {
                        if(isMine) {
                          File? image = await getImage();
                          if(image!=null) {
                            var response = await _apiService.uploadPfp(image);
                            if(response==200){
                              setState(() {
                                profilePicture = FileImage(image);
                              });
                            }
                          }
                        }
                      },
                      child: CircleAvatar(
                        radius: circleRadius,
                        backgroundImage: profilePicture,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


// return Padding(
// padding: kDefaultPagePadding,
// //padding: EdgeInsets.symmetric(horizontal: 1.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Expanded(
// flex: 1,
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// CircleAvatar(
// radius: (MediaQuery.of(context).size.width-40)*0.15,
// backgroundImage: NetworkImage(user.profilePicture),
// ),
// SizedBox(width: 20,),
// Column(
// // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// '${user.firstName} ${user.lastName}',
// style: kHeavyTextStyle,
// ),
// ],
// ),
// ],
// ),
// ),
// Expanded(
// flex: 3,
// child: Container(),
// )
// ],
// ),
// );