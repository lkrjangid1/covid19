import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid19',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getCasesData() async {
    try {
      http.Response response = await http
          .get(Uri.parse('https://api.rootnet.in/covid19-in/stats/latest'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
    } catch (e) {
      print(e);
    }
  }
  Future getVaccineData() async {
    try {
      http.Response response = await http
          .get(Uri.parse('https://www.mygov.in/sites/default/files/covid/vaccine/vaccine_counts_today.json'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Covid19'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TabBar(tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Cases',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('vaccine', style: TextStyle(color: Colors.black)),
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  Container(
                    child: FutureBuilder(
                      future: getCasesData(),
                      builder: (context, snapShot) {
                        if (!snapShot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          var summeryData = snapShot.data['summary'];
                          List regionalData = snapShot.data['regional'].toList();
                          return Container(
                            child: Column(children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Total Cases',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${summeryData['total'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      color: Colors.pinkAccent,
                                      width: 100,
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Deaths',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${summeryData['deaths'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      color: Colors.redAccent,
                                      width: 100,
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Discharged',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${summeryData['discharged'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      color: Colors.greenAccent,
                                      width: 100,
                                      height: 60,
                                    ),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: regionalData.length,
                                  itemBuilder: (context,index){
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('${regionalData[index]['loc'].toString()}'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Total Cases :'),
                                                Text('${regionalData[index]['confirmedCasesIndian'].toString()}'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Discharged :'),
                                                Text('${regionalData[index]['discharged'].toString()}'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Deaths :'),
                                                Text('${regionalData[index]['deaths'].toString()}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ]),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                      future: getVaccineData(),
                      builder: (context, snapShot) {
                        if (!snapShot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          List vaccData = snapShot.data['vacc_st_data'].toList();
                          return Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Total Dose1',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${snapShot.data['india_dose1'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          color: Colors.pinkAccent,
                                          width: 100,
                                          height: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Total Dose2',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${snapShot.data['india_dose2'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          color: Colors.redAccent,
                                          width: 100,
                                          height: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Total Dose',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${snapShot.data['india_total_doses'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          color: Colors.greenAccent,
                                          width: 100,
                                          height: 60,
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: vaccData.length,
                                      itemBuilder: (context,index){
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            width: double.infinity,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('${vaccData[index]['covid_state_name'].toString()}'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Total dose1 :'),
                                                    Text('${vaccData[index]['dose1'].toString()}'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Total dose2 :'),
                                                    Text('${vaccData[index]['dose2'].toString()}'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Total doses :'),
                                                    Text('${vaccData[index]['total_doses'].toString()}'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ]),
                          );
                        }
                      },
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
