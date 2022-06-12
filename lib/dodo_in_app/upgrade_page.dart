import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

import 'in_app.dart';
import 'in_app_constant.dart';
import 'profile_clipper.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final DodoInApp _inApp = Get.put(
    DodoInApp(
      useAmazon: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    _inApp.init();
  }

  @override
  void dispose() {
    _inApp.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepOrange.withOpacity(0.0),
                Colors.pink.withOpacity(0.4),
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipPath(
                      clipper: ProfileClipper(),
                      child: const Image(
                        height: 260.0,
                        width: double.infinity,
                        image: AssetImage(
                          "assets/images/bg.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
                      top: 100,
                      child: Text(
                        "Upgrade",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 1.0,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        color: Colors.white,
                        iconSize: 30.0,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: kConsumables.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Obx(
                            () => Container(
                              padding: const EdgeInsets.all(8),
                              foregroundDecoration: index % 1 == 0
                                  ? RotatedCornerDecoration(
                                      color: Theme.of(context).primaryColor,
                                      geometry: const BadgeGeometry(
                                        width: 32,
                                        height: 32,
                                        alignment: BadgeAlignment.topLeft,
                                        cornerRadius: 8,
                                      ),
                                      textSpan: const TextSpan(
                                        text: 'Sale',
                                        style: TextStyle(
                                          fontSize: 8,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      labelInsets:
                                          const LabelInsets(baselineShift: 3),
                                    )
                                  : null,
                              child: ListTile(
                                title: Text(
                                  "${index + 1} s for you",
                                  style: const TextStyle(fontSize: 24),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: _inApp
                                          .isProductReady(kConsumables[index])
                                      ? () {
                                          _inApp.buyById(kConsumables[index]);
                                        }
                                      : null,
                                  child: const Text("Buy"),
                                ),
                                subtitle:
                                    Text(_inApp.getPrice(kConsumables[index])),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class BuyItem extends StatelessWidget {
//   const BuyItem({
//     Key? key,
//     required this.productId,
//   }) : super(key: key);

//   final String productId;

//   @override
//   Widget build(BuildContext context) {
//     final _inApp = Get.find<DodoInApp>();
//     return Obx(
//       () => ListTile(
//         title: Text(_inApp.getPrice(productId)),
//         trailing: ElevatedButton(
//           onPressed: _inApp.isProductReady(productId)
//               ? () {
//                   _inApp.buyBuyId(productId);
//                 }
//               : null,
//           child: const Text("Buy"),
//         ),
//       ),
//     );
//   }
// }
