/*
 * File name: salon_addresses_form_controller.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/salon_repository.dart';
import '../../global_widgets/multi_select_dialog.dart';

class SalonAddressesFormController extends GetxController {
  final addresses = <Address>[].obs;
  final salon = Salon().obs;
  GlobalKey<FormState> salonAddressesForm = new GlobalKey<FormState>();
  SalonRepository _salonRepository;

  SalonAddressesFormController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      salon.value = arguments['salon'] as Salon;
    }
    // salon.value.addresses = salon.value.addresses ?? <Address>[];
    // addresses.assignAll(salon.value.addresses);
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshSalon();
    super.onReady();
  }

  Future refreshSalon({bool showMessage = false}) async {
    await getSalon();
    await getAddresses();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getSalon() async {
    if (salon.value.hasData) {
      try {
        salon.value = await _salonRepository.get(salon.value.id);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  Future getAddresses() async {
    try {
      addresses.assignAll(await _salonRepository.getAddresses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> createAddress(Address address) async {
    try {
      address = await _salonRepository.createAddress(address);
      addresses.insert(0, address);
      toggleAddress(true, address);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> updateAddress(Address address) async {
    try {
      address = await _salonRepository.updateAddress(address);
      addresses[addresses.indexWhere((element) => element.id == address.id)] = address;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> deleteAddress(Address address) async {
    try {
      address = await _salonRepository.deleteAddress(address);
      addresses.removeWhere((element) => element.id == address.id);
      toggleAddress(false, address);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void toggleAddress(bool value, Address address) {
    salon.update((val) {
      val.address = address;
    });
  }

  List<MultiSelectDialogItem<Address>> getMultiSelectAddressesItems() {
    return addresses.map((element) {
      return MultiSelectDialogItem(element, element.getDescription);
    }).toList();
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !salon.value.hasData;
  }
}
