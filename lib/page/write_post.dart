import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttersocial/custom_widget/my_gradiant.dart';
import 'package:fluttersocial/custom_widget/my_textField.dart';
import 'package:fluttersocial/custom_widget/padding_with.dart';
import 'package:fluttersocial/model/color_theme.dart';
import 'package:fluttersocial/util/constante.dart';
import 'package:fluttersocial/util/firebase_handler.dart';
import 'package:image_picker/image_picker.dart';

class WritePost extends StatefulWidget {
  late String memberId;
  WritePost({required this.memberId});

  @override
  State<StatefulWidget> createState() => WriteState();
}

class WriteState extends State<WritePost> {
  late TextEditingController _controller;
  File? _imageFile;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ColorTheme().base(),
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width,
        child: PaddingWith(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: ColorTheme().accent(),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: InkWell(
                  onTap: ((() =>
                      FocusScope.of(context).requestFocus(FocusNode()))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PaddingWith(
                          child: Text("Ecrivez quelque chose..."),
                        ),
                        PaddingWith(
                          child: MyTextField(
                              controller: _controller,
                              hint: "Exprimez vous",
                              icon: writePost),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: cameraIcon,
                                onPressed: (() =>
                                    takePicture(ImageSource.camera))),
                            IconButton(
                                icon: libraryIcon,
                                onPressed: (() =>
                                    takePicture(ImageSource.gallery)))
                          ],
                        ),
                        Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: (_imageFile == null)
                                  ? Text("pas d'images")
                                  :Image.file(_imageFile!),
                            ),
                        Card(
                          elevation: 7.5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: MyGradiant(
                                startColor: ColorTheme().base(),
                                endColor: ColorTheme().pointer(),
                                radius: 25,
                                horizontal: true),
                            child: TextButton(
                                onPressed: (() {
                                  // envoyer a firebase
                                  sendToFirebase();
                                }),
                                child: Text("Envoyer")),
                          ),
                        )
                      ],
                    ),
                  )),
            )));
  }

  takePicture(ImageSource source) async {
    final imagePath = await ImagePicker()
        .getImage(source: source, maxHeight: 500, maxWidth: 500);
    final file = File(imagePath!.path);
    setState(() {
      _imageFile = file;
    });
  }

  sendToFirebase() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context);
    if ((_imageFile != null) ||
        (_controller.text != null && _controller.text != "")) {
      FirebaseHandler()
          .addPostToFirebase(widget.memberId, _controller.text, _imageFile);
    }
  }
}
