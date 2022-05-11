import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/public_asset_graph_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';

import 'error_message_widget.dart';
// import 'package:intl/intl.dart';



class ChartCardItem extends BaseStateFullWidget {

  final ChartsType chartType;
  final ChartFilters? filter;
  final Function(ChartFilters filter)? onFilterChanged;
  final chartTitleKey;
  final List<PublicAssetGraphModel>? historicalDataList;
  ChartCardItem({
    required this.chartType,
    this.chartTitleKey,
    this.historicalDataList,
    this.onFilterChanged,
    this.filter,
  });

  @override
  _ChartCardItemState createState() => _ChartCardItemState();
}

class _ChartCardItemState extends BaseStateFullWidgetState<ChartCardItem> {

  final BehaviorSubject<ChartFilters> filterController = BehaviorSubject<ChartFilters>.seeded(ChartFilters.xALL);
  get filterStream => filterController.stream;
  setFilterScreen(ChartFilters filter) => filterController.sink.add(filter);

  @override
  void dispose() {
    filterController.close();
    super.dispose();
  }

  @override
  void initState() {
    if(widget.filter!=null) setFilterScreen(widget.filter!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: double.infinity,
      // height: height* .40,
      padding: EdgeInsets.symmetric(vertical: height* .01),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: buildChartComponents(),
    );
  }

  Widget buildChartComponents(){
    switch(widget.chartType){
      case ChartsType.AREA:
        return StreamBuilder<ChartFilters>(
            initialData: ChartFilters.xALL,
            stream: filterStream,
            builder: (context, filterSnapshot) {
              return Column(
                children: [
                  if(widget.historicalDataList?.isNotEmpty??false) buildChartItem(filterSnapshot.data!),
                  if(widget.historicalDataList?.isEmpty??true) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16,),
                    child: ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildChartFilterItem(ChartFilters.x24H, filterSnapshot.data==ChartFilters.x24H,),
                        buildChartFilterItem(ChartFilters.x7D, filterSnapshot.data==ChartFilters.x7D,),
                        buildChartFilterItem(ChartFilters.x1M, filterSnapshot.data==ChartFilters.x1M,),
                        buildChartFilterItem(ChartFilters.x3M, filterSnapshot.data==ChartFilters.x3M,),
                        buildChartFilterItem(ChartFilters.x1Y, filterSnapshot.data==ChartFilters.x1Y,),
                        buildChartFilterItem(ChartFilters.xALL, filterSnapshot.data==ChartFilters.xALL,),
                      ],
                    ),
                  ),
                ],
              );
            }
        );

      case ChartsType.COLUMN:
        return buildColumnsChartItem();

      case ChartsType.COLUMN_ROUNDED_CORNER:
        return buildRoundedCornerColumnsChartItem();

      case ChartsType.RANGE_COLUMN:
        return buildRangeColumnsChartItem();

      case ChartsType.DOUGHNUT:
        return buildDoughnutChartItem();

      default: return Container();
    }
}

  Widget buildChartFilterItem(ChartFilters filter, isSelected){
    return GestureDetector(
      onTap: () {
        setFilterScreen(filter);
        if(widget.onFilterChanged!=null) widget.onFilterChanged!(filter,);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width* .02, vertical: height* .006),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          Utils.enumToString<ChartFilters>(filter).substring(1),
          style: TextStyle(
            color: AppColors.blue,
            height: 1.0,
            fontSize: AppFonts.getSmallFontSize(context),
          ),
        ),
      ),
    );
  }

  Widget buildChartItem(ChartFilters filter){
    // List<ChartData> chartData = getData(filter);
    List<ChartData> chartData = getData(filter);

    return Container(
      height: height* .20,
      child: SfCartesianChart(
        // primaryXAxis: DateTimeAxis(),
        // margin: EdgeInsets.symmetric(horizontal: width* .025, vertical: height* .025),
        series: <CartesianSeries<ChartData,DateTime>>[
          // Renders area chart
          AreaSeries<ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            borderDrawMode: BorderDrawMode.excludeBottom,
            borderColor: AppColors.blue,
            borderWidth: 1,
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
              colors: [
                AppColors.blue.withOpacity(.01),
                AppColors.blue.withOpacity(.25),
                AppColors.blue.withOpacity(.5),
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
            ),
          )
        ],
        zoomPanBehavior: ZoomPanBehavior(
          // enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.x,
        ),
        plotAreaBorderWidth: 0.0,
        // primaryXAxis: NumericAxis(
        //   majorGridLines: MajorGridLines(width: 0),
        //   axisLine: AxisLine(
        //     width: 0.0,
        //   ),
        //   tickPosition: TickPosition.outside,
        //   majorTickLines: MajorTickLines(width: 0),
        //     visibleMinimum: chartData[chartData.length-chartData.length~/2].year,
        //     visibleMaximum: chartData[chartData.length-chartData.length~/2].year,
        // ),
        primaryXAxis: DateTimeAxis(
          // intervalType: _getChartIntervalType(filter),
          visibleMinimum: chartData.length > 1 ? chartData[chartData.length-(chartData.length~/2)].x : (chartData[chartData.length-1].x),
          visibleMaximum: chartData[chartData.length-1].x,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0.0,),
          tickPosition: TickPosition.outside,
          majorTickLines: MajorTickLines(width: 0),autoScrollingMode: AutoScrollingMode.end,
        ),
        primaryYAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}K',
          // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
          majorGridLines: MajorGridLines(width: .03),
          axisLine: AxisLine(
            width: 0.0,
          ),
          majorTickLines: MajorTickLines(width: 0),
        ),
      ),
    );
  }

  Widget buildColumnsChartItem(){

    final List<SalesData> chartData = [
      SalesData('Property', getRandomInt(0, 100)),
      SalesData('Vehicle', getRandomInt(0, 100)),
      SalesData('Jewelry', getRandomInt(0, 100)),
      SalesData('Luxury', getRandomInt(0, 100)),
      SalesData('Electronics', getRandomInt(0, 100)),
      SalesData('Currency', getRandomInt(0, 100)),
      SalesData('Metals', getRandomInt(0, 100)),
      SalesData('Collectable', getRandomInt(0, 100)),
      SalesData('Other', getRandomInt(0, 100)),
    ];

    return Container(
      height: height* .22,
      child: SfCartesianChart(
          series: <CartesianSeries<SalesData, String>>[
            // Renders column chart
            ColumnSeries<SalesData, String>(
                dataSource: chartData,
                xValueMapper: (SalesData sales, _) => sales.category,
                yValueMapper: (SalesData sales, _) => sales.sales,
              color: AppColors.blue,
                width: 0.4, // Width of the bars
                // spacing: 0.5,
            ),
          ],
        plotAreaBorderWidth: 0.0,
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0.0,),
          majorTickLines: MajorTickLines(width: 0),
          labelStyle: TextStyle(
            fontSize: AppFonts.getXXSmallFontSize(context),
          ),
        ),
        primaryYAxis: NumericAxis(
          isVisible: false
        ),
      ),
    );
  }

  Widget buildRoundedCornerColumnsChartItem(){

    final List<SalesData> chartData = [
      SalesData(2024, getRandomInt(0, 100)),
      SalesData(2023, getRandomInt(0, 100)),
      SalesData(2022, getRandomInt(0, 100)),
      SalesData(2021, getRandomInt(0, 100)),
      SalesData(2020, getRandomInt(0, 100)),
    ];

    return Container(
      height: height* .26,
      child: SfCartesianChart(
        series: <CartesianSeries<SalesData, int>>[
          // Renders column chart
          ColumnSeries<SalesData, int>(
            dataSource: chartData,
            xValueMapper: (SalesData sales, _) => sales.category,
            yValueMapper: (SalesData sales, _) => sales.sales,
            color: AppColors.blue,
            width: 0.4,
            borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
            dataLabelSettings: DataLabelSettings(
              isVisible: widget.chartTitleKey!='projected_flow_cash' ? true : false, //TODO
              textStyle: TextStyle(color: Colors.white, fontSize: AppFonts.getXXSmallFontSize(context)),
              labelAlignment:  widget.chartTitleKey!=null ? ChartDataLabelAlignment.top : ChartDataLabelAlignment.outer,
            ),
          ),
        ],
        title: widget.chartTitleKey!=null ?
        ChartTitle(
          text: appLocal.trans(widget.chartTitleKey),
          alignment: ChartAlignment.center,
          textStyle: TextStyle(
            fontSize: AppFonts.getXSmallFontSize(context),
          ),
        ): null,
        plotAreaBorderWidth: 0.0,
        primaryXAxis: CategoryAxis(
          // isVisible: widget.chartTitleKey!=null,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0.0,),
          majorTickLines: MajorTickLines(width: 0),
          labelStyle: TextStyle(
            fontSize: AppFonts.getXXSmallFontSize(context),
          ),
        ),
        primaryYAxis: NumericAxis(
          isVisible: widget.chartTitleKey!=null,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: widget.chartTitleKey!=null ? '{value}K': '{value} m',
          // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
          majorGridLines: MajorGridLines(width: .03),
          axisLine: AxisLine(
            width: 0.0,
          ),
          majorTickLines: MajorTickLines(width: 0),
        ),
      ),
    );
  }

  Widget buildRangeColumnsChartItem(){

    final List<RangeChartData> chartData = [
      RangeChartData('Jan', 80, 0),
      RangeChartData('Feb', 100, 80),
      RangeChartData('Mar', 200.65, 100),
    ];

    return Container(
      height: height* .24,
      child: SfCartesianChart(
        series: <ChartSeries>[
          RangeColumnSeries<RangeChartData, String>(
            dataSource: chartData,
            xValueMapper: (RangeChartData data, _) => data.x,
            lowValueMapper: (RangeChartData data, _) => data.low,
            highValueMapper: (RangeChartData data, _) => data.high,

            color: AppColors.blue,
            width: 0.4,
            borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(color: Colors.white, fontSize: AppFonts.getXXSmallFontSize(context)),
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          )
        ],
        title: ChartTitle(
          text: appLocal.trans(widget.chartTitleKey),
          alignment: ChartAlignment.center,
          textStyle: TextStyle(fontSize: AppFonts.getXSmallFontSize(context),),
        ),
        plotAreaBorderWidth: 0.0,
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0.0,),
          majorTickLines: MajorTickLines(width: 0),
          labelStyle: TextStyle(fontSize: AppFonts.getXXSmallFontSize(context),),
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: .03),
          axisLine: AxisLine(width: 0.0,),
          majorTickLines: MajorTickLines(width: 0),
        ),
      ),
    );
  }

  Widget buildDoughnutChartItem(){
    final List<DoughnutChartData> chartData = [
      DoughnutChartData('Expense Reserve', 25, Color.fromRGBO(64,255,123,1)),
      DoughnutChartData('Management ', 38, Color.fromRGBO(165,253,236,1)),
      DoughnutChartData('Interest ', 34, Color.fromRGBO(0,118,255,1)),
      DoughnutChartData('Maintenance', 52, Color.fromRGBO(213,60,240,1))
    ];

    return Container(
      height: height* .3,
      child: SfCircularChart(
          // onCreateShader: (ChartShaderDetails chartShaderDetails) {
          //   return Gradient.sweep(
          //       chartShaderDetails.outerRect.center,
          //       colors,
          //       stops,
          //       TileMode.clamp,
          //       _degreeToRadian(0),
          //       _degreeToRadian(360),
          //       _resolveTransform(chartShaderDetails.outerRect, TextDirection.ltr)
          //   );
          // },
          series: <CircularSeries>[
            DoughnutSeries<DoughnutChartData, String>(
                dataSource: chartData,
                pointColorMapper:(DoughnutChartData data,  _) => data.color,
                xValueMapper: (DoughnutChartData data, _) => data.x,
                yValueMapper: (DoughnutChartData data, _) => data.y,
              dataLabelMapper: (DoughnutChartData data, _) => data.x,
                cornerStyle: CornerStyle.bothCurve,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(color: Colors.white, fontSize: AppFonts.getXSmallFontSize(context),),
                ),
              // strokeWidth: .5,
              innerRadius: '60.0',
            ),
          ],
          title: ChartTitle(
            text: appLocal.trans(widget.chartTitleKey),
            alignment: ChartAlignment.near,
            textStyle: TextStyle(
              fontSize: AppFonts.getXSmallFontSize(context),
            ),
          )
      ),
    );
  }


  // Rotate the sweep gradient according to the start angle
  Float64List _resolveTransform(Rect bounds, TextDirection? textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  // Convert degree to radian
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);



  dynamic getData(ChartFilters filter){
    List<ChartData> data = [];

    initRemoteData(data) {
      widget.historicalDataList?.forEach((element) {
        data.add(ChartData(element.date, element.value.toInt()));
      });
    }

    switch(filter){
      case ChartFilters.x24H:
        if(widget.historicalDataList!=null){
          initRemoteData(data);
        } else {
          for (int i =1; i < 25; i++){
            data.add(ChartData(DateTime(2021,1,1, i),getRandomInt(0, 1000)));
          }
        }

        break;

      case ChartFilters.x7D:
        if(widget.historicalDataList!=null){
          initRemoteData(data);
        } else {
          for (int i =0; i < 169; i++){
            data.add(ChartData(DateTime(2021,1,1, i),getRandomInt(0, 1000)));
          }
        }

        break;

      case ChartFilters.x1M:
        if(widget.historicalDataList!=null){
          initRemoteData(data);
        } else {
          for (int i =1; i < 31; i++){
            data.add(ChartData(DateTime(2021,1,i),getRandomInt(0, 1000)));
          }
        }

        break;

      case ChartFilters.x3M:
        if(widget.historicalDataList!=null){
          initRemoteData(data);
        } else {
          for (int i =1; i < 94; i++){
            data.add(ChartData(DateTime(2021,1,i),getRandomInt(0, 1000)));
          }
        }

        break;

      case ChartFilters.x1Y:
        if(widget.historicalDataList!=null){
          initRemoteData(data);
        } else {
          for (int i =1; i < 13; i++){
            data.add(ChartData(DateTime(2021,i,1),getRandomInt(0, 1000)));
          }
        }

        break;

      default:
        if(widget.historicalDataList!=null){
          initRemoteData(data);
        } else {
          for (int i =2000; i < 2020; i++){
            data.add(ChartData(DateTime(i,1,1),getRandomInt(0, 1000)));
          }
        }

        break;
    }

    return data;
  }
}

class SalesData {
  SalesData(this.category, this.sales);
  final dynamic category;
  final int sales;
}

class RangeChartData {
  RangeChartData(this.x, this.high, this.low);
  final String x;
  final double high;
  final double low;
}

DateTimeIntervalType _getChartIntervalType(ChartFilters filter){
  switch(filter){
    case ChartFilters.x24H:
      return DateTimeIntervalType.hours;

    case ChartFilters.x7D:
    case ChartFilters.x1M:
    case ChartFilters.x3M:
      return DateTimeIntervalType.days;

    case ChartFilters.x1Y:
      return DateTimeIntervalType.years;

    default:
      return DateTimeIntervalType.years;
  }
}



int getRandomInt(int min, int max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final int y;
}

class DoughnutChartData {
  DoughnutChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}