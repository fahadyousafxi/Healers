/*
 * File name: address_picker_view.dart
 * Last modified: 2022.12.12
 * Author: Ditlou tsa Molongoana
 * App Name: The sixth sense
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../../models/address_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/salon_addresses_form_controller.dart';

// ignore: must_be_immutable
class AddressPickerView extends GetView<SalonAddressesFormController> {
  AddressPickerView({
    Key key,
  }) {
    _address = Get.arguments['address'] as Address;
  }

  Address _address;

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: Get.find<SettingsService>().setting.value.googleMapsKey,
      initialPosition: _address?.getLatLng(),
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePlaceDetailSearch: true,
      forceSearchOnZoomChanged: true,
      selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
        if (isSearchBarFocused) {
          return SizedBox();
        }
        _address.address = selectedPlace?.formattedAddress ?? '';
        return FloatingCard(
          height: 300,
          elevation: 0,
          bottomPosition: 0.0,
          leftPosition: 0.0,
          rightPosition: 0.0,
          color: Colors.transparent,
          child: state == SearchingState.Searching
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      labelText: "Description".tr,
                      hintText: "My Home".tr,
                      initialValue: _address.description,
                      onChanged: (input) => _address.description = input,
                      iconData: Icons.description_outlined,
                      isFirst: true,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Full Address".tr,
                      hintText: "123 Street, City 136, State, Country".tr,
                      initialValue: _address.address,
                      onChanged: (input) => _address.address = input,
                      iconData: Icons.place_outlined,
                      isFirst: false,
                      isLast: true,
                    ),
                    BlockButtonWidget(
                      onPressed: () async {
                        _address.latitude = selectedPlace.geometry.location.lat;
                        _address.longitude = selectedPlace.geometry.location.lng;
                        if (_address.hasData) {
                          await controller.updateAddress(_address);
                        } else {
                          await controller.createAddress(_address);
                        }
                        Get.back();
                      },
                      color: Get.theme.colorScheme.secondary,
                      text: Text(
                        "Pick Here".tr,
                        style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    SizedBox(height: 10),
                  ],
                ),
        );
      },
    );
  }
}
