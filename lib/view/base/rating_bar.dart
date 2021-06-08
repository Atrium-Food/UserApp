import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  RatingBar({@required this.rating, this.size = 18,this.color});

  @override
  Widget build(BuildContext context) {
    List<Widget> _starList = [];

    int realNumber = rating.floor();
    int partNumber = ((rating - realNumber) * 10).ceil();

    for (int i = 0; i < 5; i++) {
      if (i < realNumber) {
        _starList.add(Icon(Icons.star, color: ColorResources.getGrayColor(context), size: size));
      } else if (i == realNumber) {
        _starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(Icons.star, color: this.color!=null?this.color:ColorResources.getAccentColor(context), size: size),
              ClipRect(
                clipper: _Clipper(part: partNumber),
                child: Icon(Icons.star_border, color: this.color!=null?this.color:ColorResources.getAccentColor(context), size: size),
              )
            ],
          ),
        ));
      } else {
        _starList.add(Icon(Icons.star_border, color: this.color!=null?this.color:ColorResources.getAccentColor(context), size: size));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _starList,
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final int part;

  _Clipper({@required this.part});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      (size.width / 10) * part,
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
