import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersocial/util/constante.dart';

class Post {
   DocumentReference? ref;
   String? documentsId;
   String? id;
   String? memberId;
   String? text;
   String? imageUrl;
   int? date;
   List<dynamic>? likes;
   List<dynamic>? comments;

  Post(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentsId = snapshot.id;
    Map<String, dynamic> datas = snapshot.data() as Map<String, dynamic>;
    memberId = datas[uidKey];
    id = datas[postIdKey!];
    text = datas[textKey];
    imageUrl = datas[imageUrlKey!];
    date = datas[dateKey];
    likes = datas[likesKey];
    comments = datas[commentKey];
  }

  Map<String, dynamic>? toMap() {
    Map<String?, dynamic> map = {
      postIdKey!: id,
      uidKey!: memberId,
      likesKey!: likes,
      commentKey!: comments,
    };
    if (text != null) {
      map[textKey!] = text;
    }
    if (imageUrl != null) {
      map[imageUrlKey!] = imageUrl;
    }
  }
}
