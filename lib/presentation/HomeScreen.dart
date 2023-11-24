/**
 * Created by Mahesh Gubbi on 24-11-2023.
 * Bengaluru.
 */

import 'package:expleobard/controller/HomeController.dart';
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
        leading:
        GestureDetector(
          onTap: (){
            controller.isLoading.value ? showCustomToast(context, 'Please wait'): controller.sendPrompt("Look something about Expleo");
          },
          child: SvgPicture.asset(
            "assets/expleo.svg",color: const Color(0xff7044c4),
          ),
        ),
        title: const Text(
          "EXPLEO BARD",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        actions: [

          GestureDetector(
            onTap: (){
              controller.isLoading.value ? showCustomToast(context, 'Please wait'): controller.sendPrompt("About Bard");

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
                  reverse:  true,
                  children: [

                    Obx(() => Column(
                      children: controller.historyList
                          .map(
                            (e) => ChatMessageWidget(
                          system: e.system,
                          message: e.message,
                          controller: controller,
                        ),
                      )
                          .toList(),
                    )),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          const Text("Welcome to flutter hero ask some thing  ❤️ "),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        SvgPicture.asset(
                          "assets/expleo.svg",color: const Color(0xff7044c4),
                          height: 100,
                        ),
                        Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("Hi, I’m Expleo Bard",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        ),

                        const SizedBox(height: 15),
                        customContainer(textContent: "😊 Welcome! How can I assist you?"),
                      ],
                    ),
                  ],
                )
            ),

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
                      () =>
                  controller.isLoading.value ?
                  Image.asset(
                    "assets/loading.gif",
                  ) : Padding(
                    padding: const EdgeInsets.only(right:8.0),
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


  Widget customContainer( {required String textContent} ) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        textContent,
        style: const TextStyle(
          // Add any specific text styling here if needed
        ),
      ),
    );
  }
}

void showCustomToast(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 1),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class ChatMessageWidget extends StatefulWidget {
  final String system;
  final String message;
  final HomeController controller;

  const ChatMessageWidget({
    Key? key,
    required this.system,
    required this.message,
    required this.controller,
  }) : super(key: key);

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  late TextEditingController _controller;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.system == "user" ? "👨‍💻" : "🤖"),

          const SizedBox(width: 10),
          widget.system == "user"
              ? Expanded(
            child: SizedBox(
              height: 25,
              child: TextFormField(
                controller: _controller,
                enabled: isEditing,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none, // Remove the underline
                ),
                onFieldSubmitted: (newValue) {
                  setState(() {
                    if(_controller.text.isNotEmpty){
                      isEditing = false;
                      widget.controller.sendPrompt(_controller.text);
                    }
                    _controller.text = widget.message;

                  });

                  print("Edited message: $newValue");
                },
              ),
            ),
          )
              : Flexible(
            child: Text(widget.message),
          ),

          if (widget.system == "user")
            GestureDetector(
              onTap: () {
                if(widget.controller.isLoading.value ){
                  showCustomToast(context, 'Please wait');
                }else{
                  setState(() {
                    isEditing = !isEditing;
                    if (!isEditing) {
                      if(_controller.text.isNotEmpty){
                        isEditing = false;
                        widget.controller.sendPrompt(_controller.text);
                      }
                      _controller.text = widget.message;

                    }
                  });
                }

              },
              child: isEditing ? Icon(Icons.done) : Icon(Icons.edit),
            ),
        ],
      ),
    );
  }
}

