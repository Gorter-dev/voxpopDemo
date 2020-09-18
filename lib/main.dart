import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AudioPlayer audioPlayer = AudioPlayer();
  var recorder;
  Directory tmpDir;
  bool recording = false;
  @override
  void initState() {
    () async {
      tmpDir = await getTemporaryDirectory();
      File("${tmpDir.path}/recording.m4a").delete();
      await FlutterAudioRecorder.hasPermissions;
      recorder = FlutterAudioRecorder("${tmpDir.path}/recording.m4a",
          audioFormat: AudioFormat.AAC); // .wav .aac .m4a
      await recorder.initialized;
    }();
    super.initState();
  }

  startRecording() async {
    setState(() {
      recording = true;
    });
    await recorder.start();
    await recorder.current(channel: 0);
  }

  stopRecording() async {
    setState(() {
      recording = false;
    });
    await recorder.stop();
  }

  Future playRecording() async {
    String finalRecording = "${tmpDir.path}/recording.m4a";
    setState(() {
      audioPlayer.play(finalRecording, isLocal: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Material(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: recording == false ? startRecording : stopRecording,
              child: Text(recording == false ? "Record" : "Stop"),
            ),
            MaterialButton(
              onPressed: playRecording,
              child: Text('Play audio'),
            )
          ],
        ),
      ),
    );
  }
}
