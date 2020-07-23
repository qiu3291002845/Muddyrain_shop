import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/config/color.dart';
import 'package:flutter_shop/config/font.dart';
import 'package:flutter_shop/config/string.dart';
import 'package:flutter_shop/model/category_model.dart';
import 'package:flutter_shop/provide/current_index_provide.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'dart:convert';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/category_provide.dart';

// TODO 刷新处理模块
import 'package:flutter_easyrefresh/easy_refresh.dart';

// TODO 轮播图
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO  TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  // TODO  火爆专区分页
  int page = 1;

  // TODO  火爆专区数据
  List<Map> hotGoodList = [];

  // TODO  防止刷新处理 保持当前状态
  @override
  // TODO  TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  // TODO  diff算法

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// TODO     super.build(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      appBar: AppBar(
        title: Text(
          KString.homeTitle,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: request('homePageContent', formData: null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList =
                (data['data']['slides'] as List).cast(); // TODO 轮播图
            List<Map> navigatorList =
                (data['data']['category'] as List).cast(); // TODO  分类
            List<Map> recommendList =
                (data['data']['recommend'] as List).cast(); // TODO  商品推荐
            List<Map> floor1 =
                (data['data']['floor1'] as List).cast(); // TODO  底部商品推荐
            Map fp1 = data['data']['floor1Pic']; // TODO  广告
// TODO             print(data);
            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: KColor.refreshTextColor,
                moreInfoColor: KColor.refreshTextColor,
                showMore: true,
                noMoreText: '',
                moreInfo: KString.loading,
                // TODO 加载中
                loadReadyText: KString.loadReadyText,
              ),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(
                    swiperDataList: swiperDataList,
                  ),
                  TopNavigator(
                    navigatorList: navigatorList,
                  ),
                  RecommendUI(
                    recommendList: recommendList,
                  ),
                  FloorPic(
                    floorPic: fp1,
                  ),
                  Floor(
                    floor: floor1,
                  ),
                  _hotGoods(),
                ],
              ),
              loadMore: () async {
                _getHotGoods();
              },
            );
          } else {
            return Container(
              height: 1080,
              child: Image.asset(
                'assets/images/loading.gif',
                fit: BoxFit.cover,
              ),
            );
          }
        },
      ),
    );
  }

  void _getHotGoods() {
    Object formPage = {'page': page};
    request('getHotGoods', formData: formPage).then((value) {
      var data = json.decode(value.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      // TODO  设置火爆专区数据列表
      setState(() {
        hotGoodList.addAll(newGoodsList);
        page++;
      });
    });
  }

  // TODO  火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          width: 0.5,
          color: KColor.defaultBorderColor,
        ))),
    child: Text(
      KString.hotGoodsTitleText,
      style: TextStyle(
        color: KColor.homeTitleColor,
      ),
    ),
  );

  // TODO  火爆专区子项
  Widget _wrapList() {
    if (hotGoodList.length != 0) {
      List<Widget> listWidget = hotGoodList.map((e) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(360),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  e['image'],
                  width: ScreenUtil().setWidth(350),
                  height: ScreenUtil().setHeight(360),
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  e['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenUtil().setSp(26.0)),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '￥${e['presentPrice']}',
                      style: TextStyle(
                        color: KColor.presentPriceTextColor,
                      ),
                    ),
                    Text(
                      '￥${e['oriPrice']}',
                      style: TextStyle(
                        color: KColor.oriPriceTextColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

// TODO 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {},
              child: Image.network(
                "${swiperDataList[index]['image']}",
                fit: BoxFit.cover,
              ));
        },
        // TODO  轮播长度
        itemCount: swiperDataList.length,
        // TODO  增加轮播按钮
        pagination: SwiperPagination(),
        // TODO  是否 自动轮播
        autoplay: true,
      ),
    );
  }
}

// TODO 首页分类导航组件
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUi(BuildContext context, item, index) {
    return InkWell(
      onTap: () {
        // TODO 跳转到页面
        _goCategory(context, index, item['firstCategoryId']);
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['firstCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO  判断分类的长度 是否大于10
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    var tempIndex = -1;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(150 * 2),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        // TODO  禁止滚动
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((e) {
          tempIndex++;
          return _gridViewItemUi(context, e, tempIndex);
        }).toList(),
      ),
    );
  }

  // 跳转到分类页面
  void _goCategory(context, int index, String categoryId) async {
    await request('getCategory', formData: null).then((value) {
      var data = json.decode(value.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      List list = category.data;
      Provide.value<CategoryProvider>(context)
          .changeFirstCategory(categoryId, index);
      Provide.value<CategoryProvider>(context).getSecondCategory(
        list[index].secondCategoryVO,
        categoryId,
      );
      Provide.value<CurrentIndexProvider>(context).changeIndex(1);
    });
  }
}

// TODO  商品推荐
class RecommendUI extends StatelessWidget {
  final List recommendList;

  RecommendUI({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(context),
        ],
      ),
    );
  }

  // TODO  推荐商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: KColor.defaultBorderColor,
            ),
          )),
      child: Text(
        KString.recommendText,
        style: TextStyle(
          color: KColor.homeTitleColor,
        ),
      ),
    );
  }

  // TODO  商品推荐列表
  Widget _recommendList(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(360),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index, context);
        },
      ),
    );
  }

  // TODO  每个商品
  Widget _item(index, context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: 0.5,
              color: KColor.defaultBorderColor,
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            // TODO  防止溢出
            Expanded(
              child: Image.network(
                recommendList[index]['image'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              '￥${recommendList[index]['presentPrice']}',
              style: TextStyle(
                color: KColor.presentPriceTextColor,
              ),
            ),
            Text(
              '￥${recommendList[index]['oriPrice']}',
              style: KFount.oriPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// TODO  商品推荐中间广告
class FloorPic extends StatelessWidget {
  final Map floorPic;

  FloorPic({Key key, this.floorPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2, left: 3, right: 3),
      child: InkWell(
        child: Image.network(
          floorPic['PICTURE_ADDRESS'],
          fit: BoxFit.cover,
        ),
        onTap: () {},
      ),
    );
  }
// TODO  推荐商品标题
}

// TODO  商品推荐下层
class Floor extends StatelessWidget {
  List<Map> floor;

  Floor({Key key, this.floor}) : super(key: key);

  void jumpDetail(context, String goodId) {
    // TODO  跳转到商品详情
  }

  @override
  Widget build(BuildContext context) {
// TODO     double width = ScreenUtil.defaultWidth as double;
    return Container(
      child: Row(
        children: <Widget>[
          // TODO  左侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                // TODO  左上角图片
                Container(
                  padding: EdgeInsets.only(top: 3),
                  height: ScreenUtil().setHeight(400),
                  child: InkWell(
                    child: Image.network(
                      floor[0]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[0]['goodsId']);
                    },
                  ),
                ),
                // TODO  左下图
                Container(
                  padding: EdgeInsets.only(),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[1]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[1]['goodsId']);
                    },
                  ),
                ),
              ],
            ),
          ),
          // TODO  右侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                // TODO  右上图
                Container(
                  padding: EdgeInsets.only(top: 3, left: 1, bottom: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[2]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[2]['goodsId']);
                    },
                  ),
                ),
                // TODO  右中图
                Container(
                  padding: EdgeInsets.only(top: 1, left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[3]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[3]['goodsId']);
                    },
                  ),
                ),
                // TODO  右下图
                Container(
                  padding: EdgeInsets.only(top: 1, left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[4]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[4]['goodsId']);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
// TODO  推荐商品标题
}
