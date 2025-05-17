import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:ecommerce_app/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/screens/all_products/all_products.dart';
import 'package:ecommerce_app/features/shop/screens/store/widgets/category_brands.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';

class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// --Brands
              CategoryBrands(category: category),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// -- Products
              FutureBuilder(
                future: controller.getCategoryProducts(categoryId: category.id),
                builder: (context, snapshot) {
                  const loader = TVerticalProductShimmer();
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loader;
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No brands category found.'),
                    );
                  }

                  final products = snapshot.data!;

                  return Column(
                    children: [
                      TSectionHeading(
                        title: 'You might like',
                        onPressed:
                            () => Get.to(
                              AllProducts(
                                title: category.name,
                                futureMethod: controller.getCategoryProducts(
                                  categoryId: category.id,
                                  limit: -1,
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      TGridLayout(
                        itemCount: products.length,
                        itemBuilder:
                            (_, index) =>
                                TProductCardVertical(product: products[index]),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
