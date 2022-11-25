import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/chat_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/messages_controller.dart';
import '../widgets/chat_message_item_widget.dart';

// ignore: must_be_immutable
class ChatsView extends GetView<MessagesController> {
  final _myListKey = GlobalKey<AnimatedListState>();

  Widget chatList() {
    return Obx(
      () {
        if (controller.chats.isEmpty) {
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: "Type a message to start chat!".tr,
          );
        } else {
          return ListView.builder(
              key: _myListKey,
              reverse: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              itemCount: controller.chats.length,
              shrinkWrap: false,
              primary: true,
              itemBuilder: (context, index) {
                Chat _chat = controller.chats.elementAt(index);
                _chat.user = controller.message.value.users.firstWhere((_user) => _user.id == _chat.userId, orElse: () => new User(name: "-", avatar: new Media()));
                return ChatMessageItem(
                  chat: _chat,
                );
              });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.message.value = Get.arguments as Message;
    if (controller.message.value.id != null) {
      controller.listenForChats();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () async {
              controller.message.value = new Message([]);
              controller.chats.clear();
              await controller.refreshMessages();
              Get.back();
            }),
        automaticallyImplyLeading: false,
        title: Obx(() {
          return Text(
            controller.message.value.name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          );
        }),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: chatList(),
          ),
          Obx(() {
            if (controller.uploading.isTrue)
              return Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(),
              );
            else
              return SizedBox();
          }),
          Container(
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Wrap(
                  children: [
                    SizedBox(width: 10),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        var imageUrl = await controller.getImage(ImageSource.gallery);
                        if (imageUrl != null && imageUrl.trim() != '') {
                          await controller.addMessage(controller.message.value, imageUrl);
                        }
                        Timer(Duration(milliseconds: 100), () {
                          controller.chatTextController.clear();
                        });
                      },
                      icon: Icon(
                        Icons.photo_outlined,
                        color: Get.theme.colorScheme.secondary,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        var imageUrl = await controller.getImage(ImageSource.camera);
                        if (imageUrl != null && imageUrl.trim() != '') {
                          await controller.addMessage(controller.message.value, imageUrl);
                        }
                        Timer(Duration(milliseconds: 100), () {
                          controller.chatTextController.clear();
                        });
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Get.theme.colorScheme.secondary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: controller.chatTextController,
                    style: Get.textTheme.bodyText1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: "Type to start chat".tr,
                      hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                      suffixIcon: IconButton(
                        padding: EdgeInsetsDirectional.only(end: 20, start: 10),
                        onPressed: () {
                          controller.addMessage(controller.message.value, controller.chatTextController.text);
                          Timer(Duration(milliseconds: 100), () {
                            controller.chatTextController.clear();
                          });
                        },
                        icon: Icon(
                          Icons.send_outlined,
                          color: Get.theme.colorScheme.secondary,
                          size: 30,
                        ),
                      ),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
