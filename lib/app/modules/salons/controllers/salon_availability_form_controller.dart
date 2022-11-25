/*
 * File name: salon_availability_form_controller.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/availability_hour_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/salon_repository.dart';
import '../../global_widgets/select_dialog.dart';

class SalonAvailabilityFormController extends GetxController {
  final days = <String>[].obs;
  final salon = Salon().obs;
  final availabilityHour = AvailabilityHour().obs;
  GlobalKey<FormState> salonAvailabilityForm = new GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  SalonRepository _salonRepository;

  SalonAvailabilityFormController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      salon.value = arguments['salon'] as Salon;
    }
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshSalon();
    super.onReady();
  }

  @override
  void onClose() {
    days.value = [];
    availabilityHour.value = AvailabilityHour();
    salon.value = Salon();
    super.onClose();
  }

  Future refreshSalon({bool showMessage = false}) async {
    await getSalon();
    getDays();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getSalon() async {
    if (salon.value.hasData) {
      try {
        salon.value = await _salonRepository.get(salon.value.id);
        availabilityHour.value.salon = salon.value;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  getDays() {
    days.assignAll([
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday",
    ]);
  }

  void createAvailabilityHour() async {
    Get.focusScope.unfocus();
    if (salonAvailabilityForm.currentState.validate()) {
      try {
        salonAvailabilityForm.currentState.save();
        scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        final _availabilityHour = await _salonRepository.createAvailabilityHour(this.availabilityHour.value);
        salon.update((val) {
          val.availabilityHours.insert(0, _availabilityHour);
          return val;
        });
        availabilityHour.value = AvailabilityHour(salon: availabilityHour.value.salon);
        salonAvailabilityForm.currentState.reset();
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

/*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !salon.value.hasData;
  }

  Future<void> deleteAvailabilityHour(AvailabilityHour availabilityHour) async {
    try {
      availabilityHour = await _salonRepository.deleteAvailabilityHour(availabilityHour);
      salon.update((val) {
        val.availabilityHours.removeWhere((element) => element.id == availabilityHour.id);
        return val;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SelectDialogItem<String>> getSelectDaysItems() {
    return days.map((element) {
      return SelectDialogItem(element, element.tr);
    }).toList();
  }
}
