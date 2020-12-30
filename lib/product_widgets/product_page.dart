import 'package:flutter/material.dart';

import '../database_helper/crud_operations.dart';
import '../database_helper/data_models.dart';

class ProductPage extends StatelessWidget {
  final ProductModel item;

  ProductPage({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: item == null ? Text('Добавление продукта')
            : Text('Редактирование продукта'),
      ),
      body: ProductTextForm(item: item),
    );
  }
}

class ProductTextForm extends StatefulWidget {
  final ProductModel item;

  ProductTextForm({Key key, @required this.item}) : super(key: key);

  @override
  _ProductTextFormState createState() => _ProductTextFormState();
}

class _ProductTextFormState extends State<ProductTextForm> {
  final _titleController = TextEditingController();
  final _countController = TextEditingController();
  final _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _countController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item != null) {
      _titleController.text = widget.item.title;
      _countController.text = widget.item.count.toString();
      _priceController.text = widget.item.price.toString();
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            productTextForm(),
            SizedBox(
              height: 30.0,
            ),
            Visibility(
              visible: widget.item == null ? true : false,
              child: addProductButton(),
            ),
            Visibility(
              visible: widget.item == null ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  updateProductButton(),
                  SizedBox(
                    width: 20.0,
                  ),
                  deleteProductButton(),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget productTextForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Название продукта',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Строка не должна быть пустой';
              }
              return null;
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: _countController,
            keyboardType: TextInputType
                .numberWithOptions(signed: false, decimal: true),
            decoration: InputDecoration(
              labelText: 'Кол-во продукта в граммах или миллилитрах',
            ),
            validator: (value) {
              if (value.isEmpty || int.tryParse(value) == null) {
                return 'Число должно быть целочисленным';
              }
              return null;
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType
                .numberWithOptions(signed: false, decimal: true),
            decoration: InputDecoration(
              labelText: 'Стоимость продукта',
            ),
            validator: (value) {
              if (value.isEmpty || double.tryParse(value) == null) {
                return 'Число должно быть в формате 0.00';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget addProductButton() {
    return RaisedButton(
      onPressed: (){
        if(_formKey.currentState.validate()) {
          DatabaseHelper.insertProduct(
              _titleController.text,
              double.tryParse(
                  double.tryParse(_priceController.text).toStringAsFixed(2)
              ),
              int.tryParse(_countController.text));
          Navigator.pop(context);
        }
      },
      child: Text("Добавить"),
    );
  }

  Widget updateProductButton() {
    return RaisedButton(
      onPressed: (){
        if(_formKey.currentState.validate()) {
          widget.item.title = _titleController.text;
          widget.item.price = double.tryParse(
              double.tryParse(_priceController.text).toStringAsFixed(2)
          );
          widget.item.count = int.tryParse(_countController.text);
          DatabaseHelper.updateProduct(widget.item);
          Navigator.pop(context);
        }
      },
      child: Text("Редактировать"),
    );
  }

  Widget deleteProductButton() {
    return RaisedButton(
      onPressed: (){
        DatabaseHelper.deleteProduct(widget.item.id);
        Navigator.pop(context);
      },
      child: Text("Удалить"),
    );
  }
}
