import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/payment_status_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../../../repositories/salon_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../home/controllers/home_controller.dart';

class BookingController extends GetxController {
  BookingRepository _bookingRepository;
  SalonRepository _salonRepository;
  PaymentRepository _paymentRepository;
  final allMarkers = <Marker>[].obs;
  final bookingStatuses = <BookingStatus>[].obs;
  Timer timer;
  GoogleMapController mapController;
  final booking = Booking().obs;

  BookingController() {
    _bookingRepository = BookingRepository();
    _salonRepository = SalonRepository();
    _paymentRepository = PaymentRepository();
  }

  @override
  void onInit() async {
    booking.value = Get.arguments as Booking;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshBooking();
    super.onReady();
  }

  Future refreshBooking({bool showMessage = false}) async {
    await getBooking();
    initBookingAddress();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking page refreshed successfully".tr));
    }
  }

  Future<void> getBooking() async {
    try {
      booking.value = await _bookingRepository.get(booking.value.id);
      if (booking.value.status == Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.inProgress) && timer == null) {
        timer = Timer.periodic(Duration(minutes: 1), (t) {
          booking.update((val) {
            val.duration += (1 / 60);
          });
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> changeBookingStatus(BookingStatus bookingStatus) async {
    try {
      final _booking = new Booking(id: booking.value.id, status: bookingStatus);
      await _bookingRepository.update(_booking);
      booking.update((val) {
        val.status = bookingStatus;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> acceptBookingService() async {
    if (booking.value.status.order == Get.find<GlobalService>().global.value.received) {
      final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.accepted);
      await changeBookingStatus(_status);
    }
  }

  Future<void> onTheWayBookingService() async {
    final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.onTheWay);
    await changeBookingStatus(_status);
  }

  Future<void> readyBookingService() async {
    final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.ready);
    await changeBookingStatus(_status);
  }

  Future<void> confirmPaymentBookingService() async {
    try {
      final _payment = new Payment(id: booking.value.payment.id, paymentStatus: PaymentStatus(id: '2')); //Paid
      final result = await _paymentRepository.update(_payment);
      booking.update((val) {
        val.payment = result;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> declineBookingService() async {
    try {
      if (booking.value.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking = new Booking(id: booking.value.id, cancel: true, status: _status);
        await _bookingRepository.update(_booking);
        booking.update((val) {
          val.cancel = true;
          val.status = _status;
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> startBookingService() async {
    try {
      final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.inProgress);
      final _booking = new Booking(id: booking.value.id, startAt: DateTime.now(), status: _status);
      await _bookingRepository.update(_booking);
      booking.update((val) {
        val.startAt = _booking.startAt;
        val.status = _status;
      });
      timer = Timer.periodic(Duration(minutes: 1), (t) {
        booking.update((val) {
          val.duration += (1 / 60);
        });
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> finishBookingService() async {
    try {
      final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.done);
      var _booking = new Booking(id: booking.value.id, endsAt: DateTime.now(), status: _status);
      final result = await _bookingRepository.update(_booking);
      booking.update((val) {
        val.endsAt = result.endsAt;
        val.duration = result.duration;
        val.status = _status;
      });
      timer?.cancel();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initBookingAddress() {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: booking.value.address.getLatLng(), zoom: 12.4746),
      ),
    );
    MapsUtil.getMarker(address: booking.value.address, id: booking.value.id, description: booking.value.user?.name ?? '').then((marker) {
      allMarkers.add(marker);
    });
  }

  String getTime({String separator = ":"}) {
    String hours = "";
    String minutes = "";
    int minutesInt = ((booking.value.duration - booking.value.duration.toInt()) * 60).toInt();
    int hoursInt = booking.value.duration.toInt();
    if (hoursInt < 10) {
      hours = "0" + hoursInt.toString();
    } else {
      hours = hoursInt.toString();
    }
    if (minutesInt < 10) {
      minutes = "0" + minutesInt.toString();
    } else {
      minutes = minutesInt.toString();
    }
    return hours + separator + minutes;
  }

  Future<void> startChat() async {
    List<User> _employees = await _salonRepository.getEmployees(booking.value.salon.id);
    _employees = _employees
        .map((e) {
          if (booking.value.salon.images.isNotEmpty) {
            e.avatar = booking.value.salon.images[0];
          } else {
            e.avatar = new Media();
          }
          return e;
        })
        .toSet()
        .toList();
    _employees.insert(0, booking.value.user);
    Message _message = new Message(_employees, name: booking.value.salon.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
