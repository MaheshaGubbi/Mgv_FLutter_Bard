/**
 * Created by Mahesh Gubbi on 24-11-2023.
 * Bengaluru.
 */
import 'dart:convert';

import 'package:expleobard/model/BardModel.dart';
import 'package:expleobard/utils/Constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxList historyList = RxList<BardModel>([
    // BardModel(system: "user", message: "What can you do for me"),
    // BardModel(system: "bard", message: "What can you do for me"),
  ]);

  RxBool isLoading = false.obs;
  void sendPrompt(String prompt) async {
    isLoading.value = true;
    var newHistory = BardModel(system: "user", message: prompt);
    historyList.add(newHistory);
    final body = {
      'prompt': {
        'text': prompt,
      },
    };

    final request = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=${Constants.APIKEY}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final response = jsonDecode(request.body);
    if (response != null) {
      if (response.containsKey("candidates")) {
        final bardReplay = response["candidates"][0]["output"];
        var newHistory2 = BardModel(system: "bard", message: bardReplay);
        historyList.add(newHistory2);
      } else {
        var newHistory2 =
            BardModel(system: "bard", message: "Api issue, try again");
        historyList.add(newHistory2);
      }
    }
    isLoading.value = false;
  }
}
