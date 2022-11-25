import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class NotificationRepository {
  LaravelApiClient _laravelApiClient;

  NotificationRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Notification>> getAll() {
    return _laravelApiClient.getNotifications();
  }

  Future<int> getCount() {
    return _laravelApiClient.getNotificationsCount();
  }

  Future<Notification> remove(Notification notification) {
    return _laravelApiClient.removeNotification(notification);
  }

  Future<Notification> markAsRead(Notification notification) {
    return _laravelApiClient.markAsReadNotification(notification);
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text, String id) {
    return _laravelApiClient.sendNotification(users, from, type, text, id);
  }
}
