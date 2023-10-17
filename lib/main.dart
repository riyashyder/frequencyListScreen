import 'package:flutter/material.dart';
import 'package:frequency_list_screen/database_helper.dart';
import 'package:frequency_list_screen/frequency_list_screen.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.initialization();
  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FrequencyListScreen(),
    );
  }
}

