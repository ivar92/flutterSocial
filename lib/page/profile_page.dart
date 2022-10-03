import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersocial/custom_widget/profile_image.dart';
import 'package:fluttersocial/model/alert_helper.dart';
import 'package:fluttersocial/model/color_theme.dart';
import 'package:fluttersocial/model/member.dart';
import 'package:fluttersocial/tile/post_tile.dart';
import 'package:fluttersocial/util/constante.dart';
import 'package:fluttersocial/util/images.dart';
import 'package:image_picker/image_picker.dart';
import '../delegate/header_delegate.dart';
import '../util/firebase_handler.dart';

class ProfilePage extends StatefulWidget {
  Member? member;

  ProfilePage({required this.member});

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  ScrollController? _controller;
  bool scrolled() {
    //  return true;
    if (_controller == null) return false;
    if (_controller!.hasClients) return false;
    return _controller!.hasClients &&
        _controller!.offset > 200 - kToolbarHeight;
    // _controller!.offset > 200 - kToolbarHeight &&
    //     _controller!.hasClients;
  }

  late bool isMe;

  @override
  void iniState() {
    final authId = FirebaseHandler().authInstance.currentUser!.uid;
    isMe = (authId == widget.member!.uid);
    _controller = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseHandler().postFrom(widget.member!.uid),
        builder: (BuildContext context, snapshots) {
          if (snapshots.hasData) {
            return CustomScrollView(
              controller: _controller,
              slivers: [appBar(), persistent(), list(snapshots.data!.docs)],
            );
          } else {
            return const Center(
              child: Text("Aucun post pour l'instant"),
            );
          }
        });
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      backgroundColor: ColorTheme().pointer(),
      // pour l'accrocher en haut on utulise pinned
      pinned: true,
      expandedHeight: 200,
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => AlertHelper().disconnect(context),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: 
        (scrolled())
            ?
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                    ProfileImage(
                        urlString: widget.member!.imageUrl,
                        onPressed: () {},
                        imageSize: 25),
                    // le texte qui s'affiche en haut du page quant on defile
                   
                  ])
            : Row(
              children: [
                ProfileImage(
                urlString: widget.member!.imageUrl,
                onPressed: (() => takePicture()),
                imageSize: 25), Text("${widget.member!.surname} ${widget.member!.name}", style: TextStyle(fontSize: 14),) 
              ],
            )
                ,
        background: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(profileImage), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  SliverPersistentHeader persistent() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: HeaderDelegate(
          member: widget.member!, callback: (() => {}), scrolled: scrolled()),
    );
  }

  SliverList list(List<QueryDocumentSnapshot>? snapshots) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, index) {
      if (index > snapshots!.length) {
        return null;
      } else if (index == snapshots.length) {
        return const Text("Fin de liste");
      } else {
        return PostTile(snapshot: snapshots[index], member: widget.member);
      }
    }));
  }

  takePicture() {
    // if (isMe == null) return false;
    if (isMe) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.transparent,
              child: Card(
                elevation: 7,
                margin: EdgeInsets.all(15),
                child: Container(
                  color: ColorTheme().base(),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Modification de la photo de profil"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            icon: cameraIcon,
                            onPressed: (() => picker(ImageSource.camera)),
                          ),
                          IconButton(
                            icon: libraryIcon,
                            onPressed: (() => picker(ImageSource.gallery)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  picker(ImageSource source) async {
    final f = await ImagePicker()
        .getImage(source: source, maxWidth: 500, maxHeight: 500);
    final File file = File(f!.path);
    FirebaseHandler().modifyPicture(file);
  }
}
