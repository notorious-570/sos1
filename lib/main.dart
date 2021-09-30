import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import 'FormScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'SOS';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: FormScreen(),
      );
}

