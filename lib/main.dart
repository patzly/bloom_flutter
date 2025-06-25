import 'dart:io';

import 'package:bloom_flutter/bloom_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

void main() {
  if (!kIsWeb && Platform.isAndroid) {
    FlutterForegroundTask.initCommunicationPort();
  }
  runApp(const BloomApp());
}