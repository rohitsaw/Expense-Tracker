import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:async';

class TransactionList extends StatelessWidget {
  final provider;
  TransactionList(this.provider);

  @override
  Widget build(BuildContext context) {
    int txlength = provider.noOfTransactions;
    return (txlength > 0)
        ? TransactionListSub(provider)
        : Center(
            child: Text(
              "Add Some Transactions",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
          );
  }
}

class TransactionListSub extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  final provider;
  TransactionListSub(this.provider);

  void _startDeleteTx(BuildContext ctx, int id, deleteTx) {
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
                  deleteTx(id);
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
    Timer(
      Duration(milliseconds: 700),
      () => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut),
    );

    final Function deleteTx = provider.deleteTrasaction;

    return ListView.builder(
      //reverse: true,
      controller: _scrollController,
      itemBuilder: (ctx, index) {
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          child: InkWell(
            onTap: () {},
            splashColor: Colors.black54,
            child: ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text(
                        '\u{20B9}${provider.getAllTransactions[index].amount}'),
                  ),
                ),
              ),
              title: Text(
                '${provider.getAllTransactions[index].getCategory}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${provider.getAllTransactions[index].title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${DateFormat.yMMMd().format(provider.getAllTransactions[index].date)}',
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => _startDeleteTx(
                    context, provider.getAllTransactions[index].id, deleteTx),
              ),
            ),
          ),
        );
      },
      //itemCount: transactions.length,
      itemCount: provider.noOfTransactions,
    );
  }
}
