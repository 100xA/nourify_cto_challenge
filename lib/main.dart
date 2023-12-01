import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nourify_cto_challenge/cubit/garmin_cubit.dart';
import 'package:nourify_cto_challenge/cubit/garmin_state.dart';

import 'package:nourify_cto_challenge/data/garmin_data.dart';
import 'package:nourify_cto_challenge/firebase_options.dart';
import 'package:nourify_cto_challenge/data/repo/garmin_fb_repository.dart';
import 'package:nourify_cto_challenge/services/service_locator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// initializes all available Cubits for dependency injection
  setupServices();

  runApp(const ChartApp());
}

class ChartApp extends StatelessWidget {
  const ChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GarminCubit>.value(
      value: app.get<GarminCubit>()..initializeApp(),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 100,
        ),
        BlocBuilder<GarminCubit, GarminState>(
          builder: (context, state) {
            if (state is GarminSuccess) {
              return SfCartesianChart(
                title: ChartTitle(text: "Your Daily Data"),
                primaryXAxis: DateTimeAxis(
                  minimum: DateTime(2023, 11, 6),
                  maximum: DateTime(2023, 11, 7),
                ),
                series: <ChartSeries<GarminData, DateTime>>[
                  StackedLineSeries<GarminData, DateTime>(
                    groupName: "A",
                    dataSource: stressData,
                    xValueMapper: (GarminData sales, _) => sales.time,
                    yValueMapper: (GarminData sales, _) => sales.sales,
                    name: 'Stress',
                  ),
                  StackedLineSeries<GarminData, DateTime>(
                    groupName: "B",
                    dataSource: sleepData,
                    xValueMapper: (GarminData sales, _) => sales.time,
                    yValueMapper: (GarminData sales, _) => sales.sales,
                    name: 'Sleep',
                    width: 20,
                  ),
                  StackedLineSeries<GarminData, DateTime>(
                    groupName: "C",
                    dataSource: heartData,
                    xValueMapper: (GarminData sales, _) => sales.time,
                    yValueMapper: (GarminData sales, _) => sales.sales,
                    name: 'Heart',
                  ),
                  StackedLineSeries<GarminData, DateTime>(
                      groupName: "D",
                      dataSource: moveData,
                      xValueMapper: (GarminData sales, _) => sales.time,
                      yValueMapper: (GarminData sales, _) => sales.sales,
                      name: 'Move',
                      width: 20),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    ));
  }
}
