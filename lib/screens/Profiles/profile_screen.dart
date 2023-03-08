import 'package:board_game_app/instruments/constants.dart';
import 'package:board_game_app/screens/Profiles/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../instruments/api.dart';
import '../../instruments/helpers.dart';
import '../../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  int userId;

  ProfilePage({required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//TODO: профиль

class _ProfilePageState extends State<ProfilePage> {

  final ApiService _apiService = ApiService();
  late Future<User> user;
  // late Future<String> appBarText;
  String appBarText = 'Загрузка...';
  double circleRadius=60.0;
  double padding = 30;
  bool isMine=false;

  @override
  void initState(){
    super.initState();
    setState(() {
      user = setUser();
      user.then((val) {
        setState(() {
          appBarText = '${val.firstName} ${val.lastName}';
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
                    _apiService.searchCity('Уфа');
                  },
                ),
              ),
          ],
        ),
      body: FutureBuilder<User>(
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
                //TODO: загрузка фото
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
                      color: kDefaultBackgroundColor,
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(circleRadius+20),
                      child: Column(
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: kHeavyTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // if (user.sex!=null)
                              //   Text('a'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: padding),
                  child: CircleAvatar(
                    radius: circleRadius,
                    backgroundImage: getProfilePicture(user.profilePicture),
                    //backgroundImage: user.profilePicture==null ? const AssetImage('assets/images/blank_pfp.png') as ImageProvider : NetworkImage(user.profilePicture),
                  ),
                ),
                // Container(
                //   width: circleRadius,
                //   height: circleRadius,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black26,
                //         blurRadius: 8.0,
                //         offset: Offset(0.0, 5.0),
                //       ),
                //     ],
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.all(4.0),
                //     child: Center(
                //       child: CircleAvatar(
                //         backgroundImage: NetworkImage(user.profilePicture), /// replace your image with the Icon
                //       ),
                //     ),
                //   ),
                // ),
              ],
            );
          }
        },
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