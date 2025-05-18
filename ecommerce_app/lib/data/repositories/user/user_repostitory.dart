import 'package:ecommerce_app/features/personalization/models/user_model.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  // Function to get user's info
  Future<UserModel> getMyAccount() async {
    try {
      final response = await THttpHelper.get(
        'identity/auth/my-account',
        useToken: true,
      );

      if (response['code'] == 200) {
        final userData = response['data']['data']['user'];
        print("--------- Check User data: $userData");
        return UserModel.fromJson(userData);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      throw Exception('Failed to fetch user');
    }
  }

  // Function to update user's info
  Future<UserModel> updateUser(Map<String, dynamic> json) async {
    try {
      final response = await THttpHelper.put(
        'identity/users/update',
        json,
        useToken: true,
      );

      if (response['code'] == 200) {
        final updatedUserData = response['data'];
        return UserModel.fromJson(updatedUserData);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      throw Exception('Failed to update user');
    }
  }

  // upload avatar
  Future<UserModel> uploadAvatar(XFile file) async {
    try {
      final response = await THttpHelper.uploadMultipartFile(
        'identity/users/avatar',
        'file',
        file.path,
        useToken: true,
      );

      if (response['code'] == 200) {
        final userData = response['data'];
        return UserModel.fromJson(userData);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      throw Exception('Failed to upload avatar');
    }
  }
}
