import 'package:flutter/material.dart';
import '../model/category_model.dart';

//分类Provide
class CategoryProvider with ChangeNotifier {
  List<SecondCategoryVO> secondCategoryList = []; // 二级分类列表
  int secondCategoryIndex = 0; // 二级分类索引
  int firstCategoryIndex = 0; // 一级分类索引
  String secondCategoryId = ''; // 二级 Id
  String firstCategoryId = '4'; // 一级 Id
  int page = 1; // 列表页数, 当改变一级页或者二级页 分类时进行改变
  String noMoreText = ''; // 显示更多的表示
  bool isNewCategory = true;

  // 首页点击类别时更改类别
  changeFirstCategory(String id, int index) {
    firstCategoryId = id;
    firstCategoryIndex = index;
    secondCategoryId = "";
    // 通知监听者
    notifyListeners();
  }

  // 获取 二级分类数据
  getSecondCategory(List<SecondCategoryVO> list, String id) {
    isNewCategory = true;
    firstCategoryId = id;
    secondCategoryIndex = 0;
    page = 1;
    secondCategoryId = ''; // 点击一级分类 时把二级分类ID清空
    noMoreText = '';
    SecondCategoryVO all = SecondCategoryVO();
    all.secondCategoryId = '';
    all.firstCategoryId = '00';
    all.secondCategoryName = "全部";
    all.coments = null;
    secondCategoryList = [all];
    secondCategoryList.addAll(list);
    //通知监听者
    notifyListeners();
  }

  // 改变二类索引
  changeSecondCategory(String id, int index) {
    isNewCategory = true;
    secondCategoryId = id;
    secondCategoryIndex = index;
    page = 1;
    noMoreText = '';
    // 通知状态监听
    notifyListeners();
  }

  // 增加page的方法
  addPage() {
    page++;
  }

  // 改变 noMoreText 数据
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

  changeFale() {
    isNewCategory = false;
  }
}
