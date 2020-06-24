import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/category';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    print(routeArgs);

    Map<String, int> total = routeArgs['total'] as Map<String, int>;
    Map<String, int> noOfTransactions =
        routeArgs['noOfTransaction'] as Map<String, int>;
    List<String> categories =
        (routeArgs['categories'] as Set<String>).map((ele) {
      return ele;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories Overview'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () {},
              splashColor: Colors.black54,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      categories[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\u{20B9}${total[categories[index]]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${noOfTransactions[categories[index]]} transactions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.tealAccent.withOpacity(0.7),
                      Colors.tealAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          },
          itemCount: categories.length,
        ),
      ),
    );
  }
}
