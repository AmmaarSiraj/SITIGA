import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../main_screen.dart';
import '../providers/data_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoFinished = false;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // 1. Start loading video
    _controller = VideoPlayerController.asset('assets/video/splash.mp4');
    await _controller.initialize();
    _controller.setVolume(0.0);
    _controller.play();

    // 2. Load data while video is playing
    _loadInitialData();

    // 3. Listen video finish
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          _controller.value.isInitialized &&
          !_controller.value.isPlaying &&
          !_isVideoFinished) {
        _isVideoFinished = true;
        _tryNavigate();
      }
    });

    setState(() {}); // Trigger rebuild once video ready
  }

  Future<void> _loadInitialData() async {
  try {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.preloadMinimalData();
  } catch (e) {
    print("Error loading minimal data: $e");
  } finally {
    _isDataLoaded = true;
    _tryNavigate();
  }
}


  void _tryNavigate() {
    if (_isDataLoaded && _isVideoFinished && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? ClipRect(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
