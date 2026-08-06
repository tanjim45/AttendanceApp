import 'package:attendance_app/attendencemodel.dart';
import 'package:attendance_app/attendenceservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceService = AttendanceService();

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: StreamBuilder<List<AttendanceModel>>(
        stream: attendanceService.getHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No attendance record Found\n Start with Mark Attendance',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = records[index];
              final parsedDate = DateTime.tryParse(record.date);
              final displayDate = parsedDate != null
                  ? DateFormat('EEEE, dd MMM yyyy').format(parsedDate)
                  : record.date;

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: Text(displayDate,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Time: ${record.time}'),
                  trailing: Chip(
                    label: Text(record.status),
                    backgroundColor: Colors.green[100],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}