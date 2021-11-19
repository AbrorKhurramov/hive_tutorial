import 'package:flutter/material.dart';
import 'package:hive_tutorial/models/contact.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(String name, String amount) onClickedDone;

  const TransactionDialog({Key? key, this.transaction, required this.onClickedDone})
      : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final contact = widget.transaction;
      nameController.text = contact!.name;
      amountController.text = contact.amount;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
//
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';

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
              buildAmount(),
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
          hintText: 'Enter Name of Transaction',
        ),
        validator: (name) =>
        name != null && name.isEmpty ? 'Enter a name of transaction' : null,
      );

  Widget buildAmount() =>
      TextFormField(
        controller: amountController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter amount',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) =>
        amount != null && amount.isEmpty ? 'Enter an amount' : null,
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
          final amount = amountController.text;

          widget.onClickedDone(name, amount);

          Navigator.of(context).pop();
        }
      },
    );
  }
}