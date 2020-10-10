import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

import 'dart:typed_data';
import 'dart:io';

import 'data_models.dart';

class DatabaseHelper {

  static String path;
  static Future<Database> database;

  ///Add cake id at the end of SQL query
  static final String sqlGetCakeProducts = 'SELECT '
      'cake_product._id AS _id, '
      'product.title AS title, '
      'cake_product.product_count AS count '
      'FROM cake_product '
      'INNER JOIN cake ON cake_product.cake_id = cake._id '
      'INNER JOIN product ON cake_product.product_id = product._id '
      'WHERE cake._id = ';

  ///Add cake id at the end of SQL query
  static final String sqlGetInformationAboutProductsAndTheirQuantityInTheCake = 'SELECT '
      'price, count, product_count '
      'FROM cake_product '
      'INNER JOIN cake ON cake_product.cake_id = cake._id '
      'INNER JOIN product ON cake_product.product_id = product._id '
      'WHERE cake._id = ';

  ///Copies the database from assets to the phone memory
  ///if the database is not already in the phone memory
  static Future<bool> copyDB() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, "cakes.db");

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "cakes.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    database = openDatabase(path);
    return true;
  }


  static Future<void> insertCake(String title) async {
    final Database db = await database;

    var response = await db.rawInsert('INSERT INTO cake(title) VALUES("$title")');
    print(response);
  }

  static Future<void> insertProduct(String title, double price, int count) async {
    final Database db = await database;

    var response = await db.rawInsert('INSERT INTO product(title, price, count) '
        'VALUES("$title", $price, $count)');
    print(response);
  }

  static Future<void> insertCakeProduct(int productId, int productCount, {int cakeId}) async {
    final Database db = await database;

    if (cakeId == null) {
      var maxCakeIdRequest = await db.rawQuery('SELECT MAX(_id) AS _id FROM cake');
      List<MaxCakeId> cakeIdAnswer = maxCakeIdRequest.map((e) => MaxCakeId.fromMap(e)).toList();
      cakeId = cakeIdAnswer.last.id;
    }

    var response = await db.rawInsert('INSERT INTO '
        'cake_product(cake_id, product_id, product_count) '
        'VALUES($cakeId, $productId, $productCount)');
    print(response);
  }


  static Future<List<CakeModel>> getCakes() async {
    final Database db = await database;

    var response = await db.query('cake');
    List<CakeModel> cakeList = response.map((c) => CakeModel.fromMap(c)).toList();
    cakeList.sort();
    return cakeList;
  }

  static Future<List<ProductModel>> getProducts() async {
    final Database db = await database;

    var response = await db.query(
        'product',
    );
    List<ProductModel> productList = response.map((c) => ProductModel.fromMap(c)).toList();
    productList.sort();
    return productList;
  }

  static Future<List<IngredientModel>> getCakeProducts(int cakeId) async {
    final Database db = await database;

    var response = await db.rawQuery(sqlGetCakeProducts + cakeId.toString());
    List<IngredientModel> ingredientList = response.map((c) => IngredientModel.fromMap(c)).toList();
    return ingredientList;
  }

  static Future<List<ProductInfoAndQuantityInCakeModel>> getProductsInfoAndTheirQuantityInCake(int cakeId) async {
    final Database db = await database;

    var response = await db.rawQuery(sqlGetInformationAboutProductsAndTheirQuantityInTheCake + cakeId.toString());
    List<ProductInfoAndQuantityInCakeModel> productInfoAndQuantityInCakeList = response.map((c) =>
        ProductInfoAndQuantityInCakeModel.fromMap(c)).toList();
    return productInfoAndQuantityInCakeList;
  }


  static Future<void> updateCake(CakeModel cake) async {
    final Database db = await database;

    var response = await db.update(
      'cake',
      cake.toMap(),
      where: "_id = ?",
      whereArgs: [cake.id],
    );
    print(response);
  }

  static Future<void> updateProduct(ProductModel product) async {
    final Database db = await database;

    var response = await db.update(
      'product',
      product.toMap(),
      where: "_id = ?",
      whereArgs: [product.id],
    );
    print(response);
  }

  static Future<void> updateCakeProduct(CakeProductModel cakeProduct) async {
    final Database db = await database;

    var response = await db.update(
      'cake_product',
      cakeProduct.toMap(),
      where: "_id = ?",
      whereArgs: [cakeProduct.id],
    );
    print(response);
  }


  static Future<void> deleteCake(int id) async {
    final Database db = await database;

    var response = await db.delete(
      'cake',
      where: "_id = ?",
      whereArgs: [id],
    );
    print(response);

    var cakeProductDeleteResponse = await db.delete(
      'cake_product',
      where: "cake_id = ?",
      whereArgs: [id],
    );
    print(cakeProductDeleteResponse);
  }

  static Future<void> deleteProduct(int id) async {
    final Database db = await database;

    var productDeleteResponse = await db.delete(
      'product',
      where: "_id = ?",
      whereArgs: [id],
    );
    print(productDeleteResponse);

    var cakeProductDeleteResponse = await db.delete(
      'cake_product',
      where: "product_id = ?",
      whereArgs: [id],
    );
    print(cakeProductDeleteResponse);
  }

  static Future<void> deleteCakeProduct(int id) async {
    final Database db = await database;

    var response = await db.delete(
      'cake_product',
      where: "_id = ?",
      whereArgs: [id],
    );
    print(response);
  }
}