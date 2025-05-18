import 'package:ecommerce_app/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());

    return Obx(() {
      final selectedAddress = controller.selectedAddress.value;
      // Kiểm tra nếu không có địa chỉ được chọn
      final hasAddress = selectedAddress.id.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TSectionHeading(
            title: 'Shipping Address',
            buttonTitle: 'Change',
            onPressed:
                () => Get.to(
                  () => const UserAddressScreen(),
                ), // Điều hướng đến màn hình danh sách địa chỉ
          ),

          // Nếu không có địa chỉ, hiển thị thông báo
          if (!hasAddress)
            Text(
              'Please select a shipping address',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người nhận
                Text(
                  selectedAddress.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                // Số điện thoại
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.grey, size: 16),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Text(
                      selectedAddress.formattedPhoneNo,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),

                // Địa chỉ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_history,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: Text(
                        selectedAddress.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
              ],
            ),
        ],
      );
    });
  }
}
