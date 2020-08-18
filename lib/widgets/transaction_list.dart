import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import '../providers/transaction.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txlength = Provider.of<TransactionListProvider>(context, listen: true)
        .noOfTransactions;
    return (txlength > 0)
        ? TransactionListSub()
        : const Center(
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

GlobalKey<AnimatedListState> listkey = GlobalKey<AnimatedListState>();

class TransactionListSub extends StatefulWidget {
  TransactionListSub();
  @override
  _TransactionListSubState createState() => _TransactionListSubState();
}

class _TransactionListSubState extends State<TransactionListSub>
    with TickerProviderStateMixin {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<TransactionListProvider>(context, listen: true);
    Timer(
      Duration(milliseconds: 700),
      () => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut),
    );

    return AnimatedList(
      key: listkey,
      controller: _scrollController,
      initialItemCount: provider.noOfTransactions,
      itemBuilder: (ctx, index, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: TransactionItem(index),
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final index;
  TransactionItem(this.index);

  void _startDeleteTx(BuildContext ctx, int id, Function deleteTx) {
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
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  AnimatedList.of(ctx).removeItem(
                    index,
                    (context, animation) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                            parent: animation, curve: Interval(0.5, 1.0)),
                        child: SizeTransition(
                          sizeFactor: CurvedAnimation(
                              parent: animation, curve: Interval(0.0, 1.0)),
                          //child: TransactionItem(index),
                          child: this,
                        ),
                      );
                    },
                    duration: Duration(milliseconds: 700),
                  );
                  deleteTx(id);
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
    final provider =
        Provider.of<TransactionListProvider>(context, listen: false);

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
              context,
              provider.getAllTransactions[index].id,
              provider.deleteTrasaction,
            ),
          ),
        ),
      ),
    );
  }
}
