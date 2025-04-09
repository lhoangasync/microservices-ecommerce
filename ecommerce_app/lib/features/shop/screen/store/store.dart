import 'package:ecommerce_app/common/widgets/app_bar/tabbar.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:ecommerce_app/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app/features/shop/screen/store/widgets/category_tab.dart';
import 'package:ecommerce_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/app_bar/appbar.dart';
import '../../../../common/widgets/brands/brand_card.dart';
import '../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: TAppBar(
          title: Text('Store',style: Theme.of(context).textTheme.headlineMedium,),
          actions:[
            TCartCounterIcon(onPressed: (){}),
          ]
        ),
        body: NestedScrollView(headerSliverBuilder: (_, innerBoxIsScrolled){
          return[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 440,
              pinned: true,
              floating: true,
              backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white,
              flexibleSpace: Padding(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// -- Search Bar
                      SizedBox(height: TSizes.spaceBtwItems),
                      TSearchContainer(text: '',showBorder: true,showBackground: false,padding: EdgeInsets.zero),
                      SizedBox(height: TSizes.spaceBtwSections),
      
                      /// -- Featured Brands
                      TSectionHeading(title: 'Featured Brands',onPressed: (){}),
                      const SizedBox(height: TSizes.spaceBtwItems/1.5),
                      TGridLayout(itemCount: 4, mainAxisExtent:80 ,itemBuilder: (_,index){
                        return TBrandCard(showBorder : false);
                      })
                    ],
                  ),
              ),
              bottom: TTabBar(
                  tabs: [
                    Tab(child: Text('Sports')),
                    Tab(child: Text('Furniture')),
                    Tab(child: Text('Electronics')),
                    Tab(child: Text('Clothes')),
                    Tab(child: Text('Cosmetics')),
                  ]
              )
            )
          ];
        }, body: TabBarView(
            children: [
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
            ]
        )
        ),
      ),
    );
  }
}
