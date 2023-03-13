import 'package:flutter/material.dart';

import 'package:ant_colonies_test_response_mladen/commons/settings.dart';

import 'package:ant_colonies_test_response_mladen/screens/task_one_screen.dart';
import 'package:ant_colonies_test_response_mladen/screens/task_two_screen.dart';
import 'package:ant_colonies_test_response_mladen/screens/task_three_a_screen.dart';
import 'package:ant_colonies_test_response_mladen/screens/task_three_b_screen.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({Key? key,
    required this.itemIndex,
  }) : super(key: key);

  final int itemIndex;

  @override
  State<MyTabBar> createState() => _MyTabBar();
}

class _MyTabBar extends State<MyTabBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (currentIndex) {
        setState(() {

          switch (currentIndex) {
            case 0:

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const TaskOneScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );

              break;
            case 1:

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const TaskTwoScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );

              break;
            case 2:

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const TaskThreeAScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );

              break;
            case 3:

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const TaskThreeBScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );

              break;
            default:
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const TaskOneScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
          }
        });
      },
      currentIndex: widget.itemIndex,
      backgroundColor: AppSettings.backgroundColor,
      unselectedItemColor: Colors.grey,
      selectedItemColor: AppSettings.tealColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.looks_one_rounded),
          label: 'Task 1',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.looks_two_rounded),
          label: 'Task 2',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.looks_3_rounded),
          label: 'Task 3 A',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.looks_3_rounded),
          label: 'Task 3 B',
        ),

      ],

    );
  }
}