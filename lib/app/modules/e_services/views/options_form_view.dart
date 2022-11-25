import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/media_model.dart';
import '../../../models/option_group_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/options_form_controller.dart';
import '../widgets/horizontal_stepper_widget.dart';
import '../widgets/step_widget.dart';

class OptionsFormView extends GetView<OptionsFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              controller.isCreateForm() ? controller.eService.value.name ?? '' : controller.option.value.name ?? '',
              style: context.textTheme.headline6,
            );
          }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': controller.eService.value, 'heroTag': 'option_form_back'}),
          ),
          actions: [
            new IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: new Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 28,
              ),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
          elevation: 0,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    if (controller.isCreateForm()) {
                      controller.createOptionForm();
                    } else {
                      controller.updateOptionForm();
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                ),
              ),
              if (controller.isCreateForm()) SizedBox(width: 10),
              if (controller.isCreateForm())
                MaterialButton(
                  onPressed: () {
                    controller.createOptionForm(addOther: true);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  child: Text("Save & Add Other".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.optionForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.isCreateForm())
                  HorizontalStepperWidget(
                    steps: [
                      StepWidget(
                        title: Text(
                          ("Service details".tr).substring(0, min("Service details".tr.length, 15)),
                        ),
                        color: Get.theme.focusColor,
                        index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                      StepWidget(
                        title: Text(
                          ("Options details".tr).substring(0, min("Options details".tr.length, 15)),
                        ),
                        index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                    ],
                  ),
                Text("Options".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Fill the following details to add option to this service".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return ImageFieldWidget(
                    label: "Image".tr,
                    field: 'image',
                    tag: controller.optionForm.hashCode.toString(),
                    initialImage: controller.option.value.image,
                    uploadCompleted: (uuid) {
                      controller.option.update((val) {
                        val.image = new Media(id: uuid);
                      });
                    },
                    reset: (uuid) {
                      controller.option.update((val) {
                        val.image = null;
                      });
                    },
                  );
                }),
                TextFieldWidget(
                  onSaved: (input) => controller.option.value.name = input,
                  validator: (input) => input.length < 1 ? "Field is required".tr : null,
                  initialValue: controller.option.value.name,
                  hintText: "Large Size".tr,
                  labelText: "Name".tr,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.option.value.description = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  keyboardType: TextInputType.multiline,
                  initialValue: controller.option.value.description,
                  hintText: "Description for option".tr,
                  labelText: "Description".tr,
                ),
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Option Group".tr,
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              final selectedValue = await showDialog<OptionGroup>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SelectDialog(
                                    title: "Select Option Group".tr,
                                    submitText: "Submit".tr,
                                    cancelText: "Cancel".tr,
                                    items: controller.getSelectOptionGroupsItems(),
                                    initialSelectedValue: controller.optionGroups.firstWhere(
                                      (element) => element.id == controller.option.value.optionGroupId,
                                      orElse: () => controller.optionGroups.isNotEmpty ? controller.optionGroups.first : new OptionGroup(),
                                    ),
                                  );
                                },
                              );
                              controller.option.update((val) {
                                val.optionGroupId = selectedValue.id;
                              });
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            child: Text("Select".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                          ),
                        ],
                      ),
                      Obx(() {
                        OptionGroup selectedOptionGroup = controller.optionGroups.firstWhere(
                          (element) => element.id == controller.option.value.optionGroupId,
                          orElse: () => controller.optionGroups.isNotEmpty ? controller.optionGroups.first : new OptionGroup(),
                        );
                        print(selectedOptionGroup);
                        return buildOptionGroup(selectedOptionGroup.name);
                      })
                    ],
                  ),
                ),
                TextFieldWidget(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (input) => controller.option.value.price = (double.tryParse(input) ?? 0),
                  validator: (input) => (double.tryParse(input) ?? 0) <= 0 ? "Should be number more than 0".tr : null,
                  initialValue: controller.option.value.price?.toString(),
                  hintText: "23.00".tr,
                  labelText: "Price".tr,
                  suffix: Text(Get.find<SettingsService>().setting.value.defaultCurrency),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildOptionGroup(String _group) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_group ?? '', style: Get.textTheme.bodyText2),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Option".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This option will removed from the service".tr, style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                controller.deleteOption(controller.option.value);
              },
            ),
          ],
        );
      },
    );
  }
}
