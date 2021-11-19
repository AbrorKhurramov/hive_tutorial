import 'package:hive/hive.dart';
import 'package:hive_tutorial/models/contact.dart';
class Boxes{
static Box<Contact> getContacts() => Hive.box<Contact>("contacts");
static Box<Transaction> getTransactions() => Hive.box<Transaction>("transactions");
}