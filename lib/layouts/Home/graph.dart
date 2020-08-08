import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:smart_meter/Models/users.dart';
import 'package:smart_meter/Models/weekModel.dart';
import 'package:smart_meter/Shared/loading.dart';

DateTime date = DateTime.now();
var weekstart_val = 0;
var weekend_val = 7;
var weekend = date.subtract(Duration(days: date.weekday - weekend_val)).day;
var chartWidget1;
String currentUsage = '';

class dayGraph extends StatefulWidget {
  String day;
  int total;
  dayGraph({this.day,this.total});

  @override
  _dayGraphState createState() => _dayGraphState();
}

class _dayGraphState extends State<dayGraph> {

  Future getweekdata(String day) async {
    final user = Provider.of<User>(context, listen: false);
    final CollectionReference userPreferences =
        Firestore.instance.collection('Users');
    var a = await userPreferences
        .document(user.uid)
        .collection('Readings')
        .document(date.year.toString() + '.' + date.day.toString())
        .get();
    return a;
  }

  Charts(String day, a) {
    List<WeekModel> weekdata = [];
//    print(weekstart.toString() + '-' + weekend.toString());
    var weekdays = ['sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat'];
    int dayTemp = 0;
    for (String a in weekdays) {
      if (a.compareTo(day) == 0) {
        print(dayTemp);
      }
      dayTemp++;
    }
//    dayTemp.toString()
    var weekstart =
        date.subtract(Duration(days: date.weekday - dayTemp)).day;
    for (int i = 0; i < 24; i++) {
      weekdata.add(WeekModel(
          i.toString(), a.data[weekstart.toString()]['value'][i], Colors.blue));
    }
//    setState(() {
//      currentUsage=a.data[date.day.toString()]['daytotal'].toString();
//    });
    print(weekdata[0].value);
    var series1 = [
      charts.Series(
          domainFn: (WeekModel clickData, _) => clickData.dayOfWeek,
          measureFn: (WeekModel clickData, _) => clickData.value,
          colorFn: (WeekModel clickData, _) => clickData.color,
          id: 'Clicks',
          data: weekdata,
          labelAccessorFn: (WeekModel clickData, _) =>
              clickData.value.toString()),
    ];
    var chart1 = charts.BarChart(
      series1,
      animate: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            print(
                model.selectedSeries[0].domainFn(model.selectedDatum[0].index));
          }
        })
      ],
    );
    chartWidget1 = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 200.0,
        width: 1000.0,
        child: chart1,
      ),
    );
    return chartWidget1;
  }
  @override
  Widget build(BuildContext context) {
    String todayString=widget.day;
    return new FutureBuilder<dynamic>(
        future: getweekdata(widget.day), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('error getting data');
            case ConnectionState.waiting:
              return Loading();
            default:
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else {
                return SingleChildScrollView(
                  child:Column(
                    children: [
                      Text(
                        'Values of '+todayString,
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      Charts(widget.day, snapshot),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Total power used today '+widget.total.toString(),
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                );
              }
          }
        });
  }
}
