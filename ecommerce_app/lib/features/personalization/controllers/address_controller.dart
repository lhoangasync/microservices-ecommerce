import 'package:ecommerce_app/common/widgets/loaders/circular_loader.dart';
import 'package:ecommerce_app/data/repositories/address/address_repository.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/helpers/network_manager.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere(
        (e) => e.selectedAddress,
        orElse: () => AddressModel.empty(),
      );
      return addresses;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      Get.defaultDialog(
        title: '',
        onWillPop: () async {
          return false;
        },
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const TCircularLoader(),
      );
      // Clear the "selected" field
      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(
          selectedAddress.value.id,
          false,
        );
      }

      // assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(
        selectedAddress.value.id,
        true,
      );

      Get.back();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error in Selection!',
        message: e.toString(),
      );
      return [];
    }
  }

  Future addNewAddresses() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog(
        'Storing Address...',
        TImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // form validation
      if (!addressFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        country: country.text.trim(),
        selectedAddress: true,
      );

      final id = await addressRepository.addAddress(address);

      // updated selected address status
      address.id = id;
      await selectAddress(address);

      // Remove loader
      TFullScreenLoader.stopLoading();

      // show success message
      TLoaders.successSnackBar(
        title: 'Congratulations!',
        message: 'Your address has been saved successfully!',
      );

      // refresh addresses data
      refreshData.toggle();

      // reset fields
      resetFormFields();

      // redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
    }
  }

  // function to reset form field
  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }
}
