import 'package:ecommerce_app/common/widgets/app_bar/appbar.dart';
import 'package:ecommerce_app/common/widgets/images/t_circular_image.dart';
import 'package:ecommerce_app/common/widgets/shimmer/shimmer.dart';
import 'package:ecommerce_app/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text('Profile')),
      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Obx(
            () => Column(
              children: [
                // Profile Picture
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Obx(() {
                        final networkImage = controller.user.value.imageUrl;
                        final image =
                            networkImage.isNotEmpty
                                ? networkImage
                                : TImages.user;

                        return controller.isUploadingAvatar.value
                            ? const TShimmerEffect(
                              width: 80,
                              height: 80,
                              radius: 80,
                            )
                            : TCircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkImage: networkImage.isNotEmpty,
                            );
                      }),
                      TextButton(
                        onPressed: () => controller.uploadAvatar(),
                        child: Text('Change Profile Picture'),
                      ),
                    ],
                  ),
                ),

                // Details
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Heading Profile Information
                TSectionHeading(
                  title: 'Profile Information',
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                TProfileMenu(
                  title: 'Name',
                  value: controller.user.value.fullName,
                  onPressed: () => Get.to(() => const ChangeNameScreen()),
                ),
                TProfileMenu(
                  title: 'Username',
                  value: controller.user.value.username,
                  onPressed: () {},
                ),

                const SizedBox(height: TSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Heading Personal Information
                TSectionHeading(
                  title: 'Personal Information',
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                TProfileMenu(
                  title: 'User ID',
                  value: controller.user.value.id,
                  icon: Iconsax.copy,
                  onPressed: () {},
                ),
                TProfileMenu(
                  title: 'Email',
                  value: controller.user.value.email,
                  onPressed: () {},
                ),
                TProfileMenu(
                  title: 'Phone',
                  value: controller.user.value.phone,
                  onPressed: () {},
                ),
                TProfileMenu(title: 'Gernder', value: 'Male', onPressed: () {}),
                TProfileMenu(
                  title: 'Date of Birth',
                  value: '30 March, 2004',
                  onPressed: () {},
                ),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Close Account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
