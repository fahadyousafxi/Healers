/*
 * File name: booking_view.dart
 * Last modified: 2022.12.12
 * Author: Ditlou tsa Molongoana
 * App Name: The sixth sense
 * Copyright (c) 2022
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/booking_address_chip_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/booking_controller.dart';
import '../widgets/booking_actions_widget.dart';
import '../widgets/booking_at_salon_actions_widget.dart';
import '../widgets/booking_row_widget.dart';
import '../widgets/booking_til_widget.dart';
import '../widgets/booking_title_bar_loader_widget.dart';
import '../widgets/booking_title_bar_widget.dart';
import '../widgets/payment_details_widget.dart';

class BookingView extends GetView<BookingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: (controller.booking.value?.atSalon ?? false) ? BookingAtSalonActionsWidget() : BookingActionsWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshBooking(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 390,
                elevation: 0,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () {
                    Get.find<HomeController>().refreshHome();
                    Get.back();
                  },
                ),
                actions: [
                  Obx(() {
                    if (controller.booking.value.address == null)
                      return SizedBox();
                    else
                      return MaterialButton(
                        elevation: 0,
                        onPressed: () => MapsUtil.openMapsSheet(context, controller.booking.value.address?.getLatLng(), controller.booking.value.id),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.colorScheme.secondary,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Icon(Icons.map_outlined, color: Get.theme.primaryColor),
                            Text("On Maps".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                          ],
                        ),
                      );
                  }).paddingSymmetric(horizontal: 20, vertical: 8),
                ],
                bottom: buildBookingTitleBarWidget(controller.booking),
                flexibleSpace: Obx(() {
                  if (controller.booking.value.address == null)
                    return SizedBox();
                  else
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: MapsUtil.getStaticMaps([controller.booking.value.address.getLatLng()], height: 600, size: '700x600', zoom: 14),
                    );
                }).marginOnly(bottom: 80),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      return buildContactCustomer(controller.booking.value);
                    }),
                    Obx(() {
                      if (controller.booking.value.status == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Booking Details".tr, style: Get.textTheme.subtitle2),
                          actions: [Text("#" + controller.booking.value.id, style: Get.textTheme.subtitle2)],
                          content: Column(
                            children: [
                              BookingRowWidget(
                                  descriptionFlex: 1,
                                  valueFlex: 2,
                                  description: "Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.booking.value.status.status,
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              BookingRowWidget(
                                  description: "Payment Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.booking.value.payment?.paymentStatus?.status ?? "Not Paid".tr,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              if (controller.booking.value.payment?.paymentMethod != null)
                                BookingRowWidget(
                                    description: "Payment Method".tr,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: Get.theme.focusColor.withOpacity(0.1),
                                          ),
                                          child: Text(
                                            controller.booking.value.payment?.paymentMethod?.getName(),
                                            style: TextStyle(color: Get.theme.hintColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    hasDivider: true),
                              BookingRowWidget(
                                description: "Hint".tr,
                                child: Ui.removeHtml(controller.booking.value.hint, alignment: Alignment.centerRight, textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        );
                    }),
                    Obx(() {
                      if (controller.booking.value.duration == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Booking Date & Time".tr, style: Get.textTheme.subtitle2),
                          actions: [
                            Container(
                              padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Get.theme.focusColor.withOpacity(0.1),
                              ),
                              child: Obx(() {
                                return Text(
                                  controller.getTime(),
                                  style: Get.textTheme.bodyText2,
                                );
                              }),
                            )
                          ],
                          content: Obx(() {
                            return Column(
                              children: [
                                if (controller.booking.value.bookingAt != null)
                                  BookingRowWidget(
                                      description: "Booking At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.booking.value.bookingAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider: controller.booking.value.startAt != null || controller.booking.value.endsAt != null),
                                if (controller.booking.value.startAt != null)
                                  BookingRowWidget(
                                      description: "Started At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.booking.value.startAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider: false),
                                if (controller.booking.value.endsAt != null)
                                  BookingRowWidget(
                                    description: "Ended At".tr,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.booking.value.endsAt),
                                          style: Get.textTheme.caption,
                                          textAlign: TextAlign.end,
                                        )),
                                  ),
                              ],
                            );
                          }),
                        );
                    }),
                    Obx(() {
                      if (controller.booking.value.salon == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Pricing".tr, style: Get.textTheme.subtitle2),
                          content: PaymentDetailsWidget(booking: controller.booking.value),
                        );
                    })
                  ],
                ),
              ),
            ],
          )),
    );
  }

  BookingTitleBarWidget buildBookingTitleBarWidget(Rx<Booking> _booking) {
    return BookingTitleBarWidget(
      title: Obx(() {
        if (_booking.value.salon == null || _booking.value.address == null || _booking.value.atSalon == null) {
          return BookingTitleBarLoaderWidget();
        }
        return Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeText(
                    _booking.value.salon.name ?? '',
                    style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 5),
                  if (_booking.value.employee != null)
                    Row(
                      children: [
                        Icon(Icons.badge_outlined, color: Get.theme.focusColor),
                        SizedBox(width: 8),
                        Text(
                          _booking.value.employee.name,
                          style: Get.textTheme.bodyText1,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: Get.theme.focusColor,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: BookingAddressChipWidget(booking: _booking.value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_booking.value.bookingAt == null)
              Container(
                height: double.infinity,
                width: 80,
                child: SizedBox.shrink(),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
            if (_booking.value.bookingAt != null)
              Container(
                height: 120,
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('HH:mm', Get.locale.toString()).format(_booking.value.bookingAt),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(DateFormat('dd', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.headline3.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(DateFormat('MMM', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
          ],
        );
      }),
    );
  }

  Container buildContactCustomer(Booking _booking) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Customer".tr, style: Get.textTheme.subtitle2),
                SizedBox(height: 10),
                Text(_booking.user?.name ?? '', style: Get.textTheme.bodyText1),
                Text(_booking.user?.phoneNumber ?? '', style: Get.textTheme.caption),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                onPressed: () {
                  launchUrlString("tel:${_booking.user?.phoneNumber ?? ''}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: Get.theme.colorScheme.secondary,
                ),
                elevation: 0,
              ),
              MaterialButton(
                onPressed: () {
                  controller.startChat();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                padding: EdgeInsets.zero,
                height: 44,
                minWidth: 44,
                child: Icon(
                  Icons.chat_outlined,
                  color: Get.theme.colorScheme.secondary,
                ),
                elevation: 0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
