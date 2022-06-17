import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';

import '../spref/spref.dart';
import 'in_app_constant.dart';

class DodoInApp extends GetxController {
  DodoInApp({
    this.enableSub = false,
    this.useAmazon = false,
  });

  final bool enableSub;
  final bool useAmazon;
  RxBool isLoading = false.obs;

  RxList<IAPItem> items = <IAPItem>[].obs;

  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription _conectionSubscription;

  void init() async {
    await FlutterInappPurchase.instance.initialize();

    // refresh items for android
    if (!useAmazon) {
      try {
        await FlutterInappPurchase.instance.consumeAll();
      } catch (err) {
        debugPrint('consumeAllItems error: $err');
      }
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      debugPrint('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      if (kConsumables.contains(productItem!.productId)) {
        // Với amazon không cần consume
        if (!useAmazon) {
          await FlutterInappPurchase.instance
              .consumePurchaseAndroid(productItem.purchaseToken!);

          // Phải gọi consumePurchaseAndroid(productItem.purchaseToken!) mới được
          // còn dùng finishTransaction(productItem) sẽ bị lỗi đã you've own this item
        }

        int index = kConsumables.indexOf(productItem.productId!);

        // Tăng time
        int? seconds = await SPref.instance.getInt("seconds");

        if (seconds == null) {
          SPref.instance.setInt("seconds", 10 + index + 1);
        } else {
          SPref.instance.setInt("seconds", seconds + index + 1);
        }
      } else {
        // await FlutterInappPurchase.instance.acknowledgePurchaseAndroid(
        //   productItem.purchaseToken!,
        // );

        // Gọi acknowledgePurchaseAndroid cũng được nhưng gọi finishTransaction cho chắc ăn
        // vì finishTransaction sẽ "Send finishTransaction call that abstracts all acknowledgePurchaseAndroid, finishTransactionIOS, consumePurchaseAndroid methods."
        await FlutterInappPurchase.instance.finishTransaction(productItem);
      }
      isLoading.value = false;
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      debugPrint('purchase-error: $purchaseError');

      if (isLoading.value == true) {
        isLoading.value = false;
      }
    });

    _getProduct();
  }

  void cancel() {
    _conectionSubscription.cancel();
    _purchaseUpdatedSubscription.cancel();
    _purchaseErrorSubscription.cancel();
  }

  void buy(IAPItem item) async {
    isLoading.value = true;
    await FlutterInappPurchase.instance.requestPurchase(item.productId!);
  }

  void buyById(String productId) async {
    isLoading.value = true;

    // Xử lý ngoại lệ khi bấm mua nhưng lại cancel (chỉ áp dụng cho amazon)
    try {
      await FlutterInappPurchase.instance.requestPurchase(productId);
    } on PlatformException catch (_) {
      isLoading.value = false;
    }
  }

  void buySubById(String productId) async {
    isLoading.value = true;

    // Xử lý ngoại lệ khi bấm mua nhưng lại cancel (chỉ áp dụng cho amazon)
    try {
      await FlutterInappPurchase.instance.requestSubscription(productId);
    } on PlatformException catch (_) {
      isLoading.value = false;
    }
  }

  Future _getProduct() async {
    List<IAPItem> _items =
        await FlutterInappPurchase.instance.getProducts(kConsumables);

    for (var item in _items) {
      items.add(item);
    }

    if (enableSub) {
      List<IAPItem> _subItems =
          await FlutterInappPurchase.instance.getSubscriptions(kSubs);

      for (var subItem in _subItems) {
        items.insert(0, subItem);
      }
    }
  }

  String getPrice(String productId) {
    IAPItem? item =
        items.firstWhereOrNull((element) => element.productId == productId);

    // if (item == null) {
    //   return "...";
    // }

    return item?.localizedPrice ?? "...";
  }

  bool isProductReady(String productId) {
    IAPItem? item =
        items.firstWhereOrNull((element) => element.productId == productId);

    if (item == null || isLoading.value == true) {
      return false;
    }

    return true;
  }
}
