import 'package:ecommerce_app/common/widgets/chips/choice_chip.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/common/widgets/texts/product_title_text.dart';
import 'package:ecommerce_app/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/product/variation_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/constants/colors.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/formatters/formatter.dart';
import 'package:ecommerce_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TProductAttributes extends StatelessWidget {
  const TProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VariationController());
    final dark = THelperFunctions.isDarkMode(context);
    controller.setCurrentProduct(product);

    return Obx(
      () => Column(
        children: [
          // Selected Attribute pricing & description
          // display variation price and stock when some variation is selected
          if (controller.selectedVariation.value.variantId.isNotEmpty)
            TRoundedContainer(
              padding: EdgeInsets.all(TSizes.md),
              backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
              child: Column(
                children: [
                  // Title, price, and stock status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Heading: Type
                      Padding(
                        padding: const EdgeInsets.only(bottom: TSizes.sm),
                        child: TSectionHeading(
                          title: 'Variation',
                          showActionButton: false,
                        ),
                      ),

                      // Price row
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TProductTitleText(
                                title: 'Price: ',
                                smallSize: true,
                              ),

                              // Actual Price
                              Row(
                                children: [
                                  if (controller
                                          .selectedVariation
                                          .value
                                          .salePrice >
                                      0)
                                    Text(
                                      TFormatter.formatVND(
                                        controller
                                            .selectedVariation
                                            .value
                                            .price,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall!.apply(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  const SizedBox(width: TSizes.spaceBtwItems),

                                  // Sale Price
                                  TProductPriceText(
                                    price: controller.getVariationPrice(),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Stock
                          Row(
                            children: [
                              const TProductTitleText(
                                title: 'Stock: ',
                                smallSize: true,
                              ),
                              Text(
                                controller.variationStockStatus.value,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Variations & description
                  TProductTitleText(
                    title: controller.selectedVariation.value.description,
                    smallSize: true,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Attributes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                product.attributes
                    .map(
                      (attribute) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          TSectionHeading(
                            title: attribute.name ?? '',
                            showActionButton: false,
                          ),
                          SizedBox(height: TSizes.spaceBtwItems / 2),
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              children:
                                  attribute.values!.map((attributeValue) {
                                    final isSelected =
                                        controller.selectedAttributes[attribute
                                            .name] ==
                                        attributeValue;
                                    final available = controller
                                        .getAttributesAvailabilityInVariation(
                                          product.variants,
                                          attribute.name!,
                                        )
                                        .contains(attributeValue);

                                    return TChoiceChip(
                                      text: attributeValue,
                                      selected: isSelected,
                                      onSelected:
                                          available
                                              ? (selected) {
                                                if (selected && available) {
                                                  controller
                                                      .onAttributeSelected(
                                                        product,
                                                        attribute.name ?? '',
                                                        attributeValue,
                                                      );
                                                }
                                              }
                                              : null,
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
