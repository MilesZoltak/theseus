import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  final Function callback;
  const CameraView(this.callback, {super.key});

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> {
  late List<CameraDescription> _cameras;
  late CameraController cameraController;

  Future<CameraController> doCameraStuff() async {
    _cameras = await availableCameras();
    cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await cameraController.initialize();
    return cameraController;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraController>(
      future: doCameraStuff(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          cameraController = snapshot.data!;
          widget.callback(cameraController);
          return Container(
              height: MediaQuery.of(context).size.height / 1.8,
              child: CameraPreview(cameraController));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
