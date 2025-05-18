import 'package:ecommerce_app/common/widgets/products/cart/add_remove_button.dart';
import 'package:ecommerce_app/common/widgets/products/cart/cart_item.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/features/shop/controllers/product/cart_controller.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: cartController.cartItems.length,
        separatorBuilder:
            (_, __) => const SizedBox(height: TSizes.spaceBtwSections),
        itemBuilder:
            (_, index) => Obx(() {
              final item = cartController.cartItems[index];
              return Column(
                children: [
                  // Cart Item
                  TCartItem(cartItem: item),
                  if (showAddRemoveButtons)
                    const SizedBox(height: TSizes.spaceBtwItems),

                  // Add Remove Button with total price
                  if (showAddRemoveButtons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 70),
                            // Add Remove Button
                            TProductQuantityWithAddRemoveButton(
                              quantity: item.quantity,
                              add: () => cartController.addOneToCart(item),
                              remove:
                                  () => cartController.removeOneFromCart(item),
                            ),
                          ],
                        ),

                        // Product total price
                        TProductPriceText(
                          price: TFormatter.formatVND(
                            item.price * item.quantity,
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }),
      ),
    );
  }
}
