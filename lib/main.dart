import 'package:flutter/material.dart';

import 'database_helper/crud_operations.dart';
import 'cake_widgets/cake_page.dart';
import 'cake_widgets/cake_list.dart';
import 'product_widgets/product_page.dart';
import 'product_widgets/product_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Galinas Cakes',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: DatabaseHelper.copyDB(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if (snapshot.hasData) {
            return BottomNavigationStatefulWidget();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class BottomNavigationStatefulWidget extends StatefulWidget {
  BottomNavigationStatefulWidget({Key key}) : super(key: key);

  @override
  _BottomNavigationStatefulWidgetState createState() =>
      _BottomNavigationStatefulWidgetState();
}

class _BottomNavigationStatefulWidgetState
    extends State<BottomNavigationStatefulWidget> {
  int _selectedIndex = 0;
  Widget _selectedPage = CakeList();
  static const TextStyle optionStyle =
  TextStyle(fontSize: 20);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Тортики',
      style: optionStyle,
    ),
    Text(
      'Продукты',
      style: optionStyle,
    ),
  ];

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedPage = index == 0 ? CakeList() : ProductList();
    });
  }

  static List<StatelessWidget> _pages =
    <StatelessWidget>[CakePage(item: null,), ProductPage(item: null,)];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: _widgetOptions.elementAt(_selectedIndex),
      ),
      body: _selectedPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pages[_selectedIndex]),
          ).then((value){
            setState(() {
              _changePage(_selectedIndex);
            });
          });
        },
        //child: Icon(Icons.add),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            title: Text('Тортики'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Продукты'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _changePage,
      ),
    );
  }
}




