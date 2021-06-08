import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  CustomAppBar(
      {@required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: robotoMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).textTheme.bodyText1.color)),
      centerTitle: true,
      shape: ContinuousRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(50.0),
          bottomLeft: Radius.circular(50.0),
        ),
      ),
      leading: isBackButtonExist
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyText1.color,
              onPressed: () => onBackPressed != null
                  ? onBackPressed()
                  : Navigator.pop(context),
            )
          : SizedBox(),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}

// title: Text(title,
// style: robotoMedium.copyWith(
// fontSize: Dimensions.FONT_SIZE_LARGE,
// color: Theme.of(context).textTheme.bodyText1.color)),
// centerTitle: true,
// shape: ContinuousRectangleBorder(
// borderRadius: const BorderRadius.only(
// bottomRight: Radius.circular(20.0),
// bottomLeft: Radius.circular(20.0),
// ),
// ),
// leading: isBackButtonExist
// ? IconButton(
// icon: Icon(Icons.arrow_back_ios),
// color: Theme.of(context).textTheme.bodyText1.color,
// onPressed: () => onBackPressed != null
// ? onBackPressed()
//     : Navigator.pop(context),
// )
// : SizedBox(),
// backgroundColor: Colors.green,
//
// elevation: 0,
// bottom: TabBar(
// tabs: [
// Text(
// 'Details',
// style: TextStyle(fontSize: 16.0),
// ),
// Text(
// 'Recipe',
// style: TextStyle(fontSize: 16.0),
// ),
// Text(
// 'Reviews',
// style: TextStyle(fontSize: 16.0),
// ),
// ],
// ),
