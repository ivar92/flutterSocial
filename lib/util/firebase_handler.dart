import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:fluttersocial/util/constante.dart';

import '../model/post.dart';

class FirebaseHandler {
  // Auth
  final authInstance = FirebaseAuth.instance;

  //login
  Future<User> signIn(String mail, String pwd) async {
    final userCredential = await authInstance.signInWithEmailAndPassword(
        email: mail, password: pwd);
    final User user = userCredential.user!;
    return user;
  }

  //Create a new user
  Future<User> createUser(
      String mail, String pwd, String name, String surname) async {
    final userCredential = await authInstance.createUserWithEmailAndPassword(
        email: mail, password: pwd);

    // recovered user
    final User? user = userCredential.user;

    Map<String, dynamic> memberMap = {
      nameKey!: name,
      surnameKey!: surname,
      imageUrlKey!: "",
      followersKey!: [user!.uid],
      followingKey!: [],
      uidKey!: user.uid,
    };
    // Add user
    addUserToFirebase(memberMap);
    return user;
  }

  logOut() {
    authInstance.signOut();
  }

// Database
  static final fireStoreInstance = FirebaseFirestore.instance;
  final fire_user = fireStoreInstance.collection(memberRef!);

  // Storage
  static final storageRef = storage.FirebaseStorage.instance.ref();

// ajouter un utulisateur sur firebase
  addUserToFirebase(Map<String, dynamic> map) {
    fire_user.doc(map[uidKey]).set(map);
  }

  Future<Widget?> addPostToFirebase(
      String memberId, String text, File? file) async {
    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    Map<String, dynamic> map = {
      uidKey!: memberId,
      likesKey!: likes,
      commentKey!: comments,
      dateKey!: date,
    };

    if (text != null && text != "") {
      map[textKey!] = text;
    }

    if (file != null) {
      final ref =
          storageRef.child(memberId).child("post").child(date.toString());
      final urlString = await addImageToStorage(ref, file);
      map[imageUrlKey!] = urlString;
      fire_user.doc(memberId).collection("post").doc().set(map);
    } else {
      fire_user.doc(memberId).collection("post").doc().set(map);
    }
  }

  Future<String> addImageToStorage(storage.Reference ref, File file) async {
    storage.UploadTask task = ref.putFile(file);
    storage.TaskSnapshot snapshot = await task.whenComplete(() => null);
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }

  addOrRemoveLike(Post post, String memberId) {
    if (post.likes!.contains(memberId)) {
      post.ref!.update({
        likesKey!: FieldValue.arrayRemove([memberId])
      });
    } else {
      post.ref!.update({
        likesKey!: FieldValue.arrayUnion([memberId])
      });
      //Ajouter notification a aimé post
    }
  }

  Stream<QuerySnapshot> postFrom(String uid) {
    return fire_user.doc(uid).collection("post").snapshots();
  }

  modifyPicture(File file) {
    String uid = authInstance.currentUser!.uid;
    final ref = storageRef.child(uid);
    addImageToStorage(ref, file).then((value) {
      Map<String, dynamic> newMap = {imageUrlKey!: value};
      modifyMember(newMap, uid);
    });
  }

  modifyMember(Map<String, dynamic> map, String uid) {
    fire_user.doc(uid).update(map);
  }
}
