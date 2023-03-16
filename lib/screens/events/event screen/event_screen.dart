import 'package:board_game_app/instruments/api.dart';
import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:board_game_app/instruments/helpers.dart';
import 'package:board_game_app/models/participation_request_model.dart';
import 'package:board_game_app/screens/Events/Event%20screen/edit_event_screen.dart';
import 'package:board_game_app/screens/Events/Event%20screen/event_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:board_game_app/models/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../instruments/components/custom_alert_dialog.dart';
import '../../../instruments/components/games/score_circle.dart';
import '../../../instruments/constants.dart';
import '../../../models/game_model.dart';
import '../../Games/game_screen.dart';
import '../../Profiles/profile_screen.dart';


class EventPage extends StatefulWidget {

  late Event event;

  EventPage({required this.event});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  final ApiService _apiService = ApiService();

  Future<Game>? futureGame;

  bool isMine=false;

  void getUserId() {
    SharedPreferences.getInstance().then((prefValue) => {
      setState(() {
        int id = prefValue.getInt('id')!;
        if (id == widget.event.organizerId) {
          isMine = true;
        }
        else {
          isMine = false;
        }
      })
    });
  }

  Future<ParticipationRequest?> getRequest(){
    return _apiService.getMyRequestStatus(widget.event.id!);
  }

  void cancelRequest() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Вы уверены, что хотите это сделать?',
          actions: [
            CustomButton(
              onPressed: () async {
                await _apiService.cancelParticipationRequest(widget.event.id!);
                setState(() {
                  Navigator.pop(context);
                });
              },
              text: 'Да',
              color: Colors.red,
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }

  void sendRequest() async {
    var messageController = TextEditingController();
    OutlineInputBorder borderStyle = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Отправить сообщение организатору',
          content: TextField(
            controller: messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Напишите что-нибудь...',
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: borderStyle,
              focusedBorder: borderStyle,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
            style: const TextStyle(
                fontSize: 17,
                color: Colors.black
            ),
          ),
          actions: [
            CustomButton(
              onPressed: () async {
                await _apiService.sendParticipationRequest(
                    widget.event.id!,
                    messageController.text
                );
                setState(() {
                  Navigator.pop(context);
                });
              },
              text: 'Отправить',
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }

  void deleteParticipator(int index) async {
    var messageController = TextEditingController();
    OutlineInputBorder borderStyle = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Удалить участника',
          content: TextField(
            controller: messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Сообщение участника',
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: borderStyle,
              focusedBorder: borderStyle,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
            style: kBlackTextStyle,
          ),
          actions: [
            CustomButton(
              // onPressed: () {
              //   print(widget.event.participators![index].id);
              // },
              onPressed: () async {
                var response = await _apiService.respondToRequest(
                  widget.event.participators![index].id,
                  widget.event.id,
                  false,
                  messageController.text,
                );
                if(response==200) {
                  setState(() {
                    Navigator.pop(context);
                    widget.event.participators?.removeAt(index);
                  });
                }
              },
              text: 'Удалить',
              color: Colors.red,
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }

  Widget getParticipationRequestButton(RequestStatus status){
    if(status==RequestStatus.notSend) {
      return CustomButton(
        onPressed: () {
          setState(() {
            sendRequest();
          });
        },
        text: 'Подать заявку на участие',
        color: Colors.blue,
        textColor: Colors.white,
      );
    }
    if(status==RequestStatus.accepted) {
      return CustomButton(
        onPressed: () {
          setState(() {
            cancelRequest();
          });
        },
        text: 'Отказаться от участия',
        color: Colors.red,
        textColor: Colors.white,
      );
    }
    return CustomButton(
      onPressed: () {
        setState(() {
          cancelRequest();
        });
      },
      text: 'Отменить заявку',
      color: Colors.red,
      textColor: Colors.white,
    );
  }

  Widget iconAndText({icon, text}){
    return Container(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: kBigIconSize,
              ),
              kVerticalSizedBoxDivider,
              Flexible(
                child: Text(
                  text,
                  style: kEventPageTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    getUserId();
    futureGame = _apiService.getGame(widget.event.gameId);
  }
  @override
  Widget build(BuildContext context) {
    Event event = widget.event;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.name,
          style: kAppBarTextStyle,
        ),
        actions: [
          if(isMine)
            IconButton(
              icon: const Icon(Icons.edit_note,
                size: 30.0,
              ),
              onPressed: () async {
                final result = await Navigator.push( context, MaterialPageRoute(
                    builder: (context) => EditEventPage(event: event))
                );
                if(result!=null) {
                  setState(() {
                    widget.event = result;
                  });
                }
              },
            ),
        ],
      ),
      body: WillPopScope(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      kHorizontalSizedBoxDivider,
                      FutureBuilder(
                        future: futureGame,
                        initialData: const [],
                        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
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
                            Game game=snapshot.data;
                            double gameScore;
                            game.score==0.0 ? gameScore = game.bggRating : gameScore = game.score;
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Navigator.push( context, MaterialPageRoute(
                                    builder: (context) => GamePage(game: game,)
                                ));
                              },
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image.network(
                                          game.thumbnail,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  game.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  game.yearPublished.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 10, bottom: 10),
                                                child: ScoreCircle(
                                                  gameScore: gameScore,
                                                  radius: 25,
                                                  fontSize: 20,
                                                  isUserScore: false,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 1,
                                      child: kArrowForwardIcon,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      kWideHorizontalSizedBoxDivider,
                      iconAndText(
                        icon: Icons.calendar_month,
                        text: '${event.getFormattedDate()} ${event.time.substring(0,5)}',
                      ),
                      kDivider,
                      iconAndText(
                        icon: Icons.home,
                        text: event.address,
                      ),
                      kDivider,
                      iconAndText(
                        icon: Icons.access_time,
                        text: '${event.minPlayTime}-${event.maxPlayTime} ${event.minutesRightCase()}',
                      ),
                      kDivider,
                      Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),
                        child: ListTileTheme(
                          horizontalTitleGap: 10.0,
                          minLeadingWidth: 0,
                          tileColor: Theme.of(context).canvasColor,
                          child: ExpansionTile(
                            title: Text(
                              '${event.participators!.length}/${event.maxPlayers} участников',
                              style: kEventPageTextStyle,
                            ),
                            leading: const Icon(
                              Icons.people,
                              size: kBigIconSize,
                              // color: Colors.white,
                            ),
                            childrenPadding: EdgeInsets.zero,
                            tilePadding: EdgeInsets.zero,
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            children: [
                              SizedBox(
                                height: 190.0,
                                child: ListView.separated(
                                  itemCount: event.participators!.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (BuildContext context, int index) {
                                    return const SizedBox(width: 20,);
                                  },
                                  itemBuilder: (ctx, index)
                                  {
                                    var user = event.participators![index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              child: CircleAvatar(
                                                radius: 70.0,
                                                backgroundImage: getProfilePicture(user.profilePicture),
                                              ),
                                              onTap: (){
                                                Navigator.push( context, MaterialPageRoute(
                                                    builder: (context) => ProfilePage(userId: user.id!,))
                                                );
                                              },
                                            ),
                                            if(index!=0 && isMine)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: GestureDetector(
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.close,
                                                      ),
                                                      onPressed: () {
                                                        deleteParticipator(index);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        kHorizontalSizedBoxDivider,
                                        Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          index==0 ?'Организатор' : 'Участник',
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      kDivider,
                      kWideHorizontalSizedBoxDivider,
                    ],
                  ),
                ),
              ),
            ),
            // if(!isMine)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: !isMine ?
                FutureBuilder(
                  future: getRequest(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CustomButton(
                        onPressed: () {},
                        text: 'Загрузка...',
                        color: Colors.grey,
                        textColor: Colors.white,
                      );
                    } else {
                      RequestStatus requestStatus;
                      if (snapshot.data == null) {
                        requestStatus = RequestStatus.notSend;
                      } else {
                        if (snapshot.data.isAccepted) {
                          requestStatus = RequestStatus.accepted;
                        } else {
                          requestStatus = RequestStatus.notAccepted;
                        }
                      }
                      return getParticipationRequestButton(requestStatus);
                    }
                  },
                ) :
                CustomButton(
                  onPressed: () async {
                    var participators = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => EventRequestsScreen(
                        eventId: widget.event.id!,
                        participators: widget.event.participators!,
                        maxPlayers: widget.event.maxPlayers,
                      ),
                    ));
                    setState((){
                      event.participators=participators;
                    });
                  },
                  text: 'Посмотреть заявки на участие',
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        onWillPop: () async {
          Navigator.pop(context, event);
          return true;
        },
      ),
    );
  }
}
