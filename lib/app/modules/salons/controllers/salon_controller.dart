/*
 * File name: salon_controller.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/award_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/experience_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/review_model.dart';
import '../../../models/salon_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/salon_repository.dart';
import '../../../routes/app_routes.dart';

class SalonController extends GetxController {
  final salon = Salon().obs;
  final reviews = <Review>[].obs;
  final awards = <Award>[].obs;
  final galleries = <Media>[].obs;
  final experiences = <Experience>[].obs;
  final featuredEServices = <EService>[].obs;
  final currentSlide = 0.obs;
  String heroTag = "";
  SalonRepository _salonRepository;

  SalonController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    salon.value = arguments['salon'] as Salon;
    heroTag = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshSalon();
    super.onReady();
  }

  Future refreshSalon({bool showMessage = false}) async {
    await getSalon();
    await getFeaturedEServices();
    await getAwards();
    await getExperiences();
    await getGalleries();
    await getReviews();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getSalon() async {
    try {
      salon.value = await _salonRepository.get(salon.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeaturedEServices() async {
    try {
      featuredEServices.assignAll(await _salonRepository.getFeaturedEServices(salonId: salon.value.id, page: 1));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _salonRepository.getReviews());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAwards() async {
    try {
      awards.assignAll(await _salonRepository.getAwards(salon.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getExperiences() async {
    try {
      experiences.assignAll(await _salonRepository.getExperiences(salon.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getGalleries() async {
    try {
      final _galleries = await _salonRepository.getGalleries(salon.value.id);
      galleries.assignAll(_galleries.map((e) {
        e.image.name = e.description;
        return e.image;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void startChat() {
    List<User> _employees = salon.value.employees.map((e) {
      e.avatar = salon.value.images[0];
      return e;
    }).toList();
    Message _message = new Message(_employees, name: salon.value.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
