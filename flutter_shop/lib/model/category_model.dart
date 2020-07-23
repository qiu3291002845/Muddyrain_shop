class CategoryModel {
  String code;
  String message;
  List<Data> data;

  CategoryModel({
    this.code,
    this.message,
    this.data,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String firstCategoryId;
  String firstCategoryName;
  List<SecondCategoryVO> secondCategoryVO;
  Null comments;
  String image;

  Data(
      {this.firstCategoryId,
      this.firstCategoryName,
      this.secondCategoryVO,
      this.comments,
      this.image});

  Data.fromJson(Map<String,dynamic> json){
    firstCategoryId = json['irstCategoryId'];
    firstCategoryName = json['firstCategoryName'];
    if (json['secondCategoryVO'] != null) {
      secondCategoryVO = new List<SecondCategoryVO>();
      json['secondCategoryVO'].forEach((v) {
        secondCategoryVO.add(new SecondCategoryVO.fromJson(v));
      });
    }
    comments = json['comments'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstCategoryId'] = this.firstCategoryId;
    data['firstCategoryName'] = this.firstCategoryName;
    if (this.secondCategoryVO != null) {
      data['SecondCategoryVO'] =
          this.secondCategoryVO.map((e) => e.toJson()).toList();
    }
    data['comments'] = this.comments;
    data['image'] = this.image;
    return data;
  }
}

class SecondCategoryVO {
  String secondCategoryId;
  String firstCategoryId;
  String secondCategoryName;
  String coments;

  SecondCategoryVO({
    this.secondCategoryId,
    this.firstCategoryId,
    this.secondCategoryName,
    this.coments,
  });

  SecondCategoryVO.fromJson(Map<String, dynamic> json) {
    secondCategoryId = json['secondCategoryId'];
    firstCategoryId = json['firstCategoryId'];
    secondCategoryName = json['secondCategoryName'];
    coments = json['coments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[' secondCategoryId'] = this.secondCategoryId;
    data['firstCategoryId'] = this.firstCategoryId;
    data['secondCategoryName'] = this.secondCategoryName;
    data['coments'] = this.coments;
    return data;
  }
}
