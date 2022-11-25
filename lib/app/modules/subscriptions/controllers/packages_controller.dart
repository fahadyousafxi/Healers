/*
 * File name: packages_controller.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_model.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../models/subscription_package_model.dart';
import '../../../repositories/salon_repository.dart';
import '../../../repositories/subscription_repository.dart';
import '../../global_widgets/select_dialog.dart';

class PackagesController extends GetxController {
  final subscriptionPackages = <SubscriptionPackage>[].obs;
  final salonSubscription = SalonSubscription().obs;
  final salons = <Salon>[].obs;
  SubscriptionRepository _subscriptionRepository;
  SalonRepository _salonRepository;

  PackagesController() {
    _subscriptionRepository = new SubscriptionRepository();
    _salonRepository = new SalonRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshSubscriptionPackages();
    super.onInit();
  }

  Future refreshSubscriptionPackages({bool showMessage}) async {
    await getSalons();
    await getSubscriptionPackages();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of packages refreshed successfully".tr));
    }
  }

  Future getSubscriptionPackages() async {
    try {
      subscriptionPackages.clear();
      subscriptionPackages.assignAll(await _subscriptionRepository.getSubscriptionPackages());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getSalons() async {
    try {
      salons.clear();
      salons.assignAll(await _salonRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SelectDialogItem<Salon>> getSelectSalonsItems() {
    return salons.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }
}
