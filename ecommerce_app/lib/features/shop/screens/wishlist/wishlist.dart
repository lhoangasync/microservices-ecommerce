import 'package:ecommerce_app/common/widgets/app_bar/appbar.dart';
import 'package:ecommerce_app/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/loaders/animation_loader.dart';
import 'package:ecommerce_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:ecommerce_app/features/shop/controllers/product/favourites_controller.dart';
import 'package:ecommerce_app/features/shop/screens/home/home.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/http/cloud_helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () => Get.to(const HomeScreen()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),

          child: Obx(
            () => FutureBuilder(
              future: controller.favoriteProducts(),
              builder: (context, snapshot) {
                // Nothing found widget
                final emptyWidget = TAnimationLoaderWidget(
                  text: 'Whoops! Wishlist is Empty...',
                  animation: TImages.pencilAnimation,
                  showAction: true,
                  actionText: 'Let\'s add some products',
                  onActionPressed:
                      () => Get.offAll(() => const NavigationMenu()),
                );
                const loader = TVerticalProductShimmer(itemCount: 6);
                final widget = TCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  loader: loader,
                  nothingFound: emptyWidget,
                );
                if (widget != null) return widget;

                final products = snapshot.data!;
                return TGridLayout(
                  itemCount: products.length,
                  itemBuilder:
                      (_, index) =>
                          TProductCardVertical(product: products[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
