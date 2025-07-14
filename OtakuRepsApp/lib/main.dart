
// OtakuReps - Anime-themed Push-up & Pull-up Counter with Camera, Voice, and Character

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(OtakuRepsApp());
}

class OtakuRepsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OtakuReps',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoMonoTextTheme(),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _reps = 0;
  String _animeCharacter = 'Goku';
  List<String> _characters = ['Goku', 'Saitama', 'Luffy', 'Levi', 'Gojo'];
  FlutterTts flutterTts = FlutterTts();
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _controller = CameraController(
      cameras![1], // front camera
      ResolutionPreset.medium,
    );
    await _controller!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _incrementReps() {
    setState(() {
      _reps++;
    });
    _speak("$_animeCharacter says: That's $_reps!");
  }

  Widget _getAnimeImage(String character) {
    String assetPath = 'assets/$character.png';
    return Image.asset(assetPath, height: 200);
  }

  @override
  void dispose() {
    _controller?.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Anime Character: $_animeCharacter',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            DropdownButton<String>(
              value: _animeCharacter,
              dropdownColor: Colors.deepPurple,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _animeCharacter = value!;
                });
              },
              items: _characters.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _getAnimeImage(_animeCharacter),
            SizedBox(height: 10),
            Text(
              'Reps: $_reps',
              style: TextStyle(color: Colors.greenAccent, fontSize: 40),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _incrementReps,
              child: Text('Do a Rep!', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            _isCameraInitialized
                ? SizedBox(
                    height: 150,
                    width: 200,
                    child: CameraPreview(_controller!),
                  )
                : CircularProgressIndicator(color: Colors.purpleAccent),
          ],
        ),
      ),
    );
  }
}
