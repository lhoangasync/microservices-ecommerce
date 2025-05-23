import 'package:ecommerce_app/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/images/t_circular_image.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/common/widgets/texts/product_title_text.dart';
import 'package:ecommerce_app/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/constants/colors.dart';
import 'package:ecommerce_app/utils/constants/enums.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TProductMetaData extends StatelessWidget {
  const TProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(
      product.price,
      product.salePrice,
    );
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price & Sale Price
        Row(
          children: [
            // Sale Tag
            TRoundedContainer(
              radius: TSizes.sm,
              backgroundColor: TColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.xs,
              ),
              child: Text(
                '$salePercentage%',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.apply(color: TColors.black),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),

            // Price
            // Text(
            //   '500.000 VND',
            //   style: Theme.of(context).textTheme.titleSmall!.apply(
            //     decoration: TextDecoration.lineThrough,
            //   ),
            // ),

            // const SizedBox(width: TSizes.spaceBtwItems),
            TProductPriceText(
              price: controller.getProductPrice(product),
              isLarge: true,
            ),
          ],
        ),

        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        // Title
        TProductTitleText(title: product.name),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        // Stock Status
        Row(
          children: [
            TProductTitleText(title: 'Status'),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              controller.getProductStockStatus(product.quantity),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        // Brand
        Row(
          children: [
            TCircularImage(
              isNetworkImage: true,
              image: product.brand.image,
              width: 32,
              height: 32,
              overlayColor: dark ? TColors.white : TColors.black,
            ),
            TBrandTitleWithVerifiedIcon(
              title: product.brand.name,
              brandTextSizes: TextSizes.medium,
            ),
          ],
        ),
      ],
    );
  }
}
