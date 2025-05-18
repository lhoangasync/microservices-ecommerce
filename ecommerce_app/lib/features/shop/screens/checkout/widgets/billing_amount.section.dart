import 'package:ecommerce_app/features/shop/controllers/product/cart_controller.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    // Định nghĩa phí cố định
    const double shippingFee = 30000.0;
    const double taxFee = 30000.0;

    return Obx(() {
      // Lấy subtotal từ controller
      final subtotal = cartController.totalCartPrice.value;
      // Tính tổng đơn hàng
      final orderTotal = subtotal + shippingFee + taxFee;

      return Column(
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                TFormatter.formatVND(subtotal),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          // Shipping Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Fee',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                TFormatter.formatVND(shippingFee),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          // Tax Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                TFormatter.formatVND(taxFee),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          // Order Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Total',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                TFormatter.formatVND(orderTotal),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      );
    });
  }
}
