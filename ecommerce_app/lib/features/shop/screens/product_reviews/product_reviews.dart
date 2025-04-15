import 'package:ecommerce_app/common/widgets/app_bar/appbar.dart';
import 'package:ecommerce_app/common/widgets/products/ratings/rating_indicator.dart';
import 'package:ecommerce_app/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:ecommerce_app/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: TAppBar(title: Text('Reiviews & Ratings'), showBackArrow: true),

      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ratings and reviews are verified and are from people who use the same type of device that you use',
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              // Overall Product Ratings
              const TOverallProductRating(),
              const TRatingBarIndicator(rating: 3.5),
              Text('30,304', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: TSizes.spaceBtwSections),

              // User Reviews List
              UserReviewCard(),
              UserReviewCard(),

              UserReviewCard(),

              UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
