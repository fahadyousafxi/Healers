import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/review_model.dart';
import '../../../repositories/salon_repository.dart';

class ReviewsController extends GetxController {
  final reviews = <Review>[].obs;
  final totalReviews = 0.obs;
  final rate = 0.0.obs;
  SalonRepository _salonRepository;

  ReviewsController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshReviews();
    super.onReady();
  }

  Future refreshReviews({bool showMessage = false}) async {
    await getReviews();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Reviews refreshed successfully".tr));
    }
  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _salonRepository.getReviews());
      totalReviews.value = reviews.length;
      rate.value = reviews.map((element) => element.rate).reduce((value, element) => value + element) / reviews.length;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
