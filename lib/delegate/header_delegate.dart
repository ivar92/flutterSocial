import 'package:flutter/material.dart';

import '../model/color_theme.dart';
import '../model/member.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  Member? member;
  VoidCallback callback;
  bool? scrolled;

  HeaderDelegate(
      {required this.callback, required this.member, required this.scrolled});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(10),
      color: ColorTheme().accent(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          (scrolled!)
              ? Container(
                  height: 0,
                  width: 0,
                )
              : InkWell(
                  child: const Text(""),
                  onTap: (() {
                    
                  }),
                ),
                Text(member!.description ?? "Aucune description"),
                Divider(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () {
                      
                    }, child: Text("Followers: ${member!.followers.length}")),
                    TextButton(onPressed: () {
                      
                    }, child: Text("Following: ${member!.following.length}"))
                  ],
                )
        ],
      ),
    );
  }

  @override
  //TODO: implement maExtent
  double get maxExtent => (scrolled!) ? 125 : 121;

  @override
  //TODO: implement maExtent
  double get minExtent => (scrolled!) ? 125 : 121;

  @override
  bool shouldRebuild(HeaderDelegate oldDelegate) =>
      scrolled! != oldDelegate.scrolled! || member! != oldDelegate.member!;
}
