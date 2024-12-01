// ignore_for_file: must_call_super, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //controller for input filed
  final TextEditingController _controller = TextEditingController();
  //instace for stability ai for image generation
  final StabilityAI _ai = StabilityAI();
  //Api key for the AI Service
  final String apiKey = "sk-qq5lwYGa0HMiY1LSJoj5XHcY90Wltluuid5Bhda54bhKJ8z3";
  //set the style for  generated Image
  final ImageAIStyle imageAIStyle = ImageAIStyle.pencilDrawing;
  //Flag to check if image has generated
  bool isItem = false;
  //funcation to generate an image based in query
  Future<Uint8List> _generate(String query) async {
    Uint8List image = await _ai.generateImage(
        prompt: query, apiKey: apiKey, imageAIStyle: imageAIStyle);
    return image;
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text("Ai Image Generator"),
      ),
      body: Column(
        children: [
          Text(
            'Text To Image',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: TextField(
              //link the textfiled to controller
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Enter your text...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 7)),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: isItem
                  ? //check if image has been generated
                  FutureBuilder<Uint8List>(
                      future: _generate(_controller.text),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(snapshot.data!),
                          );
                        } else {
                          return Container();
                        }
                      })
                  : Center(
                      child: Text(
                        'No any image generated yet',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
          MaterialButton(
            color: Colors.white,
            onPressed: () {
              String query = _controller.text;
              if (query.isNotEmpty) {
                setState(() {
                  isItem = true;
                });
              } else {
                if (kDebugMode) {
                  print('Query is empty!');
                }
              }
            },
            child: Text(
              'Generate Image',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
