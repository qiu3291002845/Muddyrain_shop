# Flutter 文档笔记

------

## 

## 一、防止刷新处理 保持当前状态

```dart
  class HomePageState extends State<HomePage>  with 			AutomaticKeepAliveClientMixin{  
	@override
    // TODO: implement wantKeepAlive
    bool get wantKeepAlive => true;

    @override
    void initState(){
        super.initState();
        print('首页刷新了');
    }
  }
```

## 二、刷新处理

```dart
//刷新处理模块
import 'package:flutter_easyrefresh/easy_refresh.dart';
```

```dart
return EasyRefresh(
    refreshFooter: ClassicsFooter(
        key: _footerKey,
        bgColor: Colors.white,
        textColor: KColor.refreshTextColor,
        moreInfoColor: KColor.refreshTextColor,
        showMore: true,
        noMoreText: '',
        moreInfo: KString.loading, //加载中
        loadReadyText: KString.loadReadyText,
    ),
    child: ListView(
        children: <Widget>[
        ],
    ),
    loadMore: () async{
        print('开始加载更多');
    },
);
```

## 三、flutter-swiper 轮播图

```dart
//轮播图
import 'package:flutter_swiper/flutter_swiper.dart';
// 调用轮播组件
 child: ListView(
     children: <Widget>[
         SwiperDiy(
             swiperDataList: swiperDataList,
         )
     ],
 ),
```

```dart
//首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(333),
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
        // 轮播长度
        itemCount: swiperDataList.length,
        // 增加轮播按钮
        pagination: SwiperPagination(),
        // 是否 自动轮播
        autoplay: true,
      ),
    );
  }
}
```

