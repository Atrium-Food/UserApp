import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String btnTxt;
  final Color backgroundColor;
  final Widget child;
  final Color inactiveColor;
  CustomButton(
      {this.onTap,
      @required this.btnTxt,
      this.backgroundColor,
      this.child,
      this.inactiveColor = ColorResources.COLOR_GREY});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null
          ? inactiveColor
          : backgroundColor == null
              ? Theme.of(context).primaryColor
              : backgroundColor,
      minimumSize: Size(MediaQuery.of(context).size.width, 50),
      elevation: 3.0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );

    return TextButton(
      onPressed: onTap,
      style: flatButtonStyle,
      child: child == null
          ? Text(
              btnTxt ?? "",
              style: Theme.of(context).textTheme.headline3.copyWith(
                  color: ColorResources.getAccentColor(context),
                  fontSize: Dimensions.FONT_SIZE_LARGE),
              textAlign: TextAlign.center,
            )
          : child,
    );
  }
}
