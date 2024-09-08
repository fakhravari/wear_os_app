import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthScreen extends StatelessWidget {
  final List<HealthDataPoint> _healthData;
  final Map<HealthDataType, String> _statusMap;

  const HealthScreen(this._healthData, this._statusMap, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0, // حذف ارتفاع AppBar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: Colors.grey,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Health Data'),
                  Tab(text: 'Status'),
                ],
                labelStyle: TextStyle(
                  fontSize: 7,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 7,
                ),
                indicatorColor: Colors.white,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: _healthData.length,
              itemBuilder: (context, index) {
                final data = _healthData[index];
                final value = (data.value as NumericHealthValue).numericValue;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    title: Text(
                      '${data.type.toString().split('.').last}: $value ${data.unit.toString().split('.').last}',
                      style: const TextStyle(
                        fontSize: 10.0, // فونت کوچک برای عنوان
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Date: ${data.dateFrom}',
                      style: const TextStyle(
                        fontSize: 8.0, // فونت کوچک برای زیرعنوان
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
            ListView(
              padding: const EdgeInsets.all(8),
              children: _statusMap.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    title: Text(
                      '${entry.key.toString().split('.').last}: ${entry.value}',
                      style: const TextStyle(
                        fontSize: 10.0, // فونت کوچک برای وضعیت‌ها
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
