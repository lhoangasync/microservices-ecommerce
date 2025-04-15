import 'package:ecommerce_app/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app/utils/constants/colors.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder:
          (_, index) => TRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(TSizes.md),
            backgroundColor: dark ? TColors.dark : TColors.light,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1
                Row(
                  children: [
                    // 1 Icon
                    Icon(Iconsax.ship),
                    SizedBox(width: TSizes.spaceBtwItems / 2),

                    // 2 Status & Date
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processing',
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                              color: TColors.primary,
                              fontWeightDelta: 1,
                            ),
                          ),
                          Text(
                            '30 March 2004',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),

                    // 3 Icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.arrow_right_34,
                        size: TSizes.iconSm,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: TSizes.spaceBtwItems),
                // Row 2
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // 1 Icon
                          Icon(Iconsax.tag),
                          SizedBox(width: TSizes.spaceBtwItems / 2),

                          // 2 Status & Date
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  '[#256f2]',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          // 1 Icon
                          Icon(Iconsax.calendar),
                          SizedBox(width: TSizes.spaceBtwItems / 2),

                          // 2 Status & Date
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping Date',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  '30 March 2004',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
