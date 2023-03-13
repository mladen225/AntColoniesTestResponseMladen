import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ant_colonies_test_response_mladen/commons/settings.dart';
import 'package:ant_colonies_test_response_mladen/modules/tab_bar.dart';
import 'package:ant_colonies_test_response_mladen/modules/alerts.dart';

class TaskThreeAScreen extends StatefulWidget {
  const TaskThreeAScreen({Key? key}) : super(key: key);

  @override
  State<TaskThreeAScreen> createState() => _TaskThreeAScreen();
}

class _TaskThreeAScreen extends State<TaskThreeAScreen> {

  TextEditingController addTermsTextController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  Map<String, dynamic> object = {};
  int _propertyCounter = 2;
  int _objectCounter = 1;
  bool _newObject = true;

  _addTermsToProperty() {

    if (addTermsTextController.text.isNotEmpty) {

      Map<String, dynamic> property = {};

      setState(() {

        if (_newObject == false) {

          property = object['property$_objectCounter'];

        }

        property['property$_propertyCounter'] = addTermsTextController.text;

        object['property$_objectCounter'] = property;

        _newObject = false;

        _propertyCounter++;

        addTermsTextController.clear();

      });

    }

  }

  _addPropertyToObject() {

    if (object.isNotEmpty && _newObject == false) {

      setState(() {

        _objectCounter = _propertyCounter;

        _propertyCounter++;

        _newObject = true;

      });

    }

  }

  _lookUp() {

    final validCharacters = RegExp(r'^[a-zA-Z0-9.]+$');

    String path = searchTextController.text;

    if (object.isEmpty) {

      Alerts.showAlertDialog(context, 'No object', 'You first need to create a object');

    } else if (!validCharacters.hasMatch(searchTextController.text)) {

      Alerts.showAlertDialog(context, 'Invalid characters', 'Only letters and numbers are allowed');

    } else if (!path.contains('.')) {

      Alerts.showAlertDialog(context, 'Invalid path', 'There has to be one dot in order fo connect the two properties.');

    } else if (path.split('.').length != 2) {

      Alerts.showAlertDialog(context, 'Invalid path', 'There can be only two properties in the path.');

    } else if (int.tryParse(path.split('.')[0].characters.last) == null
        || int.tryParse(path.split('.')[1].characters.last) == null
        || !path.split('.')[0].contains('property')
        || !path.split('.')[1].contains('property')){

      Alerts.showAlertDialog(context, 'Invalid name', 'Names are property1, property2 etc');

    } else if (object[path.split('.')[0]][path.split('.')[1]].runtimeType != String) {

      Alerts.showAlertDialog(context, 'Wrong path', 'This path does not lead to a string');

    } else {

      Alerts.showAlertDialog(context, 'Result:', '${object[path.split('.')[0]][path.split('.')[1]]}');

    }

    searchTextController.clear();

  }

  Widget _constructTaskThreeAScreen() {
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
                'path.\nExample '
                 'object = { property1: { property2: "Apple", property3: "Orange" } }\n\nIn this version '
                 'you are constructing a specific object using predefined methods\n\nYou can add terms '
                'to the "property1" by writing into the text field and pressing the + button.\nBy pressing '
                'the "Next"  button you can add another sub object.\nExample object = { property1: '
                '{ property2: "Apple", property3: "Orange" },  property4: { property5: "Juice", property6: "Banana"}\n\nOnly '
                 'numbers and letters are allowed.',
                maxLines: 30,
                style: TextStyle(fontSize: 16, color: AppSettings.textColor),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width - 140,
                    child: TextField(
                      keyboardType: TextInputType.streetAddress,
                      cursorColor: Colors.grey,
                      controller: addTermsTextController,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 14),
                      decoration: InputDecoration(

                          prefixIcon: GestureDetector(
                            onTap: () {

                              _addTermsToProperty();

                              FocusScope.of(context).unfocus();
                              TextEditingController().clear();


                            },
                            child: const Icon(Icons.add),
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
                          hintText: 'Add words...',
                          fillColor: AppSettings.backgroundColor,
                          filled: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                      ],
                    ),
                  ),

                  MaterialButton(
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    height: 48.0,
                    color: Colors.transparent,
                    textColor: Colors.white,
                    onPressed: () {

                      _addPropertyToObject();

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
                    child: const Text('Next',
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
                width: MediaQuery.of(context).size.width - 40,
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

            ].map((e) => Padding(
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
            const SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 52,
          title: const Text('TASK THREE A', style: TextStyle(fontSize: 24, color: AppSettings.textColor),),
          backgroundColor: AppSettings.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: _constructTaskThreeAScreen(),
        bottomNavigationBar: const MyTabBar(
          itemIndex: 2,
        ),
        backgroundColor: AppSettings.backgroundColor,
      ),
    );
  }

}