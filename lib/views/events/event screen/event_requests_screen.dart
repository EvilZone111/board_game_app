import 'package:board_game_app/instruments/api.dart';
import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../instruments/components/custom_alert_dialog.dart';
import '../../../instruments/constants.dart';
import '../../../instruments/helpers.dart';
import '../../../models/participation_request_model.dart';
import '../../../models/user_model.dart';
import '../../Profiles/profile_screen.dart';


//TODO: уведомление пользователя при ответе на заявку

class EventRequestsScreen extends StatefulWidget {

  int eventId;
  List<User> participators;
  int maxPlayers;

  EventRequestsScreen({required this.eventId, required this.participators, required this.maxPlayers});

  @override
  State<EventRequestsScreen> createState() => _EventRequestsScreenState();
}

class _EventRequestsScreenState extends State<EventRequestsScreen> {

  final ApiService _apiService = ApiService();

  late Future<List<ParticipationRequest>?> futureRequests;

  @override
  void initState(){
    super.initState();
    loadRequests();
  }

  void loadRequests() async {
    futureRequests = _apiService.getEventParticipationRequests(widget.eventId);
  }

  void sendResponse(RequestResponse response, ParticipationRequest request) async {
    var messageController = TextEditingController();
    OutlineInputBorder borderStyle = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: response==RequestResponse.accept ? 'Принять заявку' : 'Отклонить заявку',
          content: TextField(
            controller: messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ваш ответ',
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: borderStyle,
              focusedBorder: borderStyle,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
            style: kBlackTextStyle,
          ),
          actions: [
            CustomButton(
              onPressed: () async {
                await _apiService.respondToRequest(
                  request.userId,
                  request.eventId,
                  response==RequestResponse.accept? true : false,
                  messageController.text,
                );
                var newParticipator = await _apiService.getUserInfo(request.userId);
                setState(() {
                  Navigator.pop(context);
                  loadRequests();
                  widget.participators.add(newParticipator);
                });
              },
              text: 'Отправить',
              color: response==RequestResponse.accept ? Colors.green : Colors.red,
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }

  bool isSlotsAvailable(){
    return widget.participators.length<widget.maxPlayers;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, widget.participators);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Заявки на участие ',
              style: kAppBarTextStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if(!isSlotsAvailable())
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.warning,
                              ),
                              kVerticalSizedBoxDivider,
                              Expanded(
                                child: Text(
                                  'Вы не можете принимать заявки, потому что количество участников максимально',
                                  style: kTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  flex: 13,
                  child: FutureBuilder(
                    future: futureRequests,
                    initialData: const [],
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data.isEmpty){
                        return const Center(
                          child: Text(
                            'Необработанные входящие заявки отсутствуют',
                            style: kTextStyle,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, index)
                          {
                            var data = snapshot.data[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    Navigator.push( context, MaterialPageRoute(
                                        builder: (context) => ProfilePage(userId: data.userId,))
                                    );
                                  },
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        CircleAvatar(
                                          radius: 32.0,
                                          backgroundImage: getProfilePicture(data.user.profilePicture),
                                        ),
                                        const SizedBox(width: 20,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data.user.firstName} ${data.user.lastName}',
                                                style: kHeavyTextStyle,
                                              ),
                                              Text(
                                                data.message,
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                kHorizontalSizedBoxDivider,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        onPressed: (){
                                          if(isSlotsAvailable()) {
                                            sendResponse(RequestResponse.accept, data);
                                          }
                                        },
                                        text: 'Принять',
                                        color: isSlotsAvailable() ? Colors.green : Colors.grey,
                                        textColor: Colors.white,
                                      ),
                                    ),
                                    kVerticalSizedBoxDivider,
                                    Expanded(
                                      child: CustomButton(
                                        onPressed: (){
                                          sendResponse(RequestResponse.decline, data);
                                        },
                                        text: 'Отклонить',
                                        color: Colors.red,
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                kDivider,
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
