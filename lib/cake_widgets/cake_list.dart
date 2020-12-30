import 'package:flutter/material.dart';

import '../database_helper/crud_operations.dart';
import '../database_helper/data_models.dart';
import 'cake_page.dart';

class CakeList extends StatefulWidget {
  @override
  _CakeListState createState() => _CakeListState();
}

class _CakeListState extends State<CakeList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<CakeModel>>(
        future: DatabaseHelper.getCakes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                CakeModel item = snapshot.data[index];
                return ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: CakePrice(item),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CakePage(item: item),
                      ),
                    ).then((value){
                      setState(() {});
                    });
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


class CakePrice extends StatefulWidget {
  final CakeModel _item;

  CakePrice(this._item);

  @override
  _CakePriceState createState() => _CakePriceState();
}

class _CakePriceState extends State<CakePrice> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductInfoAndQuantityInCakeModel>>(
      future: DatabaseHelper
          .getProductsInfoAndTheirQuantityInCake(widget._item.id),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          double totalPrice = 0;
          for (ProductInfoAndQuantityInCakeModel ingredient in snapshot.data) {
            totalPrice += (ingredient.productQuantityInCake
                * ingredient.productPrice) / ingredient.productCount;
          }
          return Text (
            totalPrice.toStringAsFixed(2).toString() + '₴',
          );
        } else {
          return Text (
            widget._item.id.toString() + '₴',
          );
        }
      },
    );
  }
}
