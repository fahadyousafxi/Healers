import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/select_dialog.dart';

class OptionsFormController extends GetxController {
  final eService = EService().obs;
  final option = Option().obs;
  final optionGroups = <OptionGroup>[].obs;
  GlobalKey<FormState> optionForm = new GlobalKey<FormState>();
  EServiceRepository _eServiceRepository;

  OptionsFormController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    _initEService(arguments);
    _initOption(arguments: arguments);
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshOptions();
    super.onReady();
  }

  void _initEService(Map<String, dynamic> arguments) {
    if (arguments != null) {
      eService.value = arguments['eService'] as EService;
    }
  }

  void _initOption({Map<String, dynamic> arguments}) {
    if (arguments != null) {
      option.value = (arguments['option'] as Option) ?? Option();
    } else {
      option.value = new Option();
    }
    option.value.eServiceId = eService.value.id;
  }

  void _initOptionGroup() {
    option.update((val) {
      val.optionGroupId = optionGroups
          .firstWhere(
            (element) => element.id == option.value.optionGroupId,
            orElse: () => optionGroups.isNotEmpty ? optionGroups.first : new OptionGroup(),
          )
          .id;
    });
  }

  Future refreshOptions({bool showMessage = false}) async {
    await getOptionGroups();
    _initOptionGroup();
  }

  List<SelectDialogItem<OptionGroup>> getSelectOptionGroupsItems() {
    return optionGroups.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  Future getOptionGroups() async {
    try {
      var _optionGroups = await _eServiceRepository.getAllOptionGroups();
      optionGroups.assignAll(_optionGroups);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !option.value.hasData;
  }

  void createOptionForm({bool addOther = false}) async {
    Get.focusScope.unfocus();
    if (optionForm.currentState.validate()) {
      try {
        optionForm.currentState.save();
        await _eServiceRepository.createOption(option.value);
        if (addOther) {
          _resetOptionForm();
        } else {
          await Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': eService.value, 'heroTag': 'option_create_form'});
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void _resetOptionForm() {
    _initOption();

    _initOptionGroup();
    Get.find<ImageFieldController>(tag: optionForm.hashCode.toString()).reset();
    optionForm.currentState.reset();
  }

  void updateOptionForm() async {
    Get.focusScope.unfocus();
    if (optionForm.currentState.validate()) {
      try {
        optionForm.currentState.save();
        await _eServiceRepository.updateOption(option.value);
        Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': eService.value, 'heroTag': 'option_update_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteOption(Option option) async {
    try {
      await _eServiceRepository.deleteOption(option.id);
      Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': eService.value, 'heroTag': 'option_remove_form'});
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
