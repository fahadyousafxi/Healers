import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/e_services_controller.dart';

class EServiceOptionsPopupMenuWidget extends GetView<EServicesController> {
  const EServiceOptionsPopupMenuWidget({
    Key key,
    @required EService eService,
  })  : _eService = eService,
        super(key: key);

  final EService _eService;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (item) {
        switch (item) {
          case "update":
            {
              Get.toNamed(Routes.E_SERVICE_FORM, arguments: {'eService': _eService});
            }
            break;
          case "delete":
            {
              _showDeleteDialog(context);
            }
            break;
          case "view":
            {
              Get.toNamed(Routes.E_SERVICE, arguments: {'eService': _eService, 'heroTag': 'salon_services_list_item'});
            }
            break;
        }
      },
      itemBuilder: (context) {
        var list = <PopupMenuEntry<Object>>[];
        list.add(
          PopupMenuItem(
            value: "view",
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.water_damage_outlined, color: Get.theme.hintColor),
                SizedBox(width: 10),
                Text(
                  "Service Details".tr,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
          ),
        );
        list.add(PopupMenuDivider(height: 10));
        list.add(
          PopupMenuItem(
            value: "update",
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.edit_outlined, color: Get.theme.hintColor),
                SizedBox(width: 10),
                Text(
                  "Edit Service".tr,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
          ),
        );
        list.add(
          PopupMenuItem(
            value: "delete",
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline, color: Colors.redAccent),
                SizedBox(width: 10),
                Text(
                  "Delete Service".tr,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
        );
        return list;
      },
      child: Icon(
        Icons.more_vert,
        color: Get.theme.hintColor,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Service".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This service will removed from your account".tr, style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                controller.deleteEService(_eService);
              },
            ),
          ],
        );
      },
    );
  }
}
