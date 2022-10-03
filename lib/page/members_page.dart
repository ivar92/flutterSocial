import 'package:flutter/material.dart';
import 'package:fluttersocial/model/member.dart';

class MembersPage extends StatefulWidget {
  Member member;

  MembersPage({required this.member});

  @override
  State<StatefulWidget> createState() => MembersState();
}

class MembersState extends State<MembersPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Members Page"));
  }
}
