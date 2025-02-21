import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'analysis_screen.dart';
import 'loading_analysis_screen.dart';
import 'mypage_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  double _currentZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoomCamera(double zoom) async {
    final maxZoom = await _controller.getMaxZoomLevel();
    final minZoom = await _controller.getMinZoomLevel();
    setState(() {
      _currentZoom = zoom.clamp(minZoom, maxZoom);
    });
    _controller.setZoomLevel(_currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("카메라", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: false,
        backgroundColor: Colors.black,),

      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(_controller),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow, width: 1.5),
                  ),
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () => _zoomCamera(_currentZoom - 0.1),
                ),
                Expanded(
                  child: Slider(
                    activeColor: Colors.white,
                    min: 1.0,
                    max: 8.0,
                    value: _currentZoom,
                    onChanged: (value) => _zoomCamera(value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _zoomCamera(_currentZoom + 0.1),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () async {
                try {
                  final image = await _controller.takePicture();
                  if (!mounted) return;
                  // 캡처한 이미지 사용 (추후 기능 추가 예정)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(imagePath: image.path),
                    ),
                  );
                } catch (e) {
                  print("Error taking picture: $e");
                }
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
