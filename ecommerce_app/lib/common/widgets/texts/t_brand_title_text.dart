import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
class TBrandTitleText extends StatelessWidget {
  const TBrandTitleText({
    super.key,
    this.color,
    this.maxLines = 1,
    required this.title,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,
  });
  final Color? color;
  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      // Check which BrandSize is required and set that style
      style: brandTextSize == TextSizes.small
        ? Theme.of(context).textTheme.labelMedium!.apply(color:color)
        : brandTextSize == TextSizes.medium
          ? Theme.of(context).textTheme.bodyLarge!.apply(color:color)
          : Theme.of(context).textTheme.bodyMedium!.apply(color:color),
    );
  }
}
