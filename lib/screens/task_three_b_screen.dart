import 'package:flutter/material.dart';
import 'package:ant_colonies_test_response_mladen/commons/settings.dart';
import 'package:ant_colonies_test_response_mladen/modules/tab_bar.dart';
import 'package:ant_colonies_test_response_mladen/modules/alerts.dart';
import 'dart:convert';

class TaskThreeBScreen extends StatefulWidget {
  const TaskThreeBScreen({Key? key}) : super(key: key);

  @override
  State<TaskThreeBScreen> createState() => _TaskThreeBScreen();
}

class _TaskThreeBScreen extends State<TaskThreeBScreen> {

  TextEditingController addTermsTextController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController addObjectTextController = TextEditingController();
  Map<String, dynamic> object = {};

  void _addStringToObject() {
    String textToDecode = '';
    textToDecode = addObjectTextController.text.replaceAll('(', '{');
    textToDecode = textToDecode.replaceAll(')', '}');
    textToDecode = textToDecode.replaceAll(' ', '"');
    textToDecode = textToDecode.replaceAll('\n', '');

    try {
      setState(() {
        object = json.decode(textToDecode);
      });
    } catch (e) {
      Alerts.showAlertDialog(
          context, 'Wrong format', 'You made a mistake in the text field.');
    }
  }

  _lookUp() {
    final validCharacters = RegExp(r'^[a-zA-Z0-9.]+$');

    String path = searchTextController.text;

    if (object.isEmpty) {
      Alerts.showAlertDialog(
          context, 'No object', 'You first need to create a object');
    } else if (!validCharacters.hasMatch(searchTextController.text)) {
      Alerts.showAlertDialog(context, 'Invalid characters',
          'Only letters and numbers are allowed');
    } else if (!path.contains('.')) {
      Alerts.showAlertDialog(context, 'Invalid path',
          'There has to be one dot in order fo connect the two properties.');
    } else {

      var tempObject = object[path.split('.')[0]];

      for (var i = 1; i < path.split('.').length; i++) {

        try {
          tempObject = tempObject[path.split('.')[i]];
        } catch (e) {
          print('ERROR $e');
        }

      }

      try {

        (tempObject.runtimeType == String)
            ?
        Alerts.showAlertDialog(context, 'Result:',
            '$tempObject')
        :
        Alerts.showAlertDialog(context, 'Wrong path', 'This path does not lead to a string');

      } catch (e) {
        print('ERROR $e');
      }

    }

    searchTextController.clear();
  }

  Widget _constructTaskThreeBScreen() {
    return Scrollbar(
      child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(minWidth: 100, minHeight: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 15,),

                const Text(
                  'Write a function that takes an object and a string, which represents an object lookup path, '
                      'for example "property1.property2".\nThe function should return the value on the specific '
                      'path.\nExample object = { property1: { property2: "Apple", property3: "Orange" } }\n\nIn this '
                      'version you are constructing an object by writing it into the designated text field.\n\nSince the '
                      'keyboard does not support curly brackets and its quotation marks are not accepted by Dart please use small '
                      'brackets "()" instead and spaces instead quotation marks.\n\nExample: ( Cars :( expensive : Mercedes , cheep : VW ), Planes :( Big : B747 , Fast : SR71 ))\n\nExample object = { "Cars": '
                      '{ "expensive": "Mercedes", "cheep": "VW" },  "Planes": { "Big": "B747", "Fast": "SR71"}\n\nBy pressing '
                      'the "Submit"  button you can add the object.\n\nOnly '
                      'numbers and letters are allowed also the maximum number of path component here is not limited to two.',
                  maxLines: 40,
                  style: TextStyle(fontSize: 16, color: AppSettings.textColor),
                ),

                SizedBox(
                  height: 148,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 40,
                  child: TextField(
                    maxLines: 10,
                    textInputAction: TextInputAction.done,
                    cursorColor: Colors.grey,
                    controller: addObjectTextController,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 14),
                    decoration: InputDecoration(

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
                        hintText: 'Add object...',
                        fillColor: AppSettings.backgroundColor,
                        filled: true),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    MaterialButton(
                      elevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      height: 48.0,
                      color: Colors.transparent,
                      textColor: Colors.white,
                      onPressed: () {
                        _addStringToObject();

                        FocusScope.of(context).unfocus();
                        TextEditingController().clear();
                      },
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          side: const BorderSide(
                              color: AppSettings.tealColor,
                              width: 2
                          )
                      ),
                      child: const Text('Submit',
                          style: TextStyle(
                              fontSize: 16,
                              color: AppSettings.tealColor)
                      ),
                    ),

                  ],
                ),

                Text(
                  'object = $object',
                  maxLines: 20,
                  style: const TextStyle(fontSize: 16, color: AppSettings.textColor),
                ),

                SizedBox(
                  height: 48,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 40,
                  child: TextField(
                    cursorColor: Colors.grey,
                    controller: searchTextController,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 14),
                    decoration: InputDecoration(

                        suffixIcon: GestureDetector(
                          onTap: () {

                            _lookUp();

                            FocusScope.of(context).unfocus();
                            TextEditingController().clear();
                          },
                          //onTap: _searchIconPressed,
                          child: const Icon(Icons.search),
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
                        hintText: 'Add path...',
                        fillColor: AppSettings.backgroundColor,
                        filled: true),
                  ),
                ),

              ].map((e) =>
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: e,
                  ),
              ).toList(),
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 52,
          title: const Text('TASK THREE B', style: TextStyle(
              fontSize: 24, color: AppSettings.textColor),),
          backgroundColor: AppSettings.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: _constructTaskThreeBScreen(),
        bottomNavigationBar: const MyTabBar(
          itemIndex: 3,
        ),
        backgroundColor: AppSettings.backgroundColor,
      ),
    );
  }

}