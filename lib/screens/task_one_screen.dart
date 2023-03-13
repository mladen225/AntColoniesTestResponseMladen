import 'package:flutter/material.dart';
import 'package:ant_colonies_test_response_mladen/commons/settings.dart';
import 'package:ant_colonies_test_response_mladen/modules/tab_bar.dart';
import 'package:ant_colonies_test_response_mladen/modules/alerts.dart';
import 'package:dictionaryx/dictionary_reduced_sa.dart';

class TaskOneScreen extends StatefulWidget {
  const TaskOneScreen({Key? key}) : super(key: key);

  @override
  State<TaskOneScreen> createState() => _TaskOneScreen();
}

class _TaskOneScreen extends State<TaskOneScreen> {

  TextEditingController searchTextController = TextEditingController();
  TextEditingController addNewWordTextController = TextEditingController();
  TextEditingController addSynonymsTextController = TextEditingController();

  var dReducedSA = DictionaryReducedSA();

  Map<String, dynamic> _newDict = {};
  List<String> _addedSynonymsList = [];
  bool _addingSynonyms = false;
  String _newWord = '';

  void _synonymsSearchInit() {

    if (dReducedSA.hasEntry(searchTextController.text.toLowerCase()) || _newDict.containsKey(searchTextController.text.toLowerCase())) {

      List<String> synonymsList = [];

      if (dReducedSA.hasEntry(searchTextController.text.toLowerCase())) {

        var search = dReducedSA.getEntry(searchTextController.text.toLowerCase());
        synonymsList.addAll(search.synonyms);

      }

      if (_newDict.containsKey(searchTextController.text.toLowerCase())) {

        List newSynonymsList = _newDict[searchTextController.text.toLowerCase()]['S'];
        synonymsList.addAll(newSynonymsList.toList().cast());

      }

      Alerts.showAlertDialog(context, 'Search result:', '$synonymsList');

    } else {

      Alerts.showAlertDialog(context, 'Search result:', 'No matches');

    }

  }

  void _addNewWordInit() {

    if (dReducedSA.hasEntry(addNewWordTextController.text.toLowerCase()) || _newDict.containsKey(addNewWordTextController.text.toLowerCase())) {

      Alerts.showAlertDialog(context, 'Search result:', 'This word is already in the database');

    } else {

      setState(() {
        _addingSynonyms = true;
      });

      _newWord = addNewWordTextController.text.toLowerCase();

    }

  }

  void _addSynonymInit() {

    if (dReducedSA.hasEntry(addSynonymsTextController.text.toLowerCase())) {

    } else {


      Map<String, dynamic> subDict = {};

      _addedSynonymsList.add(addSynonymsTextController.text.toLowerCase());

      subDict['S'] = List.from(_addedSynonymsList);
      subDict['A'] = [];

      _newDict[_newWord] = subDict;

    }

  }

  void _doneButtonPressed() {

    setState(() {
      _addingSynonyms = false;
      _addedSynonymsList.clear();
    });

    FocusScope.of(context).unfocus();
    TextEditingController().clear();

    addNewWordTextController.clear();
    addSynonymsTextController.clear();

  }

  void _transitiveRule() {

    if (_newDict.isNotEmpty && _newDict.length > 1) {

      List<String> keyList = _newDict.keys.toList().cast();
      List<dynamic> valueList = _newDict.values.toList().cast();

      int nextRangeStart = 0;


      for (var i = 0; i < _newDict.length; i++) {

        nextRangeStart++;

        for (var j = nextRangeStart; j < _newDict.length; j++) {

          List<String> synonymList = valueList[i]['S'];

          for (var k = 0; k < synonymList.length; k++) {

            if (keyList[j] == synonymList[k]) {

              List<String> expandedList = List.from(_newDict[keyList[j]]['S']);
              expandedList.addAll(synonymList);

              setState(() {

                _newDict[keyList[i]]['S'] = expandedList;

              });

            }

          }

        }

      }

    }

  }

  Widget _constructTaskOneScreen() {
    return CustomScrollView(
      slivers: <Widget>[

        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 15,),

              const Text(
                'I added a db with 120000 word and almost 4000 of them are synonyms, in the imported DB the transitive rule does not apply. Just press the magnifying glass to trigger the search.',
                maxLines: 5,
                style: TextStyle(fontSize: 16, color: AppSettings.textColor),
              ),

              SizedBox(
                height: 48,
                child: TextField(
                  cursorColor: Colors.grey,
                  controller: searchTextController,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 14),
                  decoration: InputDecoration(

                      prefixIcon: GestureDetector(
                        onTap: () {

                          _synonymsSearchInit();

                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();

                          searchTextController.clear();

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
                      hintText: 'Search synonyms...',
                      fillColor: AppSettings.backgroundColor,
                      filled: true),
                ),
              ),

              const SizedBox(height: 5,),

              const Text(
                'Just press the plus to add the word and then all of its synonyms one at the time when you are done press the Done button. No permanent storage has been implemented so when you leave the screen all added items will be lost',
                maxLines: 5,
                style: TextStyle(fontSize: 16, color: AppSettings.textColor),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  (_addingSynonyms == false)
                      ?
                  SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width - 140,
                    child: TextField(
                      cursorColor: Colors.grey,
                      controller: addNewWordTextController,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 14),
                      decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            onTap: () {

                              _addNewWordInit();

                              FocusScope.of(context).unfocus();
                              TextEditingController().clear();

                              addNewWordTextController.clear();

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
                          hintText: 'Add new word...',
                          fillColor: AppSettings.backgroundColor,
                          filled: true),
                    ),
                  )
                      :
                  SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width - 140,
                    child: TextField(
                      cursorColor: Colors.grey,
                      controller: addSynonymsTextController,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 14),
                      decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            onTap: () {

                              _addSynonymInit();

                              FocusScope.of(context).unfocus();
                              TextEditingController().clear();

                              addSynonymsTextController.clear();

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
                          hintText: 'Add synonyms...',
                          fillColor: AppSettings.backgroundColor,
                          filled: true),
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

                      _doneButtonPressed();

                    },
                    splashColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: const BorderSide(
                            color: AppSettings.tealColor,
                            width: 2
                        )
                    ),
                    child: const Text('Done',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppSettings.tealColor)
                    ),
                  ),

                ],
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

                      _transitiveRule();

                    },
                    splashColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: const BorderSide(
                            color: AppSettings.tealColor,
                            width: 2
                        )
                    ),
                    child: const Text('Apply transitive rule',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppSettings.tealColor)
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 5,),

            ].map((e) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: e,
            ),
            ).toList(),
          ),
        ),

        SliverList(
          //key: centerKey,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  (index == 0)
                      ?
                  const Text('Added synonyms:',
                    maxLines: 1,
                    style: TextStyle(fontSize: 18, color: AppSettings.textColor, fontWeight: FontWeight.bold),
                  )
                      :
                  const SizedBox(height: 0,),

                  const SizedBox(height: 5,),

                  Text(
                    'New word: ${_newDict.keys.elementAt(index)}',
                    maxLines: 10,
                    style: const TextStyle(fontSize: 16, color: AppSettings.textColor),
                  ),
                  Text(
                    'Synonyms: ${_newDict[_newDict.keys.elementAt(index)]['S']}',
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
            childCount: _newDict.length,
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
          title: const Text('TASK ONE', style: TextStyle(fontSize: 24, color: AppSettings.textColor),),
          backgroundColor: AppSettings.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: _constructTaskOneScreen(),
        bottomNavigationBar: const MyTabBar(
          itemIndex: 0,
        ),
        backgroundColor: AppSettings.backgroundColor,
      ),
    );
  }

}