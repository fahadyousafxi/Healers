/*
 * File name: messages_view.dart
 * Last modified: 2022.02.17 at 15:18:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/messages_controller.dart';
import '../widgets/message_item_widget.dart';

class MessagesView extends GetView<MessagesController> {
  Widget conversationsList() {
    return Obx(
      () {
        if (controller.messages.isNotEmpty) {
          var _messages = controller.messages;
          return ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              controller: controller.scrollController,
              itemCount: _messages.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return MessageItemWidget(
                  message: _messages.elementAt(index),
                  onDismissed: (conversation) async {
                    await controller.deleteMessage(_messages.elementAt(index));
                  },
                );
                // }
              });
        } else {
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: "Messages List Empty".tr,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            controller.messages.clear();
            controller.lastDocument = new Rx<DocumentSnapshot>(null);
            await controller.listenForMessages();
          },
          child: conversationsList()),
    );
  }
}
