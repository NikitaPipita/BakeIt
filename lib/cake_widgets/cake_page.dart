import 'package:flutter/material.dart';

import '../database_helper/crud_operations.dart';
import '../database_helper/data_models.dart';
import 'ingredient_line.dart';
import 'helper_classes/ingredient_line_widget_params.dart';

class CakePage extends StatelessWidget {
  final CakeModel item;

  CakePage({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: item == null ? Text("Добавление тортика")
            : Text("Редактирование тортика"),
      ),
      body: CakeTextForm(item: item,),
    );
  }
}

class CakeTextForm extends StatefulWidget {
  final CakeModel item;

  CakeTextForm({Key key, @required this.item}) : super(key: key);

  @override
  _CakeTextFormState createState() => _CakeTextFormState();
}

class _CakeTextFormState extends State<CakeTextForm> {
  ///Controller for cake name
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ///become true when data from the database is already loaded
  bool isDataFromDatabaseLoaded = false;

  ///List of available ingredients
  final List<String> ingredientTitles = List();

  ///Available ingredients database info (product table)
  ///String: ingredient title
  ///int: ingredient id
  final Map<String, int> ingredientsInfo = Map();

  ///Map with elements of ingredients dynamic list
  ///key: widget id
  ///Widget: IngredientLine widget
  final Map<int, Map<IngredientLineWidgetParams, Widget>> ingredientLineMap = Map();

  ///Set of ingredients id whose foreign key is the id of this cake
  final Set<int> ingredientDatabaseRecords = Set();

  ///widget id counter
  int widgetId = 0;

  ///a list with created widgets
  final List<Widget> ingredientLineWidgets = List();

  ///a list with formKeys to check the correctness of filling in the fields in the created widgets
  final List<GlobalKey<FormState>> ingredientLineKeys = List();

  ///delete IngredientLine widget from dynamic list
  void deleteIngredientLineWidget(int key) {
    setState(() {
      ingredientLineMap.remove(key);
      ingredientLineKeys.clear();
      ingredientLineWidgets.clear();
      for (var value in ingredientLineMap.values) {
        for (var innerValue in value.entries) {
          ingredientLineKeys.add(innerValue.key.formKey);
          ingredientLineWidgets.add(innerValue.value);
        }
      }
    });
  }

  ///Called if the cake editing page was opened
  ///adds a widget of each ingredient whose foreign key is the id of this cake
  void creatingIngredientLineWidgetsBasedOnDataFromTheDatabase
      (AsyncSnapshot<List<IngredientModel>> snapshot) {
    for (var ingredientInfo in snapshot.data) {
      ingredientDatabaseRecords.add(ingredientInfo.id);
      createIngredientLineWidget(
          id: ingredientInfo.id,
          title: ingredientInfo.title,
          count: ingredientInfo.count);
    }
  }

  ///add IngredientLine widget to dynamic list
  void createIngredientLineWidget({int id, String title, int count}) {
    var ingredientKey = GlobalKey<FormState>();
    var ingredientTitleController = TextEditingController();
    ingredientTitleController.text = title == null ? ingredientTitles[0] : title;
    var ingredientCountController = TextEditingController();
    ingredientCountController.text = title == null ? '' : count.toString();
    IngredientLineWidgetParams ingredientLineWidgetParams = IngredientLineWidgetParams(
      formKey: ingredientKey,
      ingredientTitleController: ingredientTitleController,
      ingredientCountController: ingredientCountController,
      widgetId: widgetId,
      ingredientTitlesList: ingredientTitles,
      deleteIngredientLineFunction: deleteIngredientLineWidget,
      id: id == null ? null : id
    );
    IngredientLine ingredientLineWidget = IngredientLine(
      widgetParams: ingredientLineWidgetParams,
    );
    var pairParamsAndWidget = {ingredientLineWidgetParams : ingredientLineWidget};
    ingredientLineMap[widgetId] = pairParamsAndWidget;
    ingredientLineKeys.add(ingredientKey);
    ingredientLineWidgets.add(ingredientLineWidget);
    widgetId++;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void addIngredientLineWidget() {
    setState(() {
      createIngredientLineWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item != null) {
      _titleController.text = widget.item.title;
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            cakeTitleForm(),
            SizedBox(
              height: 15.0,
            ),
            ingredientLinesFutureBuilder(),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              child: Icon(Icons.add),
              onPressed: (){
                addIngredientLineWidget();
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            Visibility(
              visible: widget.item == null ? true : false,
              child: addCakeButton(),
            ),
            Visibility(
              visible: widget.item == null ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  updateCakeButton(),
                  SizedBox(
                    width: 20.0,
                  ),
                  deleteCakeButton(),
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

  Widget cakeTitleForm() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: 'Название тортика',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Строка не должна быть пустой';
          }
          return null;
        },
      ),
    );
  }

  Widget ingredientLinesFutureBuilder() {
    if (isDataFromDatabaseLoaded) {
      return Column(
        children: ingredientLineWidgets,
      );
    } else {
      return FutureBuilder<List<ProductModel>>(
        future: DatabaseHelper.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (var product in snapshot.data) {
              ingredientTitles.add(product.title);
              ingredientsInfo[product.title] = product.id;
            }
            if (widget.item != null) {
              return FutureBuilder<List<IngredientModel>>(
                future: DatabaseHelper.getCakeProducts(widget.item.id),
                builder: (context, snapshot){
                  if (snapshot.hasData) {
                    isDataFromDatabaseLoaded = true;
                    creatingIngredientLineWidgetsBasedOnDataFromTheDatabase(snapshot);
                    return Column(
                      children: ingredientLineWidgets,
                    );
                  }
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              isDataFromDatabaseLoaded = true;
              return Column(
                children: ingredientLineWidgets,
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  Widget addCakeButton() {
    return RaisedButton(
      onPressed: (){
        if(_formKey.currentState.validate()) {
          bool checkKeys = true;
          for (GlobalKey<FormState> key in ingredientLineKeys) {
            if (!key.currentState.validate()) {
              checkKeys = false;
            }
          }
          if (checkKeys) {
            DatabaseHelper.insertCake(_titleController.text);

            for (var value in ingredientLineMap.values) {
              for (var innerValue in value.entries) {
                String productTitle = innerValue.key.ingredientTitleController.text;
                int productId = ingredientsInfo[productTitle];
                int productCount = int.tryParse(innerValue.key.ingredientCountController.text);
                DatabaseHelper.insertCakeProduct(productId, productCount);
              }
            }

            Navigator.pop(context);
          }
        }
      },
      child: Text("Добавить"),
    );
  }

  Widget updateCakeButton() {
    return RaisedButton(
      onPressed: (){
        if(_formKey.currentState.validate()) {
          bool checkKeys = true;
          for (GlobalKey<FormState> key in ingredientLineKeys) {
            if (!key.currentState.validate()) {
              checkKeys = false;
            }
          }
          if (checkKeys) {
            widget.item.title = _titleController.text;
            DatabaseHelper.updateCake(widget.item);

            for (var value in ingredientLineMap.values) {
              for (var innerValue in value.entries) {
                String productTitle = innerValue.key.ingredientTitleController.text;
                int productId = ingredientsInfo[productTitle];
                int productCount = int.tryParse(innerValue.key.ingredientCountController.text);
                int cakeId = widget.item.id;
                int ingredientId = innerValue.key.id;
                if (ingredientId == null) {
                  DatabaseHelper.insertCakeProduct(productId, productCount, cakeId: cakeId);
                } else {
                  CakeProductModel dataModel = CakeProductModel(
                      id: ingredientId,
                      cakeId: cakeId,
                      productId: productId,
                      productCount: productCount);
                  ingredientDatabaseRecords.remove(ingredientId);
                  DatabaseHelper.updateCakeProduct(dataModel);
                }
              }
            }
            for (int id in ingredientDatabaseRecords) {
              DatabaseHelper.deleteCakeProduct(id);
            }

            Navigator.pop(context);
          }
        }
      },
      child: Text("Редактировать"),
    );
  }

  Widget deleteCakeButton() {
    return RaisedButton(
      onPressed: (){
        DatabaseHelper.deleteCake(widget.item.id);
        for (int id in ingredientDatabaseRecords) {
          DatabaseHelper.deleteCakeProduct(id);
        }
        Navigator.pop(context);
      },
      child: Text("Удалить"),
    );
  }
}
