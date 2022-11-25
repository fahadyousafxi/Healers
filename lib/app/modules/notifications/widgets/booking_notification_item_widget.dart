import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../models/notification_model.dart' as model;
import '../../../routes/app_routes.dart';
import '../controllers/notifications_controller.dart';
import 'notification_item_widget.dart';

class BookingNotificationItemWidget extends GetView<NotificationsController> {
  BookingNotificationItemWidget({Key key, this.notification}) : super(key: key);
  final model.Notification notification;

  @override
  Widget build(BuildContext context) {
    return NotificationItemWidget(
      notification: notification,
      onDismissed: (notification) {
        controller.removeNotification(notification);
      },
      icon: Icon(
        Icons.assignment_outlined,
        color: Get.theme.scaffoldBackgroundColor,
        size: 34,
      ),
      onTap: (notification) async {
        Get.toNamed(Routes.BOOKING, arguments: new Booking(id: notification.data['booking_id'].toString()));
        await controller.markAsReadNotification(notification);
      },
    );
  }
}
