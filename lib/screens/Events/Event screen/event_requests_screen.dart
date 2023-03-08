import 'package:board_game_app/instruments/api.dart';
import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../instruments/components/custom_alert_dialog.dart';
import '../../../instruments/constants.dart';
import '../../../instruments/helpers.dart';
import '../../../models/participation_request_model.dart';
import '../../Profiles/profile_screen.dart';

//TODO: обновление списка участников при принятии заявки

class EventRequestsScreen extends StatefulWidget {

  int eventId;

  EventRequestsScreen({required this.eventId});

  @override
  State<EventRequestsScreen> createState() => _EventRequestsScreenState();
}

class _EventRequestsScreenState extends State<EventRequestsScreen> {

  ApiService _apiService = ApiService();

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
            style: const TextStyle(
                fontSize: 17,
                color: Colors.black
            ),
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
                setState(() {
                  Navigator.pop(context);
                  loadRequests();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Заявки на участие ',
            style: kAppBarTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
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
                    // return Text(data.userId.toString());
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
                                  sendResponse(RequestResponse.accept, data);
                                },
                                text: 'Принять',
                                color: Colors.green,
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
      ),
    );
  }
}
