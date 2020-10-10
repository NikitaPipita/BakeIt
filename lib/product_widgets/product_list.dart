import 'package:flutter/material.dart';

import '../database_helper/crud_operations.dart';
import '../database_helper/data_models.dart';
import 'product_page.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<ProductModel>>(
        future: DatabaseHelper.getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ProductModel item = snapshot.data[index];
                return ListTile(
                  title: Text(
                    item.title + ' ' + item.count.toString() + 'гр/мл',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    item.price.toString() + '₴',
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(item: item),
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
