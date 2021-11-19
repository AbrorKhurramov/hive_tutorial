import 'package:flutter/material.dart';
import 'package:hive_tutorial/models/contact.dart';

class ContactDialog extends StatefulWidget {
  final Contact? contact;
  final Function(String name, String number) onClickedDone;

  const ContactDialog({Key? key, this.contact, required this.onClickedDone})
      : super(key: key);

  @override
  _ContactDialogState createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      final contact = widget.contact;
      nameController.text = contact!.name;
      numberController.text = contact.number;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
//
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    final title = isEditing ? 'Edit Contact' : 'Add Contact';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildNumber(),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() =>
      TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
        name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildNumber() =>
      TextFormField(
        controller: numberController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Number',
        ),
        keyboardType: TextInputType.phone,
        validator: (number) =>
        number != null && number.isEmpty ? 'Enter a number' : null,
      );

  Widget buildCancelButton(BuildContext context) =>
      TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final number = numberController.text;

          widget.onClickedDone(name, number);

          Navigator.of(context).pop();
        }
      },
    );
  }
}