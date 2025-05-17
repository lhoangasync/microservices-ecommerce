import 'package:ecommerce_app/common/widgets/layouts/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class TBrandShimmer extends StatelessWidget {
  const TBrandShimmer({super.key, this.itemCount = 4});

  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return TGridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => TShimmerEffect(width: 300, height: 80),
    );
  }
}
