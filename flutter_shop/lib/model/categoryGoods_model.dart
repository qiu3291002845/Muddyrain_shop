class CategoryGoodsListModel {
  String code;
  String message;
  List<CategoryListData> data;

  CategoryGoodsListModel({
    this.code,
    this.message,
    this.data,
  });

  CategoryGoodsListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = List<CategoryListData>();
      json['data'].forEach((v) {
        data.add(new CategoryListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class CategoryListData {
  String image;
  double oriPrice;
  double presentPrice;
  String name;
  String goodsId;

  CategoryListData({
    this.oriPrice,
    this.presentPrice,
    this.name,
    this.goodsId,
    this.image,
  });

  CategoryListData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    oriPrice = json['oriPrice'];
    name = json['name'];
    presentPrice = json['presentPrice'];
    goodsId = json['goodsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['oriPrice'] = this.oriPrice;
    data['presentPrice'] = this.presentPrice;
    data['goodsId'] = this.goodsId;
    return data;
  }
}
