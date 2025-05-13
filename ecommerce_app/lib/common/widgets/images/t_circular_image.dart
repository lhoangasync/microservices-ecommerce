import 'dart:math' as math; // Thêm import này
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/common/widgets/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.isNetworkImage = false,
    this.backgroundColor,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    final double actualDiameter = math.min(width, height);

    final double imageDiameter = actualDiameter - (padding * 2);

    final double finalImageDiameter = math.max(0, imageDiameter);

    return Container(
      width: actualDiameter,
      height: actualDiameter,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (THelperFunctions.isDarkMode(context)
                ? TColors.black
                : TColors.white),

        borderRadius: BorderRadius.circular(actualDiameter / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(finalImageDiameter / 2),
        child: Center(
          child:
              isNetworkImage
                  ? CachedNetworkImage(
                    fit: fit,
                    color: overlayColor,
                    imageUrl: image,

                    width: finalImageDiameter,
                    height: finalImageDiameter,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => TShimmerEffect(
                          width: finalImageDiameter,
                          height: finalImageDiameter,
                        ),
                    errorWidget:
                        (context, url, error) =>
                            Icon(Icons.error, size: finalImageDiameter * 0.7),
                  )
                  : Image(
                    fit: fit,
                    image: AssetImage(image),
                    color: overlayColor,
                    width: finalImageDiameter,
                    height: finalImageDiameter,
                  ),
        ),
      ),
    );
  }
}
