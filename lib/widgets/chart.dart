import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './chart_bar.dart';

import '../providers/transaction.dart';

class Chart extends StatelessWidget {
  //final provider;
  //Chart(this.provider);

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<TransactionListProvider>(context, listen: true);
    List<Map<String, dynamic>> lastSevenDays = provider.lastSevenDays;
    int total = 0;
    lastSevenDays.forEach((element) {
      total += element['amount'];
    });

    return Card(
      //margin: EdgeInsets.all(10),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: lastSevenDays.map((each) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  each['day'],
                  each['amount'],
                  total,
                ),
              );
            }).toList()),
      ),
    );
  }
}
