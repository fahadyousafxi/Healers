/*
 * File name: salon_e_services_controller.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/salon_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, FEATURED, POPULAR }

class SalonEServicesController extends GetxController {
  final salon = new Salon().obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final eServices = <EService>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  SalonRepository _salonRepository;
  ScrollController scrollController = ScrollController();

  SalonEServicesController() {
    _salonRepository = new SalonRepository();
  }

  @override
  Future<void> onInit() async {
    salon.value = Get.arguments as Salon;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadEServicesOfCategory(filter: selected.value);
      }
    });
    await refreshEServices();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    toggleSelected(selected.value);
    await loadEServicesOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadEServicesOfCategory({CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _salonRepository.getEServices(salonId: salon.value.id, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _salonRepository.getFeaturedEServices(salonId: salon.value.id, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _salonRepository.getPopularEServices(salonId: salon.value.id, page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _eServices = await _salonRepository.getAvailableEServices(salonId: salon.value.id, page: this.page.value);
          break;
        default:
          _eServices = await _salonRepository.getEServices(salonId: salon.value.id, page: this.page.value);
      }
      if (_eServices.isNotEmpty) {
        this.eServices.addAll(_eServices);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
