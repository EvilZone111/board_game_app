import 'package:board_game_app/views/Events/main_events_screen.dart';
import 'package:board_game_app/views/Games/search_games_screen.dart';
import 'package:board_game_app/views/Profiles/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/login_and_register/login_view_model.dart';

class HomeScreen extends StatefulWidget {
  int userId;

  HomeScreen({required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  // late int userId=widget.userId;

  HeroController _heroController = HeroController();

  static late List<Widget> _pageOptions = [];

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void onTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _pageOptions = [
      const MainEventsPage(),
      SearchGamesPage(),
      ProfilePage(userId: widget.userId,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
          !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          // body: IndexedStack(
          //   index: _selectedIndex,
          //   children: _pageOptions,
          // ),
          body: Stack(
              children: [
                _buildOffstageNavigator(0),
                _buildOffstageNavigator(1),
                _buildOffstageNavigator(2),
              ]
          ),
          // body: _pageOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'События'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.games),
                label: 'Игры',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Профиль',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            onTap: onTapped,
          ),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const MainEventsPage(),
          SearchGamesPage(),
          ProfilePage(userId: widget.userId),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: HeroControllerScope(
        controller: MaterialApp.createMaterialHeroController(),
        child: Navigator(
          key: _navigatorKeys[index],
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name]!(context),
            );
          },
        ),
      ),
    );
  }
}

