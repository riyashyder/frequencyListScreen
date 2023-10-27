import 'package:flutter/material.dart';
import 'package:frequency_list_screen/database_helper.dart';
import 'package:frequency_list_screen/main.dart';
import 'package:frequency_list_screen/navigation-drawer.dart';
import 'package:frequency_list_screen/task_model.dart';
import 'package:frequency_list_screen/taskformscreen.dart';

import 'edit_task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<TaskModel>_taskList;

  @override
  void initState(){
    super.initState();
    getAllTasks();
  }
  getAllTasks()async{
    _taskList=<TaskModel>[];

    var tasks = await dbHelper.queryAllRows(DatabaseHelper.taskTable);

    tasks.forEach((task) {
      print(task['_id']);
      print(task['task']);
      print(task['frequency']);
      print(task['priority']);
      print(task['status']);

      var taskModel =TaskModel(task['_id'], task['task'], task['frequency'], task['priority'], task['status']);

      setState(() {
        _taskList.add(taskModel);
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Task List'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: _taskList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0, right: 12.0, left: 12.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    onTap: () {
                      print('-------> Edit/Delete invoked');
                      print(_taskList[index].id);
                      print(_taskList[index].task);
                      print(_taskList[index].frequency);
                      print(_taskList[index].priority);
                      print(_taskList[index].status);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditTaskFormScreen(),
                          settings: RouteSettings(
                            arguments: _taskList[index],
                          )
                      ));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_taskList[index].task ?? 'No Data',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    subtitle: Text(_taskList[index].frequency,
                      style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskFormScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
