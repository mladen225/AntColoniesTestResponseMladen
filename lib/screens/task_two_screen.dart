import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ant_colonies_test_response_mladen/commons/settings.dart';
import 'package:ant_colonies_test_response_mladen/modules/tab_bar.dart';
import 'package:ant_colonies_test_response_mladen/modules/alerts.dart';
import 'dart:math';

class TaskTwoScreen extends StatefulWidget {
  const TaskTwoScreen({Key? key}) : super(key: key);

  @override
  State<TaskTwoScreen> createState() => _TaskTwoScreen();
}

class _TaskTwoScreen extends State<TaskTwoScreen> {

  TextEditingController structNumberTextController = TextEditingController();

  final List<dynamic> _randomStructList = [];
  String _solutionString = '';

  void _generateRandomNumber() {

    if (structNumberTextController.text != '' && int.tryParse(structNumberTextController.text) != null) {

      Random random = Random();

      for (var i = 0; i < int.parse(structNumberTextController.text); i++) {

        Map<String, dynamic> randomStruct = {};

        randomStruct['id'] = i;

        randomStruct['value'] = random.nextInt(10);

        setState(() {
          _randomStructList.add(randomStruct);
        });

      }

    } else {

      Alerts.showAlertDialog(context, 'Text field empty', 'Put the number of pairs you want Text field empty');

    }

  }

  void _solutionPressed() {

    int smallestDuplicatePosition = -1;
    int smallestDuplicate = -1;
    int nextRangeStart = 1;

    for (var i = 0; i < _randomStructList.length; i++) {

      for (var j = nextRangeStart; j < _randomStructList.length; j++) {

        if (_randomStructList[i]['value'] == _randomStructList[j]['value']) {

          smallestDuplicatePosition = j;
          smallestDuplicate = _randomStructList[j]['value'];

        }

      }

      nextRangeStart++;

    }

    int increment = 1;

    for (var i = 0; i < _randomStructList.length; i++) {

      if (smallestDuplicate + increment == _randomStructList[i]['value']) {

        increment++;

      }

    }

    Map<String, dynamic> solution = {
      'id' : _randomStructList.length,
      'value' : smallestDuplicate + increment
    };

    setState(() {
      _solutionString = 'Solution: $solution';
    });

  }

  Widget _constructTaskTwoScreen() {
    return CustomScrollView(
        slivers: <Widget>[

          SliverToBoxAdapter(
            child: Column(
              children: [

                const SizedBox(height: 15,),

                const Text(
                  'For a random array of structs of type {id, value }, return a new struct, with an unique id and a value such as the next positive integer, which is not present in the existing structure list and with at least one smaller integer appearing at least twice in the same list.',
                  maxLines: 6,
                  style: TextStyle(fontSize: 16, color: AppSettings.textColor),
                ),

                SizedBox(
                  height: 48,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.grey,
                    controller: structNumberTextController,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 14),
                    decoration: InputDecoration(

                        suffixIcon: GestureDetector(
                          onTap: () {
                            _generateRandomNumber();

                            FocusScope.of(context).unfocus();
                            TextEditingController().clear();

                          },
                          child: const Icon(Icons.verified),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide:
                          const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide:
                          const BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Enter number of structs',
                        fillColor: AppSettings.backgroundColor,
                        filled: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),

              ].map((e) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: e,
              ),
              ).toList(),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    (index == 0)
                        ?
                    const Text('Random struct list:',
                      maxLines: 1,
                      style: TextStyle(fontSize: 18, color: AppSettings.textColor, fontWeight: FontWeight.bold),
                    )
                        :
                    const SizedBox(height: 0,),

                    (index == _randomStructList.length)
                        ?
                    MaterialButton(
                      elevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      height: 36.0,
                      minWidth: 200,
                      color: Colors.transparent,
                      textColor: Colors.white,
                      onPressed: () {

                        _solutionPressed();

                      },
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          side: const BorderSide(
                              color: AppSettings.tealColor,
                              width: 2
                          )
                      ),
                      child: const Text('Solution',
                          style: TextStyle(
                              fontSize: 16,
                              color: AppSettings.tealColor)
                      ),
                    )
                        :
                    const SizedBox(height: 0,),

                    const SizedBox(height: 5,),

                    (index == _randomStructList.length)
                        ?
                    Text(
                      _solutionString,
                      maxLines: 10,
                      style: const TextStyle(fontSize: 16, color: AppSettings.textColor),
                    )
                        :
                    Text(
                      'Struct $index: ${_randomStructList[index]}',
                      maxLines: 10,
                      style: const TextStyle(fontSize: 16, color: AppSettings.textColor),
                    ),
                    const SizedBox(height: 5,),

                  ].map((e) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: e,
                  ),
                  ).toList(),
                );
              },
              childCount: (_randomStructList.isEmpty) ? 0 : _randomStructList.length + 1,
            ),
          ),

        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 52,
          title: const Text('TASK TWO', style: TextStyle(fontSize: 24, color: AppSettings.textColor),),
          backgroundColor: AppSettings.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: _constructTaskTwoScreen(),
        bottomNavigationBar: const MyTabBar(
          itemIndex: 1,
        ),
        backgroundColor: AppSettings.backgroundColor,
      ),
    );
  }

}