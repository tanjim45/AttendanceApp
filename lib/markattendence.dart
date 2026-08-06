import 'package:attendance_app/attendenceservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  bool _isChecking = true;
  bool _isMarking = false;
  bool _alreadyMarked = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final marked = await _attendanceService.isTodayMarked();
    if (!mounted) return;
    setState(() {
      _alreadyMarked = marked;
      _isChecking = false;
    });
  }

  Future<void> _handleMarkAttendance() async {
    setState(() => _isMarking = true);

    final success = await _attendanceService.markAttendance();

    if (!mounted) return;
    setState(() {
      _isMarking = false;
      _alreadyMarked = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Attendance Succesfully Mark'
            : 'Todays attendance has already been marked'),
        backgroundColor: success ? Colors.green : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isChecking
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _alreadyMarked
                          ? Icons.check_circle
                          : Icons.fingerprint,
                      size: 100,
                      color: _alreadyMarked ? Colors.green : Colors.indigo,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      today,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _alreadyMarked
                          ? 'Todays attendance has already been marked.'
                          : 'Mark todays attendance by clicking the button below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: (_alreadyMarked || _isMarking)
                          ? null
                          : _handleMarkAttendance,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor:
                            _alreadyMarked ? Colors.grey : Colors.indigo,
                      ),
                      child: _isMarking
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Color.fromARGB(255, 14, 8, 8)),
                            )
                          : Text(
                              _alreadyMarked
                                  ? 'Already Marked'
                                  : 'Mark Present',
                              style: const TextStyle(fontSize: 16,color: Colors.black),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}