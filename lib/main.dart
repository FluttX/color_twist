import 'package:color_twist/app/app.dart';
import 'package:color_twist/app/app_services.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppServices.init();
  runApp(const ColorTwistApp());
}
