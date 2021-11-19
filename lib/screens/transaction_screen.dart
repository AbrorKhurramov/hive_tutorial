import 'package:flutter/material.dart';
import 'package:hive_tutorial/Boxes.dart';
import 'package:hive_tutorial/dialogs/transaction_dialog.dart';
import 'package:hive_tutorial/models/contact.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Transaction> transactions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Page"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Boxes.getTransactions().listenable(),
        builder: (context,box, _){
          final transactions = box.values.toList().cast<Transaction>();
          return buildContent(transactions);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => TransactionDialog(
            onClickedDone: addTransaction,
          ),
        ),
      ),
    );
  }

  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          "No transactions yet",
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Transactions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
              child: ListView.builder(
                  itemCount: transactions.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    final transaction = transactions[index];
                    return buildTransaction(context, transaction);
                  }))
        ],
      );
    }
  }
  Widget buildTransaction(BuildContext context, Transaction transaction) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          transaction.name,
          maxLines: 2,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        subtitle: Text(transaction.amount),
        children: [
          buildButtons(context, transaction),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
    children: [
      Expanded(
          child: TextButton.icon(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => TransactionDialog(
                    transaction: transaction,
                    onClickedDone: (name, amount) =>
                        editTransaction(transaction, name, amount),
                  )),
              icon: Icon(Icons.edit),
              label: Text("Edit"))),
      Expanded(
        child: TextButton.icon(
            onPressed: () => deleteTransaction(transaction),
            icon: Icon(Icons.delete),
            label: Text("delete")),
      ),
    ],
  );

  Future addTransaction(String name, String amount) async {
    final transaction = Transaction()
      ..name = name
      ..amount = amount;

    final box = Boxes.getTransactions();
    box.add(transaction);
  }

  void editTransaction(Transaction transaction, String name, String amount) {
    transaction.name = name;
    transaction.amount = amount;
    transaction.save();
  }

  void deleteTransaction(Transaction transaction) {
    transaction.delete();
  }}
