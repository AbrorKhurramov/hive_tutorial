import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_tutorial/Boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_tutorial/dialogs/contact_dialog.dart';
import 'package:hive_tutorial/models/contact.dart';
import 'package:hive_tutorial/screens/transaction_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Hive Tutorial"),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Contact>>(
          valueListenable: Boxes.getContacts().listenable(),
          builder: (context, box, _) {
            final contacts = box.values.toList().cast<Contact>();
            return buildContent(contacts);
          },
        ),
        floatingActionButton:
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => ContactDialog(
                  onClickedDone: addContact,
                ),
              ),
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              child: Icon(Icons.arrow_forward_ios),
              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>TransactionScreen()))
            ),
          ],
        ),

      );

  Widget buildContent(List<Contact> contacts) {
    if (contacts.isEmpty) {
      return Center(
        child: Text(
          "No contacts yet",
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Contacts',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
              child: ListView.builder(
                  itemCount: contacts.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    final contact = contacts[index];
                    return buildContact(context, contact);
                  }))
        ],
      );
    }
  }

  Widget buildContact(BuildContext context, Contact contact) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          contact.name,
          maxLines: 2,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        subtitle: Text(contact.number),
        children: [
          buildButtons(context, contact),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Contact contact) => Row(
        children: [
          Expanded(
              child: TextButton.icon(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ContactDialog(
                            contact: contact,
                            onClickedDone: (name, number) =>
                                editContact(contact, name, number),
                          )),
                  icon: Icon(Icons.edit),
                  label: Text("Edit"))),
          Expanded(
            child: TextButton.icon(
                onPressed: () => deleteContact(contact),
                icon: Icon(Icons.delete),
                label: Text("delete")),
          ),
        ],
      );

  Future addContact(String name, String number) async {
    final contact = Contact()
      ..name = name
      ..number = number;

    final box = Boxes.getContacts();
    box.add(contact);
  }

  void editContact(Contact contact, String name, String number) {
    contact.name = name;
    contact.number = number;
    contact.save();
  }

  void deleteContact(Contact contact) {
    contact.delete();
  }
}
