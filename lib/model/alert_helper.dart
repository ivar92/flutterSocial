import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttersocial/util/firebase_handler.dart';

class AlertHelper {
  Future<void> error(BuildContext context, String error) async {
    bool isiOS = (Theme.of(context).platform == TargetPlatform.iOS);
    final title = Text("Erreur");
    final explanation = Text(error);
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return (isiOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: explanation,
                  actions: [close(ctx, "OK")],
                )
              : AlertDialog(
                  title: title,
                  content: explanation,
                  actions: [close(ctx, "OK")],
                );
        });
  }

  Future<void> disconnect(BuildContext context) async {
    bool isiOS = (Theme.of(context).platform == TargetPlatform.iOS);
    Text title = Text("Voulez-vous vous deconneter ?");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return (isiOS)
              ? CupertinoAlertDialog(
                  title: title,
                  actions: [close(context, "NON"), disconnectBtn(context)])
              : AlertDialog(
                  title: title,
                  actions: [close(context, "NON"), disconnectBtn(context)]);
        });
  }

  TextButton close(BuildContext context, String string) {
    return TextButton(
        onPressed: (() => Navigator.pop(context)), child: Text(string));
  }

  TextButton disconnectBtn(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
          FirebaseHandler().logOut();
        },
        child: Text("OUI"));
  }
}
