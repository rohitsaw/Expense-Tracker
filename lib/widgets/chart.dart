import 'package:flutter/material.dart';

import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Map<String, int>> lastSevenDays;

  final Map<int, String> mp = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  final int totalLastSevenDays;
  Chart(this.lastSevenDays, this.totalLastSevenDays);

  @override
  Widget build(BuildContext context) {
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
                  mp[each['day']],
                  each['amount'],
                  totalLastSevenDays,
                ),
              );
            }).toList()),
      ),
    );
  }
}
