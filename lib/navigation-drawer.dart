import 'package:flutter/material.dart';
import 'package:frequency_list_screen/frequency_list_screen.dart';
import 'package:frequency_list_screen/task_list_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'Task',
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                'version 1.0',
                style: TextStyle(fontSize: 15),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/task_list.jpg'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Task List'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TaskListScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list_rounded),
              title: Text('Frequency List'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FrequencyListScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
