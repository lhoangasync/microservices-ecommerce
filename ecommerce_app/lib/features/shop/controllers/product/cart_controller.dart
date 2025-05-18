// ignore_for_file: unnecessary_null_comparison

import 'package:ecommerce_app/features/shop/controllers/product/variation_controller.dart';
import 'package:ecommerce_app/features/shop/models/cart_item_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/local_storage/storage_utility.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Variables
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  final variationController = VariationController.instance;

  CartController() {
    loadCartItems();
  }

  // add items in cart
  void addToCart(ProductModel product) {
    // check quantity
    if (productQuantityInCart.value < 1) {
      TLoaders.customToast(message: 'Select quantity');
      return;
    }

    // variation selected
    if (variationController.selectedVariation.value.variantId.isEmpty) {
      TLoaders.customToast(message: 'Select Variation');
      return;
    }

    // Out of stock status
    if (variationController.selectedVariation.value.quantity < 1) {
      TLoaders.warningSnackBar(
        message: 'Selected variation is out of stock',
        title: 'On Snap!',
      );
      return;
    }

    final selectedCartItem = convertToCartItems(
      product,
      productQuantityInCart.value,
    );

    // check if already add in cart
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == selectedCartItem.productId &&
          cartItem.variationId == selectedCartItem.variationId,
    );

    if (index >= 0) {
      // quantity is already added or updated/remove from the design (cart)(-)
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    TLoaders.customToast(message: 'Your Product has been added to Cart');
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        // show dialog before completely removing
        cartItems[index].quantity == 1
            ? removeFromCartDialog(index)
            : cartItems.removeAt(index);
      }
      updateCart();
    }
  }

  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: 'Remove product',
      middleText: 'Are you sure you want to remove this product',
      onConfirm: () {
        // remove the item from the cart
        cartItems.removeAt(index);
        updateCart();
        TLoaders.customToast(message: 'Product removed from Cart');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  void updateAlreadyAddedProductCount(ProductModel product) {
    final variationId = variationController.selectedVariation.value.variantId;
    if (variationId.isNotEmpty) {
      productQuantityInCart.value = getVariationQuantityInCart(
        product.id,
        variationId,
      );
    } else {
      productQuantityInCart.value = 0;
    }
  }

  CartItemModel convertToCartItems(ProductModel product, int quantity) {
    final variation = variationController.selectedVariation.value;
    final isVariation = variation.variantId.isNotEmpty;
    final price =
        isVariation
            ? variation.salePrice > 0.0
                ? variation.salePrice
                : variation.price
            : product.salePrice > 0.0
            ? product.salePrice
            : product.price;

    return CartItemModel(
      productId: product.id,
      title: product.name,
      price: price,
      quantity: quantity,
      variationId: variation.variantId,
      image: isVariation ? variation.image : product.thumbnail,
      brandName: product.brand != null ? product.brand.name : '',
      selectedVariation:
          isVariation
              ? {
                for (var attr in variation.attributeVariant)
                  attr.name: attr.value,
              }
              : null,
    );
  }

  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    TLocalStorage.instance().saveData('cartItems', cartItemStrings);
  }

  void loadCartItems() {
    final cartItemStrings = TLocalStorage.instance().readData<List<dynamic>>(
      'cartItems',
    );
    if (cartItemStrings != null) {
      cartItems.assignAll(
        cartItemStrings.map(
          (item) => CartItemModel.fromJson(item as Map<String, dynamic>),
        ),
      );
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);

    return foundItem;
  }

  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );
    return foundItem.quantity;
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
