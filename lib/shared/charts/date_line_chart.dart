
// import 'package:charts_flutter/flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:fyt/models/weightList.dart';

// class DateTimeComboLinePointChart extends StatelessWidget {
//   final List<Series> seriesList;
//   final bool animate;

//   DateTimeComboLinePointChart(this.seriesList, {required this.animate});

//   factory DateTimeComboLinePointChart.withData(data) {
//     return new DateTimeComboLinePointChart(
//       _createData(data),
//       animate: false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new TimeSeriesChart(seriesList,
//       animate: animate,
//       primaryMeasureAxis: new NumericAxisSpec(
//         tickProviderSpec: new BasicNumericTickProviderSpec(zeroBound: true),
//         renderSpec: GridlineRendererSpec(
//           lineStyle: LineStyleSpec(
//             dashPattern: [10, 10],
//           )
//         )
//       ),
//       domainAxis: new DateTimeAxisSpec(
//         tickFormatterSpec: new AutoDateTimeTickFormatterSpec(
//           day: new TimeFormatterSpec(
//             format: 'd', transitionFormat: 'MM/dd/yyyy'
//           )
//         )
//       )
//     );
//   }

//   static List<Series<SubmissionData, DateTime>> _createData(
//       List<WeightList> data) {
//     var tempData = <SubmissionData>[];
//     data.forEach((e) {
//       var tempDate = DateTime.parse(e.date!);
//       tempData.add(new SubmissionData(new DateTime(tempDate.year, tempDate.month, tempDate.day), e.weight));
//     });

//     return [
//       new Series<SubmissionData, DateTime>(
//         id: 'Sales',
//         colorFn: (_, __) => MaterialPalette.red.shadeDefault,
//         domainFn: (SubmissionData sales, _) => sales.time,
//         measureFn: (SubmissionData sales, _) => sales.sales,
//         measureLowerBoundFn: (SubmissionData sales, _) => sales.sales - 5,
//         measureUpperBoundFn: (SubmissionData sales, _) => sales.sales + 5,
//         data: tempData,
//       )
//     ];
//   }
// }

// /// Sample time series data type.
// class SubmissionData {
//   final DateTime time;
//   final int sales;

//   SubmissionData(this.time, this.sales);
// }
