import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String day;
  final int dayExp;
  final int totalExp;

  ChartBar(this.day, this.dayExp, this.totalExp);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: constrains.maxHeight * 0.1,
                child: FittedBox(
                  child: Text('\u{20B9}$dayExp'),
                )),
            SizedBox(
              height: constrains.maxHeight * 0.05,
            ),
            Container(
              width: constrains.maxWidth * 0.3,
              height: constrains.maxHeight * 0.7,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: (totalExp <= 0) ? 0 : (dayExp / totalExp),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constrains.maxHeight * 0.05,
            ),
            Container(
              height: constrains.maxHeight * 0.09,
              child: FittedBox(
                child: Text('$day'),
              ),
            )
          ],
        );
      },
    );
  }
}
