import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'in_app.dart';

class BuyPageOld extends StatefulWidget {
  const BuyPageOld({Key? key}) : super(key: key);

  @override
  State<BuyPageOld> createState() => _BuyPageOldState();
}

class _BuyPageOldState extends State<BuyPageOld> {
  final DodoInApp _inApp = Get.put(DodoInApp(useAmazon: true));

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
        title: const Text("Buy Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(
          () => _inApp.items.isEmpty
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _inApp.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_inApp.items[index].localizedPrice!),
                      subtitle: Text(_inApp.items[index].title!),
                      trailing: Obx(
                        () => ElevatedButton(
                          onPressed: _inApp.isLoading.value
                              ? null
                              : () {
                                  _inApp.buy(_inApp.items[index]);
                                },
                          child: const Text("Buy"),
                        ),
                      ),
                    );
                  },
                ),
        ),
        // child: Obx(
        //   () => _inApp.items.length == 0
        //       ? CircularProgressIndicator()
        //       : Column(
        //           children: [
        //             ElevatedButton(
        //               onPressed: () {
        //                 _inApp.buy(_inApp.items[0]);
        //               },
        //               child: Text(_inApp.items[0].localizedPrice!),
        //             ),
        //             ElevatedButton(
        //               onPressed: () {
        //                 _inApp.buy(_inApp.items[1]);
        //               },
        //               child: Text(_inApp.items[1].localizedPrice!),
        //             ),
        //             ElevatedButton(
        //               onPressed: () {
        //                 _inApp.buy(_inApp.items[1]);
        //               },
        //               child: Text(_inApp.items[2].localizedPrice!),
        //             ),
        //           ],
        //         ),
        // ),
      ),
    );
  }
}
