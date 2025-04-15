import 'package:ecommerce_app/common/widgets/chips/choice_chip.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app/common/widgets/texts/product_title_text.dart';
import 'package:ecommerce_app/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app/utils/constants/colors.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TProductAttributes extends StatelessWidget {
  const TProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Column(
      children: [
        // Selected Attribute pricing & description
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
                          TProductTitleText(title: 'Price: ', smallSize: true),

                          // Actual Price
                          Row(
                            children: [
                              Text(
                                '500.000.000 đ',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.apply(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: TSizes.spaceBtwItems),

                              // Sale Price
                              TProductPriceText(price: '300.000'),
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
                            'In Stock',
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
                title:
                    'This is the Description of the Product and it can go upto max 4 lines.',
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

          children: [
            TSectionHeading(title: 'Colors', showActionButton: false),
            SizedBox(height: TSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                TChoiceChip(
                  text: 'Green',
                  selected: true,
                  onSelected: (value) {},
                ),
                TChoiceChip(
                  text: 'Blue',
                  selected: false,
                  onSelected: (value) {},
                ),

                TChoiceChip(
                  text: 'Yellow',
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TSectionHeading(title: 'Size', showActionButton: false),
            SizedBox(height: TSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                TChoiceChip(
                  text: 'EU 34',
                  selected: true,
                  onSelected: (value) {},
                ),
                TChoiceChip(
                  text: 'EU 36',
                  selected: false,
                  onSelected: (value) {},
                ),

                TChoiceChip(
                  text: 'EU 38',
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
