import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/review_model.dart';
import '../../../repositories/salon_repository.dart';

class ReviewController extends GetxController {
  final review = Review().obs;
  SalonRepository _salonRepository;

  ReviewController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() {
    review.value = Get.arguments as Review;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshReview();
    super.onReady();
  }

  Future refreshReview({bool showMessage = false}) async {
    await getReview();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Reviews refreshed successfully".tr));
    }
  }

  Future getReview() async {
    try {
      review.value = await _salonRepository.getReview(review.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
