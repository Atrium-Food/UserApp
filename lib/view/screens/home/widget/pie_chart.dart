import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/view/screens/home/widget/pie_chart_indicator.dart';
import 'package:flutter/gestures.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class PieChartSample3 extends StatefulWidget {
  final Product product;

  PieChartSample3({this.product});

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<PieChartSample3> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              final desiredTouch = pieTouchResponse.touchInput
                                      is! PointerExitEvent &&
                                  pieTouchResponse.touchInput
                                      is! PointerUpEvent;
                              if (desiredTouch &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection.touchedSectionIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 5,
                          centerSpaceRadius: 0,
                          sections: showingSections(widget.product.nutrient)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          ),
        ),
        GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            mainAxisExtent: 30,
          ),
          children: <Widget>[
            Indicator(
              textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
              color: Colors.red,
              text: 'Fats',
              isSquare: false,
            ),
            Indicator(
              textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
              color: Color(0xfff8b250),
              text: 'Carbs',
              isSquare: false,
            ),
            Indicator(
              textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
              color: Color(0xff845bef),
              text: 'Protein',
              isSquare: false,
            ),
            Indicator(
              textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
              color: Color(0xff13d38e),
              text: 'Fiber',
              isSquare: false,
            ),
            Indicator(
              textColor: touchedIndex == 4 ? Colors.black : Colors.grey,
              color: Colors.grey,
              text: 'Sugar',
              isSquare: false,
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(Nutrient nutrient) {
    double total = nutrient.sugar +
        nutrient.protein +
        nutrient.fiber +
        nutrient.fats +
        nutrient.energy;

    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: (nutrient.fats / total) * 100,
            showTitle: false,
            radius: radius,
            badgeWidget: _Badge(
              (nutrient.fats / total) * 100,
              size: widgetSize,
              borderColor: Colors.red,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            showTitle: false,
            value: (nutrient.carbs / total) * 100,
            radius: radius,
            badgeWidget: _Badge(
              (nutrient.carbs / total) * 100,
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            showTitle: false,
            value: (nutrient.protein / total) * 100,
            radius: radius,
            badgeWidget: _Badge(
              (nutrient.protein / total) * 100,
              size: widgetSize,
              borderColor: const Color(0xff845bef),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: (nutrient.fiber / total) * 100,
            showTitle: false,
            radius: radius,
            badgeWidget: _Badge(
              (nutrient.fiber / total) * 100,
              size: widgetSize,
              borderColor: const Color(0xff13d38e),
            ),
            badgePositionPercentageOffset: .98,
          );

        case 4:
          return PieChartSectionData(
            color: Colors.grey,
            value: (nutrient.sugar / total) * 100,
            showTitle: false,
            radius: radius,
            badgeWidget: _Badge(
              (nutrient.sugar / total) * 100,
              size: widgetSize,
              borderColor: Colors.grey,
            ),
            badgePositionPercentageOffset: .98,
          );

        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final double percent;
  final double size;
  final Color borderColor;

  const _Badge(
    this.percent, {
    @required this.size,
    @required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
          child: Text(
        percent.toInt().toString(),
        style: TextStyle(
            color: borderColor, fontWeight: FontWeight.bold, fontSize: 11),
      )),
    );
  }
}
