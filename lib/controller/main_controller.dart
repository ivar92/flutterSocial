import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttersocial/controller/loading_controller.dart';
import 'package:fluttersocial/custom_widget/bar_item.dart';
import 'package:fluttersocial/model/color_theme.dart';
import 'package:fluttersocial/model/member.dart';
import 'package:fluttersocial/page/members_page.dart';
import 'package:fluttersocial/page/profile_page.dart';
import 'package:fluttersocial/page/write_post.dart';
import 'package:fluttersocial/util/constante.dart';
import 'package:fluttersocial/util/firebase_handler.dart';
import 'package:fluttersocial/page/home_page.dart';
import 'package:fluttersocial/page/notif_page.dart';

class MainController extends StatefulWidget {
  late String memberUid;

  MainController({required this.memberUid});

  @override
  State<StatefulWidget> createState() => MainState();
}

class MainState extends State<MainController> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  late StreamSubscription? streamSubscription;
  Member? member;
  late int index = 0;

  @override
  void initState() {
    super.initState();
    // Recuperer user à partir de uid;
    streamSubscription = FirebaseHandler()
        .fire_user
        .doc(widget.memberUid)
        .snapshots()
        .listen((event) {
      setState(() {
        member = Member(event);
        ;
      });
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (member == null)
        ? LoaadingController()
        : Scaffold(
            key: _globalKey,
            body: showPage(),
            bottomNavigationBar: BottomAppBar(
              color: ColorTheme().accent(),
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  BarItem(
                      icon: homeIcon,
                      onPressed: (() => buttomSelected(0)),
                      selected: (index == 0)),
                  BarItem(
                      icon: friendsIcon,
                      onPressed: (() => buttomSelected(1)),
                      selected: (index == 1)),
                  Container(width: 0, height: 0),
                  BarItem(
                      icon: notifIcon,
                      onPressed: (() => buttomSelected(2)),
                      selected: (index == 2)),
                  BarItem(
                      icon: profileIcon,
                      onPressed: (() => buttomSelected(4)),
                      selected: (index == 4)),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
                child: writePost,
                onPressed: () {
                  _globalKey.currentState
                      ?.showBottomSheet((context) => WritePost(
                            memberId: widget.memberUid,
                          ));
                }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }

  buttomSelected(int index) {
    setState(() {
      this.index = index;
    });
  }

  // ajout des pages
  Widget? showPage() {
    switch (index) {
      case 0:
        return HomePage(member: member);
      case 1:
        return MembersPage(member: member!);
      case 2:
        return NotifPage(member: member!);
      case 4:
        return ProfilePage(member: member!);
    }
  }
}
