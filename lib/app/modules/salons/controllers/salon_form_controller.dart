/*
 * File name: salon_form_controller.dart
 * Last modified: 2022.10.16 at 12:23:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/salon_level_model.dart';
import '../../../models/salon_model.dart';
import '../../../models/tax_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/salon_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';

class SalonFormController extends GetxController {
  final salon = Salon().obs;
  final optionGroups = <OptionGroup>[].obs;
  final categories = <Category>[].obs;
  final salons = <Salon>[].obs;
  final employees = <User>[].obs;
  final taxes = <Tax>[].obs;
  final salonLevels = <SalonLevel>[].obs;
  GlobalKey<FormState> salonForm = new GlobalKey<FormState>();
  SalonRepository _salonRepository;
  CategoryRepository _categoryRepository;

  SalonFormController() {
    _salonRepository = new SalonRepository();
    _categoryRepository = new CategoryRepository();
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

  Future refreshSalon({bool showMessage = false}) async {
    await getSalonLevels();
    await getEmployees();
    await getTaxes();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getSalonLevels() async {
    try {
      salonLevels.assignAll(await _salonRepository.getSalonLevels());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEmployees() async {
    try {
      employees.assignAll(await _salonRepository.getAllEmployees());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getTaxes() async {
    try {
      taxes.assignAll(await _salonRepository.getTaxes());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getSalons() async {
    try {
      salons.assignAll(await _salonRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<MultiSelectDialogItem<User>> getMultiSelectEmployeesItems() {
    return employees.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  List<MultiSelectDialogItem<Tax>> getMultiSelectTaxesItems() {
    return taxes.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<SalonLevel>> getSelectSalonLevelsItems() {
    return salonLevels.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !salon.value.hasData;
  }

  void createSalonForm() async {
    Get.focusScope.unfocus();
    if (salonForm.currentState.validate()) {
      try {
        salonForm.currentState.save();
        final _salon = await _salonRepository.create(salon.value);
        salon.value.id = _salon.id;
        await Get.toNamed(Routes.SALON_AVAILABILITY_FORM, arguments: {'salon': _salon});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateSalonForm() async {
    Get.focusScope.unfocus();
    if (salonForm.currentState.validate()) {
      try {
        salonForm.currentState.save();
        final _salon = await _salonRepository.update(salon.value);
        await Get.toNamed(Routes.SALON_AVAILABILITY_FORM, arguments: {'salon': _salon});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> deleteSalon() async {
    try {
      await _salonRepository.delete(salon.value);
      Get.offNamedUntil(Routes.SALONS, (route) => route.settings.name == Routes.SALONS);
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
