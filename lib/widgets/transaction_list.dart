import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  void _startDeleteTx(BuildContext ctx, int index) {
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Delete This Transaction?'),
            elevation: 24.0,
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  deleteTx(index);
                  Navigator.of(ctx).pop();
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return (transactions.length <= 0)
        ? Center(
            child: Text(
              "Add Some Transactions",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\u{20B9}${transactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    '${transactions[index].title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(transactions[index].date)}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () => _startDeleteTx(context, index),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
