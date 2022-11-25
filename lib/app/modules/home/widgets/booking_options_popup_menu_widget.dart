import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../controllers/home_controller.dart';

class BookingOptionsPopupMenuWidget extends GetView<HomeController> {
  const BookingOptionsPopupMenuWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (item) async {
        switch (item) {
          case "accept":
            {
              await controller.acceptBookingService(_booking);
            }
            break;
          case "decline":
            {
              await controller.declineBookingService(_booking);
            }
            break;
          case "view":
            {
              await Get.toNamed(Routes.BOOKING, arguments: _booking);
            }
            break;
        }
      },
      itemBuilder: (context) {
        var list = <PopupMenuEntry<Object>>[];
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "ID #".tr + _booking.id,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "View Details".tr,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        if (_booking.status.order == Get.find<GlobalService>().global.value.received) {
          list.add(
            PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.check_circle_outline, color: Get.theme.hintColor),
                  Text(
                    "Accept".tr,
                    style: TextStyle(color: Get.theme.hintColor),
                  ),
                ],
              ),
              value: "accept",
            ),
          );
        }
        if (_booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
          list.add(
            PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                  Text(
                    "Decline".tr,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
              value: "decline",
            ),
          );
        }
        return list;
      },
      child: Icon(
        Icons.more_vert,
        color: Get.theme.hintColor,
      ),
    );
  }
}
