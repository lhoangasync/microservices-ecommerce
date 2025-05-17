import 'package:ecommerce_app/data/repositories/user/user_repostitory.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/features/personalization/models/user_model.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:get/get.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      UserModel currentUser = await UserRepository.instance.getMyAccount();
      final userId = currentUser.id;
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try again in few minutes';
      }

      final response = await THttpHelper.get(
        'identity/addresses/get-all',
        useToken: true,
      );

      print('--------check address user: $response');

      if (response['code'] == 200) {
        final addressesData = response['data']['data'] as List<dynamic>;

        return addressesData
            .map((json) => AddressModel.fromJson(json))
            .toList();
      } else {
        throw response['message'] ?? 'Failed to fetch addresses';
      }
    } catch (e) {
      print('Error in fetchUserAddresses: $e');
      throw 'Something went wrong while fetching Address Information. Please try again';
    }
  }

  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      UserModel currentUser = await UserRepository.instance.getMyAccount();
      final userId = currentUser.id;
      if (userId.isEmpty) {
        throw 'Unable to find user information to update. Try again in few minutes';
      }
      final response = await THttpHelper.put('identity/addresses/update', {
        "id": addressId,
        "selectedAddress": selected,
      }, useToken: true);

      if (response['code'] != 200) {
        throw response['message'] ?? 'Failed to update address selection';
      }

      print('Address selection updated successfully');
    } catch (e) {
      throw 'Unable to update your address selection. Try again later!';
    }
  }

  Future<String> addAddress(AddressModel address) async {
    try {
      UserModel currentUser = await UserRepository.instance.getMyAccount();
      final userId = currentUser.id;
      if (userId.isEmpty) {
        throw 'Unable to find user information to update. Try again in few minutes';
      }

      final response = await THttpHelper.post(
        'identity/addresses/create',
        address.toJson(),
        useToken: true,
      );

      if (response['code'] == 200 || response['code'] == 201) {
        final addressData = response['data']['data'];
        final addressId = addressData['id'];

        print('Address created successfully with ID: $addressId');
        return addressId;
      } else {
        throw response['message'] ?? 'Failed to create address';
      }
    } catch (e) {
      print('Error in addAddress: $e');
      throw 'Unable to add your address. Please try again later!';
    }
  }
}
