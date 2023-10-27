import 'package:flutter/material.dart';
import 'package:frequency_list_screen/database_helper.dart';

import 'frequency_model.dart';
import 'main.dart';

class FrequencyListScreen extends StatefulWidget {
  const FrequencyListScreen({super.key});

  @override
  State<FrequencyListScreen> createState() => _FrequencyListScreenState();
}

class _FrequencyListScreenState extends State<FrequencyListScreen> {
  var frequencyController = TextEditingController();
  late List<FrequencyModel> _frequencyList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllFrequency();
  }

  getAllFrequency() async {
    _frequencyList = <FrequencyModel>[];

    var frequencyTableData =
        await dbHelper.queryAllRows(DatabaseHelper.frequencyTable);

    frequencyTableData.forEach((frequency) {
      setState(() {
        print(frequency['_id']);
        print(frequency['frequency']);

        var frequencyModel =
            FrequencyModel(frequency['_id'], frequency['frequency']);

        _frequencyList.add(frequencyModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequency_list'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
          itemCount: _frequencyList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Card(
                elevation: 8,
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      print('------->Edit Record Id: $index');
                      _editFrequency(context, _frequencyList[index].id);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.deepPurple,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_frequencyList[index].frequency),
                      IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _frequencyList[index].id);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('----->Add invoked');
          showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    frequencyController.clear();
                  },
                  child: Text('cancel')),
              ElevatedButton(
                onPressed: () {
                  print('Frequency list---save Clicked');
                  print('frequency: ${frequencyController.text}');
                  _save();
                },
                child: Text('Save'),
              )
            ],
            title: Text('Frequency'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: frequencyController,
                    decoration: InputDecoration(hintText: 'Enter Frequency'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _save() async {
    print('save---->Frequency: $frequencyController.text');

    Map<String, dynamic> row = {
      DatabaseHelper.columnFrequency: frequencyController.text,
    };
    final result =
        await dbHelper.insertData(row, DatabaseHelper.frequencyTable);

    debugPrint('------>INSERTED ROW Id:$result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
      getAllFrequency();
    }
    frequencyController.clear();
  }

  _editFrequency(BuildContext context, frequencyId) async {
    print(frequencyId);
    var row =
        await dbHelper.readDataById(DatabaseHelper.frequencyTable, frequencyId);

    setState(() {
      frequencyController.text = row[0]['frequency'] ?? 'No Data';
    });
    _editFormDailog(context, frequencyId);
  }

  _editFormDailog(BuildContext context, frequencyId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('------->Cancel invoked');
                  Navigator.pop(context);
                  frequencyController.clear();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('------->update invoked');
                  print('Frequency: ${frequencyController.text}');
                  update(frequencyId);
                },
                child: const Text('Update'),
              ),
            ],
            title: const Text('Frequency'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: frequencyController,
                    decoration: InputDecoration(hintText: 'Enter Frequency'),
                  )
                ],
              ),
            ),
          );
        });
  }

  void update(int frequencyId) async {
    print('update---->Frequency: $frequencyController.text');
    print('update---->Frequency Id:$frequencyId');

    Map<String, dynamic> row = {
      DatabaseHelper.columnFrequency: frequencyController.text,
      DatabaseHelper.columnID: frequencyId,
    };
    final result =
        await dbHelper.updateData(row, DatabaseHelper.frequencyTable);
    debugPrint('------>Updated Row Id : $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'updated');
      getAllFrequency();
    }
    frequencyController.clear();
  }

  _deleteFormDialog(BuildContext context, frequencyId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    print('------->Delete Invoked');
                    final result = await dbHelper.deleteData(
                        frequencyId, DatabaseHelper.frequencyTable);
                    debugPrint('Deleted Row Id:$result');
                    if (result > 0) {
                      Navigator.pop(context);
                      _showSuccessSnackBar(context, 'Deleted');
                    }
                    setState(() {
                      _frequencyList.clear();
                      getAllFrequency();
                    });
                  },
                  child: Text('Delete'))
            ],
            title: Text('Are you sure you want to delete this'),
          );
        });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
