import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/salon_model.dart';

class SalonAvailabilityBadgeWidget extends StatelessWidget {
  const SalonAvailabilityBadgeWidget({
    Key key,
    @required Salon salon,
    bool withImage = false,
  })  : _salon = salon,
        _withImage = withImage,
        super(key: key);

  final Salon _salon;
  final bool _withImage;

  @override
  Widget build(BuildContext context) {
    if (_salon?.closed ?? true)
      return Container(
        width: _withImage ? 80 : null,
        child: Text("Closed".tr,
            maxLines: 1,
            style: Get.textTheme.bodyText2.merge(
              TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
            ),
            softWrap: false,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: _withImage ? BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)) : BorderRadius.circular(8),
        ),
        padding: _withImage ? EdgeInsets.symmetric(horizontal: 5, vertical: 6) : EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      );
    return Container(
      width: _withImage ? 80 : null,
      child: Text("Open".tr,
          maxLines: 1,
          style: Get.textTheme.bodyText2.merge(
            TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
          ),
          softWrap: false,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: _withImage ? BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)) : BorderRadius.circular(8),
      ),
      padding: _withImage ? EdgeInsets.symmetric(horizontal: 5, vertical: 6) : EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
