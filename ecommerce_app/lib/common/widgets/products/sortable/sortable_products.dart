import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app/features/shop/controllers/product/all_products_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TSortableProducts extends StatelessWidget {
  const TSortableProducts({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);

    return Column(
      children: [
        // Dropdown
        DropdownButtonFormField(
          decoration: InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOption.value,
          onChanged: (value) {
            controller.sortProducts(value!);
          },
          items:
              [
                    'Name',
                    'Higher Price',
                    'Lower Price',
                    'Sales',
                    'Newest',
                    'Popularity',
                  ]
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        // Products
        Obx(
          () => TGridLayout(
            itemCount: controller.products.length,
            itemBuilder:
                (_, index) =>
                    TProductCardVertical(product: controller.products[index]),
          ),
        ),
      ],
    );
  }
}
