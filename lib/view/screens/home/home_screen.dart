import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/set_menu_view.dart';
import 'package:flutter_restaurant/view/screens/notification/notification_screen.dart';
import 'package:flutter_restaurant/view/screens/search/search_screen.dart';
import 'package:flutter_restaurant/view/screens/setmenu/set_menu_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<LocationProvider>(context, listen: false)
        .getUserLocation(context: context,isReset: false);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
    }

    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, reload);
    await Provider.of<SetMenuProvider>(context, listen: false)
        .getSetMenuList(context, reload);
    await Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);

  }

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context, false);
    return Scaffold(
      backgroundColor: ColorResources.getBackgroundColor(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(context, true);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).primaryColor,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<LocationProvider>(context, listen: false)
                            .getUserLocation(context: context,isReset: true);
                      },
                      child: Image.asset(Images.home_location_icon,
                          width: 50, height: 50,color: ColorResources.getThemeColor(context),),
                    ),
                    SizedBox(width: 10),
                    Consumer<LocationProvider>(
                        builder: (context, locationProvider, child) {
                      return Text(
                              locationProvider.locality ?? '',
                              style: robotoMedium.copyWith(fontSize: 20,color: ColorResources.getThemeColor(context),),
                            );
                    }),

                    // Image.asset(Images.efood, width: 55, height: 55, color: ColorResources.getAccentColor(context)),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NotificationScreen())),
                    icon: Icon(Icons.notifications,
                        color: Theme.of(context).accentColor),
                  ),
                ],
              ),

              // Search Button
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                    child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchScreen()));
                  },
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_SMALL,
                        2, Dimensions.PADDING_SIZE_SMALL, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorResources.getSearchBg(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: Icon(
                              Icons.search,
                              size: 25,
                              color: ColorResources.getPrimaryColor(context),
                            )),
                        Expanded(
                            child: Text("Search cuisine or ingredients",
                                style: ralewayRegular.copyWith(
                                    fontSize: 15, color: Colors.black54))),
                        // getTranslated('search_cuisine_ingredients', context)
                      ]),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                  ),
                )),
              ),

              SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<CategoryProvider>(
                        builder: (context, category, child) {
                          return category.categoryList == null
                              ? CategoryView()
                              : category.categoryList.length == 0
                                  ? SizedBox()
                                  : CategoryView();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TitleWidget(
                            title: "Special Menu",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SetMenuScreen()));
                            }),
                      ),
                      SetMenuView(),

                      Consumer<BannerProvider>(
                        builder: (context, banner, child) {
                          return banner.bannerList == null ? BannerView() : banner.bannerList.length == 0 ? SizedBox() : BannerView();
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TitleWidget(
                            title: getTranslated('popular_item', context)),
                      ),
                      ProductView(
                        productType: ProductType.POPULAR_PRODUCT,
                        scrollController: _scrollController,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
