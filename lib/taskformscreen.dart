import 'package:flutter/material.dart';
import 'package:frequency_list_screen/database_helper.dart';
import 'package:frequency_list_screen/main.dart';
import 'package:frequency_list_screen/task_list_screen.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  var taskcontroller = TextEditingController();

  var selectedFrequencyValue;

  String selectedPriority = 'High';

  bool statusDefaultValue = false;

  var frequencyDropDownList = <DropdownMenuItem>[];

  @override
  void initState() {
    super.initState();
    getAllFrequency();
  }

  getAllFrequency() async {
    var frequencies =
        await dbHelper.queryAllRows(DatabaseHelper.frequencyTable);

    frequencies.forEach((frequency) {
      setState(() {
        frequencyDropDownList.add(DropdownMenuItem(
          child: Text(frequency['frequency']),
          value: frequency['frequency'],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: taskcontroller,
                decoration:
                    InputDecoration(labelText: 'Task', hintText: 'Enter Task'),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField(
                      value: selectedFrequencyValue,
                      items: frequencyDropDownList,
                      hint: Text('Frequency'),
                      onChanged: (value) {
                        setState(() {
                          selectedFrequencyValue = value;
                          print(selectedFrequencyValue);
                        });
                      }),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Task Priority',
                    style: TextStyle(fontSize: 20),
                  ),
                  RadioListTile(
                      title: Text(
                        'High',
                        style: TextStyle(fontSize: 18),
                      ),
                      value: 'High',
                      groupValue: selectedPriority,
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value as String;
                          print('-------->Task Priority : $value');
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        'Low',
                        style: TextStyle(fontSize: 18),
                      ),
                      value: 'Low',
                      groupValue: selectedPriority,
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value as String;
                          print('--------.Task Priority : $value');
                        });
                      }),
                  SizedBox(
                    height: 40,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Checkbox(
                              value: this.statusDefaultValue,
                              onChanged: (value) {
                                setState(() {
                                  this.statusDefaultValue = value!;
                                  print('-------->Status  Checkbox : $value');
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print('------->TaskForm: Save');
                        save();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  save() async {
    String tempStatusValue = 'false';
    if (statusDefaultValue == true) {
      print('-------->Save Status - True');
      tempStatusValue = 'true';
    } else {
      print('-------->Save Status - false');
      tempStatusValue = 'false';
    }
    print('---------->Task: $taskcontroller.text');
    print('---------->Frequency: $selectedFrequencyValue');
    print('---------->Priority: $selectedPriority');
    print('---------->Status: $tempStatusValue');

    Map<String, dynamic> row = {
      DatabaseHelper.columnTask: taskcontroller.text,
      DatabaseHelper.columnFrequency: selectedFrequencyValue,
      DatabaseHelper.columnPriority: selectedPriority,
      DatabaseHelper.columnStatus: tempStatusValue,
    };
    final result = await dbHelper.insertData(row, DatabaseHelper.taskTable);
    debugPrint('----------->Inserted Row ID:$result');
    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');

      setState(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TaskListScreen()));
      });
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
