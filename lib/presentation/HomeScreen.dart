/**
 * Created by Mahesh Gubbi on 24-11-2023.
 * Bengaluru.
 */

import 'package:expleobard/controller/HomeController.dart';
import 'package:expleobard/presentation/BardQueryWidget.dart';
import 'package:expleobard/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    TextEditingController textField = TextEditingController();
    return Scaffold(
      backgroundColor: const Color(0xfff2f1f9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            controller.isLoading.value
                ? Constants.showCustomToast(context, 'Please wait')
                : controller.sendPrompt("Look something about Expleo");
          },
          child: SvgPicture.asset(
            "assets/expleo.svg",
            color: const Color(0xff7044c4),
          ),
        ),
        title: const Text(
          "EXPLEO BARD",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              controller.isLoading.value
                  ? Constants.showCustomToast(context, 'Please wait')
                  : controller.sendPrompt("About Bard");
            },
            child: SvgPicture.asset(
              "assets/bard_logo.svg",
              width: 60,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              reverse: true,
              children: [
                Obx(() => Column(
                      children: controller.historyList
                          .map(
                            (e) => BardQueryWidget(
                              system: e.system,
                              message: e.message,
                              controller: controller,
                            ),
                          )
                          .toList(),
                    )),
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/expleo.svg",
                      color: const Color(0xff7044c4),
                      height: 100,
                    ),
                    customContainer(textContent: "Hi, I’m Expleo Bard"),
                    const SizedBox(height: 15),
                    customContainer(
                        textContent: "😊 Welcome! How can I assist you?"),
                    const SizedBox(height: 15),
                    customContainer(
                        textContent:
                            "Welcome to flutter hero ask some thing  ❤️ "),
                  ],
                ),
              ],
            )),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 60,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    focusNode: myFocusNode,
                    controller: textField,
                    decoration: const InputDecoration(
                        hintText: "You can ask what you want",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                Obx(
                  () => controller.isLoading.value
                      ? Image.asset(
                          "assets/loading.gif",
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                              onPressed: () {
                                if (textField.text != "") {
                                  controller.sendPrompt(textField.text);
                                  textField.clear();
                                }
                                myFocusNode.unfocus();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                        ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget customContainer({required String textContent}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        textContent,
      ),
    );
  }

  Widget customContainerStyle({required String textContent}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        textContent,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

