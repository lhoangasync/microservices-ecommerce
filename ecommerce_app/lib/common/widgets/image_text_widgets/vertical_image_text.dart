import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/common/widgets/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = TColors.white,
    this.backgroundColor,
    this.onTap,
    this.isNetworkImage = false,
  });

  final bool isNetworkImage;
  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(TSizes.sm),
                decoration: BoxDecoration(
                  color:
                      backgroundColor ?? (dark ? TColors.dark : TColors.white),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Center(
                    child:
                        isNetworkImage
                            ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: image,

                              width: 56,
                              height: 56,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      TShimmerEffect(width: 56, height: 56),
                              errorWidget:
                                  (context, url, error) => Icon(Icons.error),
                            )
                            : Image(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                              color: dark ? TColors.white : TColors.dark,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              SizedBox(
                width: 56,
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.apply(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
