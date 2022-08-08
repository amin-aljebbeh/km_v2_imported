import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kammun_app/modules/home_page/model/special_products_model.dart';
import 'package:kammun_app/modules/home_page/redux/home_page_action.dart';
import 'package:kammun_app/modules/products/redux/products_action.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/core_importer.dart';

Future<void> homePageMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is FirstPaginationPage) {
    store.dispatch(FirstProductPage());
  } else if (action is GetSpecialProducts) {
    List<SpecialProductsModel> specialProducts = [];
    for (var element in action.specialProduct) {
      ProductResponse response = element.products;
      if (response != null) {
        if (response.data.isNotEmpty) {
          if (response.data.where((product) => product.isActive == '1').toList().isNotEmpty) {
            specialProducts.add(SpecialProductsModel(
                title: element.key,
                products: response.data.where((product) => product.isActive == '1').toList(),
                totalNumber: response.total.toString(),
                url: element.value,
                nonActiveNumber: response.data.where((product) => product.isActive == '0').length,
                hasNext: response.nextPageUrl != null));
          }
        }
      }
    }
    store.dispatch(SetSpecialProducts(specialProducts: specialProducts));
    store.dispatch(StopStoreLoading());
    store.dispatch(StopLoading());
  } else if (action is Subscribe) {
    FirebaseMessaging().subscribeToTopic(action.topic);
    FirebaseFirestore.instance
        .collection('topics')
        .doc(action.firebaseToken)
        .set({action.topic: 'subscribe'}, SetOptions(merge: true));
  } else if (action is UnSubscribe) {
    FirebaseMessaging().unsubscribeFromTopic(action.topic);
    FirebaseFirestore.instance
        .collection('topics')
        .doc(action.firebaseToken)
        .update({action.topic: FieldValue.delete()});
  }
  next(action);
}
