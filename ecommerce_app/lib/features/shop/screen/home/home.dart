import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:ecommerce_app/features/shop/screen/home/widgets/home_appbar.dart';
import 'package:ecommerce_app/features/shop/screen/home/widgets/home_categories.dart';
import 'package:ecommerce_app/features/shop/screen/home/widgets/promo_slider.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart' hide CarouselController;


import '../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/container/search_container.dart';
import '../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/products/cart_menu_icon.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
                      child: Column(
                        children: [
                          const THomeAppBar(),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          const TSearchContainer(text: 'Search in store'),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          Padding(
                              padding: const EdgeInsets.only(left:TSizes.defaultSpace),
                            child:  Column(
                              children: [
                                TSectionHeading(title: "Popular Categories",showActionButton: false,textColor: Colors.white),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                THomeCategories()
                              ],
                            ),
                          )
                        ],
                      )
                    ),
            Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child:TPromoSlider(banners: [TImages.promoBanner1,TImages.promoBanner2,TImages.promoBanner3],)
            )
          ],
        ),
      ),
    );
  }
}
