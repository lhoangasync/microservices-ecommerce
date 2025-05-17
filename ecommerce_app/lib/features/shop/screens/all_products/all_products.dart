import 'package:ecommerce_app/common/widgets/app_bar/appbar.dart';
import 'package:ecommerce_app/common/widgets/products/sortable/sortable_products.dart';
import 'package:ecommerce_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key, required this.title, this.futureMethod});

  final String title;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(AllProductsController());

    return Scaffold(
      appBar: TAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FutureBuilder<List<ProductModel>>(
            future: futureMethod,
            builder: (context, snapshot) {
              const loader = TVerticalProductShimmer();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loader;
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No products found.'));
              }
              final product = snapshot.data!;
              // Assign products to controller
              // controller.assignProducts(snapshot.data!);

              // UI render
              return TSortableProducts(products: product);
            },
          ),
        ),
      ),
    );
  }
}
