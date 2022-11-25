/*
 * File name: salons_controller.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/salon_repository.dart';

enum SalonFilter { ALL, ACCEPTED, PENDING, FEATURED }

class SalonsController extends GetxController {
  final selected = Rx<SalonFilter>(SalonFilter.ALL);
  final salons = <Salon>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;

  SalonRepository _salonRepository;
  ScrollController scrollController = ScrollController();

  SalonsController() {
    _salonRepository = new SalonRepository();
  }

  @override
  Future<void> onInit() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadSalonsOfFilter(filter: selected.value);
      }
    });
    await refreshSalons();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshSalons({bool showMessage}) async {
    toggleSelected(selected.value);
    await loadSalonsOfFilter(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(SalonFilter filter) => selected == filter;

  void toggleSelected(SalonFilter filter) async {
    this.salons.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = SalonFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadSalonsOfFilter({SalonFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Salon> _salons = [];
      switch (filter) {
        case SalonFilter.ALL:
          _salons = await _salonRepository.getSalons(page: this.page.value);
          break;
        case SalonFilter.ACCEPTED:
          _salons = await _salonRepository.getAcceptedSalons(page: this.page.value);
          break;
        case SalonFilter.FEATURED:
          _salons = await _salonRepository.getFeaturedSalons(page: this.page.value);
          break;
        case SalonFilter.PENDING:
          _salons = await _salonRepository.getPendingSalons(page: this.page.value);
          break;
        default:
          _salons = await _salonRepository.getSalons(page: this.page.value);
      }
      if (_salons.isNotEmpty) {
        this.salons.addAll(_salons);
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

  void deleteSalon(Salon salon) async {
    try {
      await _salonRepository.delete(salon);
      salons.remove(salon);
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
