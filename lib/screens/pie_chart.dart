import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

import '../providers/transaction.dart';
import '../widgets/drawer.dart';

class OverView extends StatefulWidget {
  static const routeName = '/overview';
  @override
  _OverViewState createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  int touchedIndex;
  Map<String, Map<String, int>> mp;
  bool _isload = false;
  RandomColor _randomColor = RandomColor();

  List<String> itemsNames = [];
  List<int> weight1 = [];
  List<int> weight2 = [];
  List<Color> colors = [];
  int totalweight1 = 0;
  int totalweight2 = 0;
  bool _isShowByAmount = false;

  @override
  void didChangeDependencies() {
    if (_isload == false) {
      mp = Provider.of<TransactionListProvider>(context, listen: false)
          .categoryWiseTransactions();
      mp.forEach((key, value) {
        String c = key;
        int w1 = value['length'];
        int w2 = value['total'];
        itemsNames.add(c);
        weight1.add(w1);
        weight2.add(w2);
        colors.add(_randomColor.randomColor(
          //colorSaturation: ColorSaturation.mediumSaturation,
          colorBrightness: ColorBrightness.light,
        ));
        totalweight1 += w1;
        totalweight2 += w2;
      });

      _isload = true;
    }
    super.didChangeDependencies();
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(itemsNames.length, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 60 : 50;
      final double fontSize = isTouched ? 25 : 16;
      return PieChartSectionData(
        color: colors[i],
        //showTitle: false,
        value: _isShowByAmount
            ? (weight2[i] / totalweight2)
            : (weight1[i] / totalweight1),
        title: '${(i + 1)}',
        radius: radius,
        titlePositionPercentageOffset: 1.5,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: Column(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: PieChart(
                  PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 3,
                    centerSpaceRadius: 25,
                    sections: showingSections(),
                  ),
                ),
              ),
              SwitchListTile(
                value: _isShowByAmount,
                title: Text(
                  _isShowByAmount
                      ? "Expense till now -  \u{20B9}$totalweight2 "
                      : "Transactions till now - $totalweight1",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _isShowByAmount = !_isShowByAmount;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: GridView.builder(
              itemCount: colors.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 1,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (ctx, index) {
                return Container(
                  color: colors[index],
                  child: GridTile(
                    child: Card(
                      child: Center(
                          child: FittedBox(
                              child: Text(
                        '${itemsNames[index]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
                    ),
                    header: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.2,
                      ),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                          _isShowByAmount
                              ? '${((weight2[index] / totalweight2) * 100).toStringAsFixed(1)} %'
                              : '${((weight1[index] / totalweight1) * 100).toStringAsFixed(1)} %',
                          textAlign: TextAlign.center),
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ]),
    );
  }
}
