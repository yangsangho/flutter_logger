import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Logger.debug("debug message!!");
              },
              child: const Text("debug"),
            ),
            ElevatedButton(
              onPressed: () {
                Logger.api("api message!!");
              },
              child: const Text("api"),
            ),
            ElevatedButton(
              onPressed: () {
                Logger.info("info message!!");
              },
              child: const Text("info"),
            ),
            ElevatedButton(
              onPressed: () {
                Logger.warn("warn message!!");
              },
              child: const Text("warn"),
            ),
            ElevatedButton(
              onPressed: () {
                Logger.error("error message!!");
              },
              child: const Text("error"),
            ),
          ],
        ),
      ),
    );
  }
}
