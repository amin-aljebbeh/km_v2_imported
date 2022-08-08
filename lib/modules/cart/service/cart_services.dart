import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kammun_app/modules/cart/redux/cart_action.dart';
import '../../../core/core_importer.dart';

class CartServices {
  static Future<List<ProductData>> getUserCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userCart = prefs.getString('userCart');
      if (userCart != null && userCart.length == 1 && userCart == '@') {
        prefs.setString('userCart', '');
      }

      if (userCart != null && userCart.length > 2 && userCart.toString() != 'null') {
        List<String> productsCounts = userCart.split('@')[1].split(';');

        var response = await ApiProvider.sendRequest(
            url: syncCart,
            method: HttpMethods.post,
            body: jsonEncode({
              'product_ids': userCart
                  .split('@')[0]
                  .replaceRange(userCart.split('@')[0].length - 1, userCart.split('@')[0].length, ''),
            }));

        if (response.statusCode == successCode && response.data['success'] == true) {
          final temp = syncCartFromJson(jsonEncode(response.data['data']));
          List<ProductData> products = [];
          for (int i = 0; i < temp.length; i++) {
            if (temp[i] != null) {
              temp[i].productCount = int.parse(productsCounts[i]);
              StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(AddProductToCart(product: temp[i]));
              products.add(temp[i]);
            }
          }
          StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(SaveCart(cartProducts: products));
          return products;
        } else {
          return null;
        }
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  static updateOrderDialog() {
    showMyDialog(
      title: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'انت تقوم حالياً بتعديل طلبك',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green, fontFamily: StringUtils.fontFamily, fontSize: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'بإمكانك إضافة أو حذف او تعديل المنتجات الخاصة بك ضمن سلة المشتريات بالشكل الطبيعي الذي تقوم به عادة',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                  fontFamily: StringUtils.fontFamily,
                  fontSize: 18),
            ),
          ),
          KButton(
            color: ColorUtils.primaryColor,
            onTap: () => StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(Pop()),
            text: StringUtils.approve,
            width: MediaQuery.of(navigatorKey.currentContext).size.width / 2,
          ),
        ],
      ),
      dialogButtons: [],
    );
  }

  static moveOrderProductsToCart({OrdersOriginalData order}) async {
    List<ProductData> cartProducts = [];
    for (int i = 0; i < order.products.length; i++) {
      ProductData product = ProductData();

      product.id = order.products[i].id;
      product.images = order.products[i].images;
      product.name = order.products[i].name;

      product.price = order.products[i].pivot.purchasePrice;

      product.productCount = int.parse(order.products[i].pivot.quantity);
      product.unit = order.products[i].unit;
      product.quantity = order.products[i].quantity;
      product.maxCount = '-1';

      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(AddProductToCart(product: product));
      cartProducts.add(product);
    }
  }

  static cartChanged({List<ProductData> cartProducts}) async {
    String productsId = '';
    String productsQuantity = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < cartProducts.length; i++) {
      productsId += cartProducts[i].id.toString() + ';';
      productsQuantity += cartProducts[i].productCount.toString() + ';';
    }
    prefs.setString('userCart', productsId + '@' + productsQuantity);
  }

  static syncAddProduct({ProductData product}) async {
    try {
      ApiProvider.sendRequest(
          url: addProductToCart,
          method: HttpMethods.post,
          body: {'product_id': product.id, 'count': product.productCount});
    } catch (e) {
      return;
    }
  }
}
