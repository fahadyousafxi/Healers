import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String token) async {
    return FirebaseFirestore.instance.collection("users").where("token", isEqualTo: token).get().catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance.collection("users").where('userName', isEqualTo: searchField).get();
  }

  // Create Message
  Future<void> createMessage(Message message) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).set(message.toJson()).catchError((e) {
      print(e);
    });
  }

  // to remove message from firebase
  Future<void> deleteMessage(Message message) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).delete().catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> getUserMessages(String userId, {perPage = 10}) {
    return FirebaseFirestore.instance.collection("messages").where('visible_to_users', arrayContains: userId).orderBy('time', descending: true).limit(perPage).snapshots();
  }

  Future<Message> getMessage(Message message) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).get().then((value) {
      return Message.fromDocumentSnapshot(value);
    });
  }

  Stream<QuerySnapshot> getUserMessagesStartAt(String userId, DocumentSnapshot lastDocument, {perPage = 10}) {
    return FirebaseFirestore.instance
        .collection("messages")
        .where('visible_to_users', arrayContains: userId)
        .orderBy('time', descending: true)
        .startAfterDocument(lastDocument)
        .limit(perPage)
        .snapshots();
  }

  Stream<List<Chat>> getChats(Message message) {
    updateMessage(message.id, {'read_by_users': message.readByUsers});
    return FirebaseFirestore.instance.collection("messages").doc(message.id).collection("chats").orderBy('time', descending: true).snapshots().map((QuerySnapshot query) {
      List<Chat> retVal = [];
      query.docs.forEach((element) {
        retVal.add(Chat.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<void> addMessage(Message message, Chat chat) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).collection("chats").add(chat.toJson()).whenComplete(() {
      updateMessage(message.id, message.toUpdatedMap());
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateMessage(String messageId, Map<String, dynamic> message) {
    return FirebaseFirestore.instance.collection("messages").doc(messageId).update(message).catchError((e) {
      print(e.toString());
    });
  }

  Future<String> uploadFile(File _imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(_imageFile);
    return uploadTask.then((TaskSnapshot storageTaskSnapshot) {
      return storageTaskSnapshot.ref.getDownloadURL();
    }, onError: (e) {
      throw Exception(e.toString());
    });
  }
}
