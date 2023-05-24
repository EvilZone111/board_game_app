import 'dart:io';

import 'package:flutter/material.dart';

import '../../screens/no_internet_connection_screen.dart';

class ConnectionChecker extends StatefulWidget {

  String noInternetTitle;
  Widget screen;
  Function fetchData;

  ConnectionChecker({required this.noInternetTitle, required this.screen, required this.fetchData});

  @override
  State<ConnectionChecker> createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {
  bool isInternetAvailable = false;

  Future<void> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          widget.fetchData();
          isInternetAvailable = true;
        });
      } else {
        setState(() {
          isInternetAvailable = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isInternetAvailable = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isInternetConnected();

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: isInternetConnected,
      child: isInternetAvailable
          ? widget.screen
          : InternetNotAvailable(
        title: widget.noInternetTitle,
        refresh: isInternetConnected,
      )
    );
  }
}
