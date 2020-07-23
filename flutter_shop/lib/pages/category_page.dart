import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_model.dart';
import 'package:flutter_shop/provide/category_provide.dart';
import '../config/index.dart'; // TODO  配置变量
import '../service/http_service.dart'; // TODO  请求接口
import 'package:provide/provide.dart'; // TODO  状态管理
import 'package:flutter_easyrefresh/easy_refresh.dart'; // TODO 刷新
import 'dart:convert'; // TODO  TODO  转换 json 处理模块
import 'package:flutter_screenutil/screenutil.dart';
import '../provide/categoryGoodsList_provide.dart';
import 'package:flutter_shop/model/categoryGoods_model.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // TODO 商品分类
        title: Text(
          '商品${KString.categroyTitle}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryPage(),
            Column(
              children: <Widget>[
                RightCategoryPage(),
                CategoryGoodsList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// TODO  左侧导航菜单
class LeftCategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LeftCategoryPageState();
  }
}

class LeftCategoryPageState extends State<LeftCategoryPage> {
  List list = [];
  var listIndex = 0; // TODO 索引
  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provide<CategoryProvider>(
      builder: (context, child, val) {
        // TODO 获取商品列表
        _getGoodList(context);
        listIndex = val.firstCategoryIndex;
        print('您点击了第 ${listIndex} 个一级分类');
        return Container(
          width: ScreenUtil().setWidth(180),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: KColor.defaultBorderColor,
              ),
            ),
          ),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _leftInkWel(index);
            },
          ),
        );
      },
    );
  }

  Widget _leftInkWel(index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        var secondCategoryList = list[index].secondCategoryVO;
        var firstCategoryId = list[index].firstCategoryId;
        Provide.value<CategoryProvider>(context)
            .changeFirstCategory(firstCategoryId, index);
        Provide.value<CategoryProvider>(context)
            .getSecondCategory(secondCategoryList, firstCategoryId);
        // TODO 获取商品列表
        _getGoodList(context, firstCategoryId: firstCategoryId);
      },
      child: Container(
          height: ScreenUtil().setHeight(90.0),
          decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(245, 245, 245, 1.0) : Colors.white,
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: KColor.defaultBorderColor,
              ),
              left: BorderSide(
                width: 2,
                color: isClick ? KColor.primaryColor : Colors.white,
              ),
            ),
          ),
          child: Center(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Image.network(
                  '${list[index].image}',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  list[index].firstCategoryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isClick ? KColor.primaryColor : Colors.black,
                    fontSize: ScreenUtil().setSp(28.0),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  // TODO 获取分类数据
  _getCategory() async {
    await request('getCategory', formData: null).then(
      (value) {
        var data = json.decode(value.toString());
        CategoryModel category = CategoryModel.fromJson(data);
        setState(() {
          list = category.data;
        });
        Provide.value<CategoryProvider>(context)
            .getSecondCategory(list[0].secondCategoryVO, '9');
      },
    );
  }

  _getGoodList(context, {String firstCategoryId}) {
    var data = {
      'firstCategoryId': firstCategoryId == null
          ? Provide.value<CategoryProvider>(context).firstCategoryId
          : firstCategoryId,
      'secondCategoryId':
          Provide.value<CategoryProvider>(context).secondCategoryId
    };
    request('getCategoryGoods', formData: data).then((value) {
      var data = json.decode(value.toString());
      CategoryGoodsListModel goodList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvider>(context)
          .getGoodsList(goodList.data);
    });
  }
}

// TODO 右侧导航菜单
class RightCategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RightCategoryPageState();
  }
}

class RightCategoryPageState extends State<RightCategoryPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Provide<CategoryProvider>(
        builder: (context, child, categoryProvide) {
          return Container(
            height: ScreenUtil().setHeight(90.0),
            width: ScreenUtil().setWidth(570.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: KColor.defaultBorderColor,
                ),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryProvide.secondCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWel(
                    index, categoryProvide.secondCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _rightInkWel(int index, SecondCategoryVO item) {
    bool isClick = false;
    isClick =
        (index == Provide.value<CategoryProvider>(context).secondCategoryIndex)
            ? true
            : false;
    return InkWell(
      onTap: () {
        Provide.value<CategoryProvider>(context)
            .changeSecondCategory(item.secondCategoryId, index);
        // TODO 获取商品列表
        _getGoodList(context, secondCategoryId: item.secondCategoryId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.secondCategoryName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28.0),
            color: isClick ? KColor.primaryColor : Colors.black,
          ),
        ),
      ),
    );
  }

  _getGoodList(context, {String secondCategoryId}) {
    var data = {
      'firstCategoryId':
          Provide.value<CategoryProvider>(context).firstCategoryId,
      'secondCategoryId':
          Provide.value<CategoryProvider>(context).secondCategoryId
    };
    request('getCategoryGoods', formData: data).then((value) {
      var data = json.decode(value.toString());
      CategoryGoodsListModel goodList = CategoryGoodsListModel.fromJson(data);
      if (goodList.data == null) {
        Provide.value<CategoryGoodsListProvider>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvider>(context)
            .getGoodsList(goodList.data);
      }
    });
  }
}

// TODO 分类内容列表
class CategoryGoodsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryGoodsListState();
  }
}

class CategoryGoodsListState extends State<CategoryGoodsList> {
  // 刷新
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  //滚动控制
  var scrollController = new ScrollController();

//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Text('你好');
//  }
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvider>(
      builder: (context, child, data) {
        try {
          // 分类切换时 滚动到顶部处理
          if (Provide.value<CategoryProvider>(context).page == 1) {
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化:${e}');
        }
        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570.0),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: KColor.refreshTextColor,
                  moreInfoColor: KColor.refreshTextColor,
                  showMore: true,
                  noMoreText:
                      Provide.value<CategoryProvider>(context).noMoreText,
                  moreInfo: KString.loading,
                  //TODO 加载中
                  loadReadyText: KString.loadReadyText, //上拉加载
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    //列表项
                    return _ListWidget(data.goodsList, index);
                  },
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                ),
              ),
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  Widget _ListWidget(List newList, int index) {
    return InkWell(
      onTap: () {
        //TODO 跳转到商品详情页
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 5.0,
          bottom: 5.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: KColor.defaultBorderColor,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[],
            ),
          ],
        ),
      ),
    );
  }

  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200.0),
      child: Image.network(newList[index].image),
    );
  }
}
