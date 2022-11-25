import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/message_model.dart';
import '../../../models/notification_model.dart' as model;
import '../../../routes/app_routes.dart';
import '../controllers/notifications_controller.dart';
import 'notification_item_widget.dart';

class MessageNotificationItemWidget extends GetView<NotificationsController> {
  MessageNotificationItemWidget({Key key, this.notification}) : super(key: key);
  final model.Notification notification;

  @override
  Widget build(BuildContext context) {
    return NotificationItemWidget(
      notification: notification,
      onDismissed: (notification) {
        controller.removeNotification(notification);
      },
      icon: Icon(
        Icons.chat_outlined,
        color: Get.theme.scaffoldBackgroundColor,
        size: 34,
      ),
      onTap: (notification) async {
        Get.toNamed(Routes.CHAT, arguments: new Message([], id: notification.data['message_id'].toString()));
        await controller.markAsReadNotification(notification);
      },
    );
  }
}
