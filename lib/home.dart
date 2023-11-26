import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:theseus/camera_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<CameraDescription> _cameras;
  late CameraController cameraController;

  FlutterTts flutterTts = FlutterTts();

  Future<CameraController> doCameraStuff() async {
    _cameras = await availableCameras();
    cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await cameraController.initialize();
    return cameraController;
  }

  Future queryModel() async {
    print("caemra controller $cameraController");
    print("but are we querying the model?");
    await Future.delayed(Duration(seconds: 5));
    await speak("taking picture");
    XFile image = await cameraController.takePicture();
    String b64 = base64.encode(await image.readAsBytes());
    const url = 'http://14a4-34-86-93-105.ngrok.io';
    Uri uri = Uri.parse(url);
    String model = "midas";
    model = "adabins";
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'b64': b64, "model": model});
    await Future.delayed(Duration(milliseconds: 1500));
    speak("sending data. please wait");
    await Future.delayed(Duration(milliseconds: 1500));
    final response = await http.post(uri, headers: headers, body: body);
    speak("data received");
    await Future.delayed(Duration(milliseconds: 1500));
    final output = jsonDecode(response.body);

    String depth = double.tryParse(output["depth"])!.toStringAsFixed(2);
    await Future.delayed(Duration(milliseconds: 1500));
    String command = output["command"];
    await speak("predicted depth is $depth meters. command is $command. wait 5 seconds for next capture");
    await Future.delayed(Duration(seconds: 5));
    queryModel();
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Theseus"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder<CameraController>(
                future: doCameraStuff(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    cameraController = snapshot.data!;
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.8,
                        child: CameraPreview(cameraController));
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  speak("Capture in 5 seconds");
                  await Future.delayed(const Duration(seconds: 5));
                  queryModel();
                },
                child: const Text("Get goin"),
              ),
            ],
          ),
        ));
  }
}
