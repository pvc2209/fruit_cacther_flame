import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

import 'in_app.dart';
import 'in_app_constant.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final DodoInApp _inApp = Get.put(
    DodoInApp(
      useAmazon: true,
      enableSub: true,
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
      appBar: AppBar(
        title: const Text("Upgrade"),
        centerTitle: true,
      ),
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
                // Subscription------------------
                const SubWidget(),
                //--------------------------------
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
                              foregroundDecoration: index % 2 == 0
                                  ? RotatedCornerDecoration(
                                      color: Theme.of(context).primaryColor,
                                      geometry: const BadgeGeometry(
                                        width: 32,
                                        height: 32,
                                        alignment: BadgeAlignment.topLeft,
                                        cornerRadius: 8,
                                      ),
                                      textSpan: const TextSpan(
                                        text: 'Hot',
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
                                  "Flower ${index + 1}",
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

class SubWidget extends StatelessWidget {
  const SubWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _inApp = Get.find<DodoInApp>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => ListTile(
            title: const Text(
              "Premium 1",
              style: TextStyle(fontSize: 24),
            ),
            trailing: ElevatedButton(
              onPressed: _inApp.isProductReady(kSub1)
                  ? () {
                      _inApp.buySubById(kSub1);
                    }
                  : null,
              child: const Text("Upgrade"),
            ),
            subtitle: Text(_inApp.getPrice(kSub1)),
          ),
        ),
        Obx(
          () => ListTile(
            title: const Text(
              "Premium 2",
              style: TextStyle(fontSize: 24),
            ),
            trailing: ElevatedButton(
              onPressed: _inApp.isProductReady(kSub2)
                  ? () {
                      _inApp.buySubById(kSub2);
                    }
                  : null,
              child: const Text("Upgrade"),
            ),
            subtitle: Text(_inApp.getPrice(kSub2)),
          ),
        ),
        Obx(
          () => ListTile(
            title: const Text(
              "Premium 3",
              style: TextStyle(fontSize: 24),
            ),
            trailing: ElevatedButton(
              onPressed: _inApp.isProductReady(kSub3)
                  ? () {
                      _inApp.buySubById(kSub3);
                    }
                  : null,
              child: const Text("Upgrade"),
            ),
            subtitle: Text(_inApp.getPrice(kSub3)),
          ),
        ),
        Obx(
          () => ListTile(
            title: const Text(
              "Premium 4",
              style: TextStyle(fontSize: 24),
            ),
            trailing: ElevatedButton(
              onPressed: _inApp.isProductReady(kSub4)
                  ? () {
                      _inApp.buySubById(kSub4);
                    }
                  : null,
              child: const Text("Upgrade"),
            ),
            subtitle: Text(_inApp.getPrice(kSub4)),
          ),
        ),
      ],
    );
  }
}
