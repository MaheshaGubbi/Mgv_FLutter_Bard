import 'package:expleobard/controller/HomeController.dart';
import 'package:expleobard/utils/Constants.dart';
import 'package:flutter/material.dart';

/**
 * Created by Mahesh Gubbi on 24-11-2023.
 * Bengaluru.
 */

class BardQueryWidget extends StatefulWidget {
  final String system;
  final String message;
  final HomeController controller;

  const BardQueryWidget({
    Key? key,
    required this.system,
    required this.message,
    required this.controller,
  }) : super(key: key);

  @override
  _BardQueryWidgetState createState() => _BardQueryWidgetState();
}

class _BardQueryWidgetState extends State<BardQueryWidget> {
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
                          if (_controller.text.isNotEmpty) {
                            isEditing = false;
                            widget.controller.sendPrompt(_controller.text);
                          }
                          _controller.text = widget.message;
                        });
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
                if (widget.controller.isLoading.value) {
                  Constants.showCustomToast(context, 'Please wait');
                } else {
                  setState(() {
                    isEditing = !isEditing;
                    if (!isEditing) {
                      if (_controller.text.isNotEmpty) {
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
