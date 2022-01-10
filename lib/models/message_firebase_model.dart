import 'package:cloud_firestore/cloud_firestore.dart';

class MessageFirebaseModel {
  String senderId;
  String content;
  String timestamp;

  MessageFirebaseModel({required this.senderId, required this.content, required this.timestamp});

  factory MessageFirebaseModel.fromJson(DocumentSnapshot documentSnapshot){
    return MessageFirebaseModel(senderId: documentSnapshot.get('senderId'), content: documentSnapshot.get('content'), timestamp: documentSnapshot.get('timestamp'));
  }
}