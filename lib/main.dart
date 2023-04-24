import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GenImgScreen(),
    );
  }
}

class GenImgScreen extends StatefulWidget {
  const GenImgScreen({Key? key}) : super(key: key);

  @override
  State<GenImgScreen> createState() => _GenImgScreenState();
}

class _GenImgScreenState extends State<GenImgScreen> {
  String img = "";
  late OpenAI openAI;
  StreamSubscription? subscription;

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: token,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 6)),
        isLog: true);
    super.initState();
  }

  void _generateImage() async {
    const prompt = "3d, music, robot, music, machines, sci-fi, cinematic, 8k";

    final request = GenerateImage(prompt, 1,
        size: ImageSize.size256, responseFormat: Format.url);
    final response = await openAI.generateImage(request);
    setState(() {
      img = "${response?.data?.last?.url}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: () => _generateImage(),
                  child: const Text("Generate Image"))),
          img == ""
              ? const Text("Loading...")
              : AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(img),
          )
        ],
      ),
    );
  }
}