import 'package:flutter/material.dart';
import 'di/service_locator.dart' as di;
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const BookMyEventApp());
}
