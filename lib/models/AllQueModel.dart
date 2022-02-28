import 'package:cloud_firestore/cloud_firestore.dart';

class AllQueModel {
  String? documentId;
  int? id;
  int? day;
  int? like;
  int? week;
  int? month;
  int? option1Price;
  int? option2Price;
  int? qualityOfLife1;
  int? qualityOfLife2;
  int? send;
  String? cardType;
  String? category;
  String? description;
  String? note;
  String? option_1;
  String? option_2;
  String? badge;

  AllQueModel(
      {this.documentId,
      this.id,
      this.day,
      this.like,
      this.week,
      this.month,
      this.option1Price,
      this.option2Price,
      this.qualityOfLife1,
      this.qualityOfLife2,
      this.send,
      this.cardType,
      this.category,
      this.description,
      this.note,
      this.option_1,
      this.option_2,
      this.badge});

  AllQueModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    id = documentSnapshot["id"];
    day = documentSnapshot["day"];
    like = documentSnapshot["like"];
    //week = documentSnapshot["week"];
    //month = documentSnapshot["month"];
    option1Price = documentSnapshot["option1Price"];
    option2Price = documentSnapshot["option2Price"];
    qualityOfLife1 = documentSnapshot["qualityOfLife1"];
    qualityOfLife2 = documentSnapshot["qualityOfLife2"];
    //send = documentSnapshot["send"];
    cardType = documentSnapshot["cardType"];
    category = documentSnapshot["category"];
    description = documentSnapshot["description"];
    note = documentSnapshot["note"];
    option_1 = documentSnapshot["option_1"];
    option_2 = documentSnapshot["option_2"];
    //badge = documentSnapshot["badge"];
  }

// Map<String, dynamic> toJson() => {
//   "id": id,
//   "day": day,
//   "like": like,
//   "week": week,
//   "month": month,
//   "option1Price": option1Price,
//   "option2Price": option2Price,
//   "qualityOfLife1": qualityOfLife1,
//   "qualityOfLife2": qualityOfLife2,
//   "send": send,
//   "cardType": cardType,
//   "category": category,
//   "description": description,
//   "note": note,
//   "option_1": option_1,
//   "option_2": option_2,
//   "badge": badge,
// };
}
