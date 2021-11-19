import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_tutorial/models/contact.dart';
import 'package:hive_tutorial/screens/contact_screen.dart';

List<Box> boxList = [];
Future<List<Box>> _openBox() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Box<Contact> box_session = await Hive.openBox<Contact>("contacts");
  Box<Transaction> box_comment = await Hive.openBox<Transaction>("transactions");
  boxList.add(box_session);
  boxList.add(box_comment);
  return boxList;
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _openBox();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hive Tutorial",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ContactScreen(),

    );
  }
}

