/*
 * File name: salon_form_view.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../models/media_model.dart';
import '../../../models/salon_level_model.dart';
import '../../../models/salon_model.dart';
import '../../../models/tax_model.dart';
import '../../../models/user_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/confirm_dialog.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/salon_form_controller.dart';
import '../widgets/horizontal_stepper_widget.dart';
import '../widgets/step_widget.dart';

class SalonFormView extends GetView<SalonFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              controller.isCreateForm() ? "New Salon".tr : controller.salon.value.name ?? '',
              style: context.textTheme.headline6,
            );
          }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
          actions: [
            if (!controller.isCreateForm())
              new IconButton(
                padding: EdgeInsets.symmetric(horizontal: 20),
                icon: new Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 28,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialog(
                        title: "Delete Salon".tr,
                        content: "Are you sure you want to delete this salon?".tr,
                        submitText: "Confirm".tr,
                        cancelText: "Cancel".tr,
                      );
                    },
                  );
                  if (confirm) {
                    await controller.deleteSalon();
                  }
                },
              ),
          ],
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
              Obx(() {
                return Expanded(
                  child: MaterialButton(
                    onPressed: controller.salon.value.address.isUnknown()
                        ? null
                        : () {
                            if (controller.isCreateForm()) {
                              controller.createSalonForm();
                            } else {
                              controller.updateSalonForm();
                            }
                          },
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Get.theme.colorScheme.secondary,
                    disabledElevation: 0,
                    disabledColor: Get.theme.focusColor,
                    child: Text("Save & Next".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                    elevation: 0,
                  ),
                );
              }),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.salonForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalStepperWidget(
                  controller: new ScrollController(initialScrollOffset: 50),
                  steps: [
                    StepWidget(
                      title: Text(
                        "Addresses".tr,
                      ),
                      color: Get.theme.focusColor,
                      index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                    StepWidget(
                      title: Text(
                        "Salon Details".tr,
                      ),
                      index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                    StepWidget(
                      title: Text(
                        "Availability".tr,
                      ),
                      color: Get.theme.focusColor,
                      index: Text("3", style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ],
                ),
                Text("Salon details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Fill the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return ImagesFieldWidget(
                    label: "Images".tr,
                    field: 'image',
                    tag: controller.salonForm.hashCode.toString(),
                    initialImages: controller.salon.value.images,
                    uploadCompleted: (uuid) {
                      controller.salon.update((val) {
                        val.images = val.images ?? [];
                        val.images.add(new Media(id: uuid));
                      });
                    },
                    reset: (uuids) {
                      controller.salon.update((val) {
                        val.images.clear();
                      });
                    },
                  );
                }),
                TextFieldWidget(
                  onSaved: (input) => controller.salon.value.name = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  initialValue: controller.salon.value.name,
                  hintText: "Architect Mayer Group".tr,
                  labelText: "Name".tr,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.salon.value.description = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  keyboardType: TextInputType.multiline,
                  initialValue: controller.salon.value.description,
                  hintText: "Description for Architect Mayer Group".tr,
                  labelText: "Description".tr,
                ),
                PhoneFieldWidget(
                  labelText: "Phone Number".tr,
                  hintText: "223 665 7896".tr,
                  initialCountryCode: Helper.getPhoneNumber(controller.salon.value.phoneNumber)?.countryISOCode,
                  initialValue: Helper.getPhoneNumber(controller.salon.value.phoneNumber)?.number,
                  onSaved: (phone) {
                    return controller.salon.value.phoneNumber = phone.completeNumber;
                  },
                ),
                PhoneFieldWidget(
                  labelText: "Mobile Number".tr,
                  hintText: "223 665 7896".tr,
                  initialCountryCode: Helper.getPhoneNumber(controller.salon.value.mobileNumber)?.countryISOCode,
                  initialValue: Helper.getPhoneNumber(controller.salon.value.mobileNumber)?.number,
                  onSaved: (phone) {
                    return controller.salon.value.mobileNumber = phone.completeNumber;
                  },
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.salon.value.availabilityRange = double.tryParse(input) ?? 0,
                  validator: (input) => (double.tryParse(input) ?? 0) <= 0 ? "Should be more than 0".tr : null,
                  initialValue: controller.salon.value.availabilityRange?.toString() ?? null,
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                  hintText: "5".tr,
                  labelText: "Availability Range".tr,
                  suffix: Text(Get.find<SettingsService>().setting.value.distanceUnit.tr),
                ),
                Obx(() {
                  if (controller.salonLevels.isEmpty)
                    return SizedBox();
                  else
                    return Container(
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
                                  "Salon Levels".tr,
                                  style: Get.textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  final selectedValue = await showDialog<SalonLevel>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SelectDialog(
                                        title: "Select Salon Level".tr,
                                        submitText: "Submit".tr,
                                        cancelText: "Cancel".tr,
                                        items: controller.getSelectSalonLevelsItems(),
                                        initialSelectedValue: controller.salonLevels.firstWhere(
                                          (element) => element.id == controller.salon.value.salonLevel?.id,
                                          orElse: () => new SalonLevel(),
                                        ),
                                      );
                                    },
                                  );
                                  controller.salon.update((val) {
                                    val.salonLevel = selectedValue;
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
                            if (controller.salon.value?.salonLevel == null) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Select salons".tr,
                                  style: Get.textTheme.caption,
                                ),
                              );
                            } else {
                              return buildSalonLevel(controller.salon.value);
                            }
                          })
                        ],
                      ),
                    );
                }),
                if (!controller.isCreateForm())
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
                                "Employees".tr,
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                final selectedValues = await showDialog<Set<User>>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MultiSelectDialog(
                                      title: "Select Employees".tr,
                                      submitText: "Submit".tr,
                                      cancelText: "Cancel".tr,
                                      items: controller.getMultiSelectEmployeesItems(),
                                      initialSelectedValues: controller.employees
                                          .where(
                                            (user) => controller.salon.value.employees?.where((element) => element.id == user.id)?.isNotEmpty ?? false,
                                          )
                                          .toSet(),
                                    );
                                  },
                                );
                                controller.salon.update((val) {
                                  val.employees = selectedValues?.toList();
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
                          if (controller.salon.value?.employees?.isEmpty ?? true) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Select Employees".tr,
                                style: Get.textTheme.caption,
                              ),
                            );
                          } else {
                            return buildEmployees(controller.salon.value);
                          }
                        })
                      ],
                    ),
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
                              "Taxes".tr,
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              final selectedValues = await showDialog<Set<Tax>>(
                                context: context,
                                builder: (BuildContext context) {
                                  return MultiSelectDialog(
                                    title: "Select Taxes".tr,
                                    submitText: "Submit".tr,
                                    cancelText: "Cancel".tr,
                                    items: controller.getMultiSelectTaxesItems(),
                                    initialSelectedValues: controller.taxes
                                        .where(
                                          (tax) => controller.salon.value.taxes?.where((element) => element.id == tax.id)?.isNotEmpty ?? false,
                                        )
                                        .toSet(),
                                  );
                                },
                              );
                              controller.salon.update((val) {
                                val.taxes = selectedValues?.toList();
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
                        if (controller.salon.value?.taxes?.isEmpty ?? true) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Select Taxes".tr,
                              style: Get.textTheme.caption,
                            ),
                          );
                        } else {
                          return buildTaxes(controller.salon.value);
                        }
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildEmployees(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          runSpacing: 8,
          children: List.generate(_salon.employees?.length ?? 0, (index) {
            final _user = _salon.employees.elementAt(index);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(_user.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  border: Border.all(
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            );
          })),
    );
  }

  Widget buildTaxes(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          runSpacing: 8,
          children: List.generate(_salon.taxes?.length ?? 0, (index) {
            final tax = _salon.taxes.elementAt(index);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(tax.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  border: Border.all(
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            );
          })),
    );
  }

  Widget buildSalonLevel(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_salon.salonLevel?.name ?? '', style: Get.textTheme.bodyText2),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
