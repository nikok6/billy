import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:splitbill/screens/take_picture_screen.dart';

Future<CameraDescription> fetchCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    return firstCamera;
}

class InitializeCamera extends StatefulWidget {
  const InitializeCamera({super.key, required this.socialId});

  final String socialId;

  @override
  State<InitializeCamera> createState() => _InitializeCameraState();
}

class _InitializeCameraState extends State<InitializeCamera> {
  late Future<CameraDescription> futureCamera;
  @override
  void initState() {
    super.initState();
    futureCamera = fetchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraDescription>(
                      future: futureCamera,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return TakePictureScreen(camera: snapshot.data!, socialId: widget.socialId);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        //replace with fake data
                        return const Center(child: CircularProgressIndicator());
  }
    );
}
}