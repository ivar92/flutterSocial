import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersocial/custom_widget/padding_with.dart';
import 'package:fluttersocial/custom_widget/profile_image.dart';
import 'package:fluttersocial/model/post.dart';
import 'package:fluttersocial/util/constante.dart';
import 'package:fluttersocial/util/date_handler.dart';
import 'package:fluttersocial/util/firebase_handler.dart';

import '../model/member.dart';

class PostTile extends StatelessWidget {
  QueryDocumentSnapshot? snapshot;
  Member? member;

  PostTile({@required this.snapshot, required this.member});

  @override
  Widget build(BuildContext context) {
    Post post = Post(snapshot!);
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 5,
        child: PaddingWith(
          child: Column(children: [
            Row(
              children: [
                ProfileImage(urlString: member!.imageUrl, onPressed: ((() {}))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${member!.surname} ${member!.name}"),
                    Text(DateHandler().myDate(post.date!))
                  ],
                )
              ],
            ),
            Divider(),
            (post.imageUrl != null && post.imageUrl != "")
                ? PaddingWith(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(post.imageUrl!),
                              fit: BoxFit.cover)),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            (post.text != null && post.text != "")
                ? Text(post.text!)
                : Container(height: 0, width: 0),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: (post.likes!.contains(member!.uid)
                        ? likeIcon
                        : unlikeIcon),
                    onPressed: (() {
                      FirebaseHandler().addOrRemoveLike(post, member!.uid);
                    })),
                Text("${post.likes!.length} likes"),
                IconButton(
                  icon: commentIcon,
                  onPressed: ((){}),
                  ),
                  Text("${post.comments!.length} Commentaires"),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
