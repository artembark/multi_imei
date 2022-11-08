import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multi_imei/multi_imei.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String>? imeiList;
  final _multiImeiPlugin = MultiImei();
  String error = '';

  Future<void> initPlatformState() async {
    List<String>? platformVersion;
    try {
      platformVersion = await _multiImeiPlugin.getImeiList();
      error = '';
    } on PlatformException catch (e) {
      error = e.message.toString();
      platformVersion = null;
    }
    if (!mounted) return;

    setState(() {
      imeiList = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multiple IMEI get example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('IMEI list: $imeiList'),
            ),
            Center(
              child: Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await initPlatformState();
                },
                child: const Text('Update'))
          ],
        ),
      ),
    );
  }
}
