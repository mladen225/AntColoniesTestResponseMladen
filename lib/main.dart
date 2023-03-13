import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ant_colonies_test_response_mladen/screens/task_one_screen.dart';

void main() {
  runApp(const AntColoniesTestResponseMladen());
}

class AntColoniesTestResponseMladen extends StatelessWidget {
  const AntColoniesTestResponseMladen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'AntColoniesTestResponseMladen',
      theme: ThemeData(),
      home: const TaskOneScreen(),
    );
  }
}