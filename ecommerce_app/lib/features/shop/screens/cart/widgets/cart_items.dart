import 'package:ecommerce_app/common/widgets/products/cart/add_remove_button.dart';
import 'package:ecommerce_app/common/widgets/products/cart/cart_item.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 2,
      separatorBuilder:
          (_, __) => const SizedBox(height: TSizes.spaceBtwSections),
      itemBuilder:
          (_, index) => Column(
            children: [
              // Cart Item
              TCartItem(),
              if (showAddRemoveButtons)
                const SizedBox(height: TSizes.spaceBtwItems),

              // Add Remove Button with total price
              if (showAddRemoveButtons)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 70),
                        // Add Remove Button
                        TProductQuantityWithAddRemoveButton(),
                      ],
                    ),

                    // Product total price
                    TProductPriceText(price: '400.000'),
                  ],
                ),
            ],
          ),
    );
  }
}
