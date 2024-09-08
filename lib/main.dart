import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:wear_os_app/HealthScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HealthDataScreen(),
        ));
  }
}

class HealthDataScreen extends StatefulWidget {
  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  final Health _health = Health();
  List<HealthDataPoint> _healthData = [];
  bool _isAuthorized = false;
  Map<HealthDataType, String> _statusMap = {};

  @override
  void initState() {
    super.initState();
    _initHealth();
  }

  Future<void> _initHealth() async {
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    ];

    final permissions = List.filled(types.length, HealthDataAccess.READ);

    _isAuthorized =
        await _health.requestAuthorization(types, permissions: permissions);

    if (_isAuthorized) {
      _fetchHealthData();
    } else {
      print('Access not granted');
      _generateFakeData();
    }
  }

  Future<void> _fetchHealthData() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 3));
    final endDate = now;

    try {
      final healthData = await _health.getHealthDataFromTypes(
        types: [
          HealthDataType.HEART_RATE,
          HealthDataType.STEPS,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.BLOOD_OXYGEN,
          HealthDataType.WEIGHT,
          HealthDataType.HEIGHT,
          HealthDataType.BODY_FAT_PERCENTAGE,
          HealthDataType.BLOOD_GLUCOSE,
          HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        ],
        startTime: startDate,
        endTime: endDate,
      );

      if (healthData.isEmpty) {
        _generateFakeData();
      } else {
        setState(() {
          _healthData = healthData;
          _calculateStatus();
        });
      }
    } catch (e) {
      print('Error fetching health data: $e');
    }
  }

  void _generateFakeData() {
    final now = DateTime.now();
    final random = Random();
    final fakeData = List.generate(60, (index) {
      final dateFrom = now.subtract(Duration(seconds: index));

      // Generating fake data for different types
      return [
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 60 + random.nextInt(40)),
          type: HealthDataType.HEART_RATE,
          unit: HealthDataUnit.BEATS_PER_MINUTE,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 1000 + random.nextInt(5000)),
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 200 + random.nextInt(500)),
          type: HealthDataType.ACTIVE_ENERGY_BURNED,
          unit: HealthDataUnit.KILOCALORIE,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value:
              NumericHealthValue(numericValue: 90 + random.nextDouble() * 10),
          type: HealthDataType.BLOOD_OXYGEN,
          unit: HealthDataUnit.PERCENT,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 50 + random.nextInt(50)),
          type: HealthDataType.WEIGHT,
          unit: HealthDataUnit.KILOGRAM,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 150 + random.nextInt(30)),
          type: HealthDataType.HEIGHT,
          unit: HealthDataUnit.METER,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: random.nextDouble() * 20),
          type: HealthDataType.BODY_FAT_PERCENTAGE,
          unit: HealthDataUnit.PERCENT,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 70 + random.nextInt(20)),
          type: HealthDataType.BLOOD_GLUCOSE,
          unit: HealthDataUnit.MILLIGRAM_PER_DECILITER,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 100 + random.nextInt(40)),
          type: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          unit: HealthDataUnit.MILLIMETER_OF_MERCURY,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 60 + random.nextInt(30)),
          type: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
          unit: HealthDataUnit.MILLIMETER_OF_MERCURY,
          dateFrom: dateFrom,
          dateTo: dateFrom,
          sourceId: 'fake_source',
          sourceName: 'Fake Health Data',
          uuid: 'uuid_$index',
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'device_$index',
        ),
      ];
    }).expand((element) => element).toList();

    setState(() {
      _healthData = fakeData;
      _calculateStatus();
    });
  }

  void _calculateStatus() {
    final statusMap = <HealthDataType, String>{};

    final groupedData = <HealthDataType, List<double>>{};
    for (var data in _healthData) {
      if (data.value is NumericHealthValue) {
        final value =
            (data.value as NumericHealthValue).numericValue.toDouble();
        final type = data.type;
        if (!groupedData.containsKey(type)) {
          groupedData[type] = [];
        }
        groupedData[type]?.add(value);
      }
    }

    groupedData.forEach((type, values) {
      if (values.isNotEmpty) {
        double average = values.reduce((a, b) => a + b) / values.length;
        double min = values.reduce((a, b) => a < b ? a : b);
        double max = values.reduce((a, b) => a > b ? a : b);

        String status;
        switch (type) {
          case HealthDataType.HEART_RATE:
            status = average >= 60 && average <= 100
                ? "وضعیت خوب: میانگین ضربان قلب شما نرمال است (${average.toStringAsFixed(2)} bpm)."
                : average < 60
                    ? "هشدار: ضربان قلب شما پایین‌تر از حد نرمال است (${average.toStringAsFixed(2)} bpm)."
                    : "هشدار: ضربان قلب شما بالاتر از حد نرمال است (${average.toStringAsFixed(2)} bpm).";
            if (min < 50) {
              status +=
                  "\nتوجه: ضربان قلب شما در برخی لحظات به شدت پایین بوده است (${min.toStringAsFixed(2)} bpm).";
            }
            if (max > 120) {
              status +=
                  "\nتوجه: ضربان قلب شما در برخی لحظات به شدت بالا بوده است (${max.toStringAsFixed(2)} bpm).";
            }
            break;
          case HealthDataType.STEPS:
            status =
                "میانگین تعداد گام‌های شما: ${average.toStringAsFixed(0)} steps.";
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            status =
                "میانگین کالری سوزانده شده: ${average.toStringAsFixed(2)} kcal.";
            break;
          case HealthDataType.BLOOD_OXYGEN:
            status = "میانگین درصد اکسیژن خون: ${average.toStringAsFixed(2)}%.";
            break;
          case HealthDataType.WEIGHT:
            status = "میانگین وزن شما: ${average.toStringAsFixed(2)} kg.";
            break;
          case HealthDataType.HEIGHT:
            status = "میانگین قد شما: ${average.toStringAsFixed(2)} m.";
            break;
          case HealthDataType.BODY_FAT_PERCENTAGE:
            status = "میانگین درصد چربی بدن: ${average.toStringAsFixed(2)}%.";
            break;
          case HealthDataType.BLOOD_GLUCOSE:
            status =
                "میانگین سطح قند خون: ${average.toStringAsFixed(2)} mg/dL.";
            break;
          case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
            status =
                "میانگین فشار خون سیستولیک: ${average.toStringAsFixed(2)} mmHg.";
            break;
          case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
            status =
                "میانگین فشار خون دیاستولیک: ${average.toStringAsFixed(2)} mmHg.";
            break;
          default:
            status = "داده‌ای برای این نوع سلامت یافت نشد.";
        }

        statusMap[type] = status;
      } else {
        statusMap[type] = "هیچ داده‌ای برای این نوع سلامت یافت نشد.";
      }
    });

    setState(() {
      _statusMap = statusMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HealthScreen(_healthData, _statusMap),
    );
  }
}
