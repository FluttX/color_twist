import 'package:color_twist/app/app.dart';
import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/services/audio_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppServices.init();

  final musicPath = await AppServices.instance.storeService.loadMusicTrackPath();
  final audioService = AudioService();
  await audioService.initialize();
  audioService.playBackgroundMusic(musicPath);

  runApp(const ColorTwistApp());
}
