class CakeModel extends Comparable<CakeModel>{
  int id;
  String title;

  CakeModel({
    this.id,
    this.title,
  });

  factory CakeModel.fromMap(Map<String, dynamic> json) => new CakeModel(
    id: json['_id'],
    title: json['title'],
  );

  Map<String, dynamic> toMap() => {
    '_id': id,
    'title': title,
  };

  @override
  int compareTo(CakeModel other) {
    return this.title.toLowerCase().compareTo(other.title.toLowerCase());
  }
}

class ProductModel extends Comparable<ProductModel>{
  int id;
  String title;
  double price;
  int count;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.count,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) => new ProductModel(
    id: json['_id'],
    title: json['title'],
    price: json['price'],
    count: json['count'],
  );

  Map<String, dynamic> toMap() => {
    '_id': id,
    'title': title,
    'price' : price,
    'count' : count,
  };

  @override
  int compareTo(ProductModel other) {
    return this.title.toLowerCase().compareTo(other.title.toLowerCase());
  }
}

class IngredientModel {
  int id;
  String title;
  int count;

  IngredientModel({
    this.id,
    this.title,
    this.count,
  });

  factory IngredientModel.fromMap(Map<String, dynamic> json) => new IngredientModel(
    id: json['_id'],
    title: json['title'],
    count: json['count'],
  );

  Map<String, dynamic> toMap() => {
    '_id': id,
    'title': title,
    'count' : count,
  };
}

class MaxCakeId {
  int id;

  MaxCakeId({
    this.id,
  });

  factory MaxCakeId.fromMap(Map<String, dynamic> json) => new MaxCakeId(
    id: json['_id'],
  );
}

class CakeProductModel {
  int id;
  int cakeId;
  int productId;
  int productCount;

  CakeProductModel({
    this.id,
    this.cakeId,
    this.productId,
    this.productCount,
  });


  Map<String, dynamic> toMap() => {
    '_id': id,
    'cake_id': cakeId,
    'product_id' : productId,
    'product_count' : productCount,
  };
}

class ProductInfoAndQuantityInCakeModel {
  double productPrice;
  int productCount;
  int productQuantityInCake;

  ProductInfoAndQuantityInCakeModel({
    this.productPrice,
    this.productCount,
    this.productQuantityInCake,
  });

  factory ProductInfoAndQuantityInCakeModel.fromMap(Map<String, dynamic> json) =>
      new ProductInfoAndQuantityInCakeModel(
    productPrice: json['price'],
    productCount: json['count'],
    productQuantityInCake: json['product_count'],
  );
}