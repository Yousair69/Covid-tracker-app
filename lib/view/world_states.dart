import 'package:covid_tracker_app/models/world_states_model.dart';
import 'package:covid_tracker_app/services/state_services.dart';
import 'package:covid_tracker_app/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              FutureBuilder(
                  future: stateServices.fetchWorldStateRecord(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                          flex: 1,
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 50.0,
                            controller: _controller,
                          ));
                    } else {
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total": double.parse(
                                  snapshot.data!.cases!.toString()),
                              "Recovery": double.parse(
                                  snapshot.data!.recovered!.toString()),
                              "Death": double.parse(
                                  snapshot.data!.deaths!.toString()),
                            },
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.2,
                            animationDuration:
                                const Duration(milliseconds: 1200),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width * .06),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(
                                      title: 'Total',
                                      value: snapshot.data!.cases.toString()),
                                  ReusableRow(
                                      title: 'Deaths',
                                      value: snapshot.data!.deaths.toString()),
                                  ReusableRow(
                                      title: 'Recovered',
                                      value:
                                          snapshot.data!.recovered.toString()),
                                  ReusableRow(
                                      title: 'Active',
                                      value: snapshot.data!.active.toString()),
                                  ReusableRow(
                                      title: 'Critical',
                                      value:
                                          snapshot.data!.critical.toString()),
                                  ReusableRow(
                                      title: 'Today Deaths',
                                      value: snapshot.data!.todayDeaths
                                          .toString()),
                                  ReusableRow(
                                      title: 'Today Recovered',
                                      value: snapshot.data!.todayRecovered
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const
                                          CountiresListScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  ReusableRow({super.key, required this.title, required this.value});

  String title, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
