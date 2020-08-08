import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/Models/users.dart';
import 'package:smart_meter/Models/weekModel.dart';
import 'package:smart_meter/Services/Database.dart';
import 'package:smart_meter/Services/auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smart_meter/layouts/Home/graph.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}
DateTime date = DateTime.now();
var weekstart_val = 0;
var weekend_val = 7;

class _HomeState extends State<Home> {
  void _showRattingBar(String data,total) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Info',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 400,
                    child: dayGraph(
                      day: data,
                      total:total,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  var weekstart =
      date.subtract(Duration(days: date.weekday - weekstart_val)).day;
  var weekend = date.subtract(Duration(days: date.weekday - weekend_val)).day;
  var chartWidget1;
  String currentUsage='';
  Future getweekdata() async {
    final user = Provider.of<User>(context,listen: false);
    final CollectionReference userPreferences =
        Firestore.instance.collection('Users');
    var a = await userPreferences
        .document(user.uid)
        .collection('Readings')
        .document(date.year.toString() + '.' + date.day.toString())
        .get();
    List<WeekModel> weekdata = [];
    print(weekstart.toString() + '-' + weekend.toString());
    var weekdays = ['sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat'];
    for (int i = weekstart, j = 0; i < weekend; i++, j++) {
      weekdata.add(WeekModel(weekdays[j], a.data[i.toString()]['daytotal'], Colors.blue));
    }
    setState(() {
      currentUsage=a.data[date.day.toString()]['daytotal'].toString();
    });
    print(weekdata);
    var series1 = [
      charts.Series(
          domainFn: (WeekModel clickData, _) => clickData.dayOfWeek,
          measureFn: (WeekModel clickData, _) => clickData.value,
          colorFn: (WeekModel clickData, _) => clickData.color,
          id: 'Clicks',
          data: weekdata,
          labelAccessorFn: (WeekModel clickData, _) => clickData.value.toString()
      ),
    ];
    var chart1 = charts.BarChart(
      series1,
      animate: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model){
            if(model.hasDatumSelection) {
              print(model.selectedSeries[0].domainFn(
                  model.selectedDatum[0].index));
              _showRattingBar(model.selectedSeries[0].domainFn(
                  model.selectedDatum[0].index),model.selectedSeries[0].measureFn(
                  model.selectedDatum[0].index));
            }
          }
        )
      ],
    );
    chartWidget1 = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart1,
      ),
    );
    return chartWidget1;
  }
//  void weekValue(DocumentSnapshot value) {
//  }

  WeekModel weekdata;
  var weekvaluieass;
  List<WeekModel> list;
  @override
  void initState() {
    super.initState();
    chartWidget1=getweekdata();
  }

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Meter'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _auth.signout();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text('')),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Today',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.chevron_left),
                Center(
                  child: CircularPercentIndicator(
                    radius: 150.0,
                    lineWidth: 3.0,
                    progressColor: Colors.blue,
                    percent: 0.9,
                    center: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            currentUsage,
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '₹300',
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ), //end of main tab
            SizedBox(
              height: 20,
            ),
            RaisedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.assistant),
              color: Colors.white,
              label: Text(
                'Try turning off the TV',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
            ),
            //chartWidget,
            chartWidget1,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final user = Provider.of<User>(context, listen: false);
          //var a= await DatabaseService(uid: user.uid).Getdata('2020.8');
          //print(a.data['1']);
          await DatabaseService(uid: user.uid).setData('2020.8');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
