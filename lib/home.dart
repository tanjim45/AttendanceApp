import 'package:attendance_app/attendenceservice.dart';
import 'package:attendance_app/authservice.dart';
import 'package:attendance_app/history.dart';
import 'package:attendance_app/markattendence.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final AttendanceService _attendanceService = AttendanceService();

  bool _todayMarked = false;
  bool _loadingStatus = true;

  @override
  void initState() {
    super.initState();
    _loadTodayStatus();
  }

  Future<void> _loadTodayStatus() async {
    final marked = await _attendanceService.isTodayMarked();
    if (!mounted) return;
    setState(() {
      _todayMarked = marked;
      _loadingStatus = false;
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure want to Logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yes')),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? user?.email ?? 'User';
    final today = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTodayStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wealcome, $name ',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(today, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 24),

              //  status card
              Card(
                color: _loadingStatus
                    ? Colors.grey[200]
                    : (_todayMarked ? Colors.green[50] : Colors.orange[50]),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _todayMarked
                            ? Icons.check_circle
                            : Icons.access_time,
                        color: _todayMarked ? Colors.green : Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _loadingStatus
                              ? 'Loading...'
                              : (_todayMarked
                                  ? 'Tooday attendance is Alredy Marked '
                                  : 'Tooday attendance is Not Marked'),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             
              const SizedBox(height: 32),

             
             
              // Mark Attendance 
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MarkAttendanceScreen()),
                  );
                  _loadTodayStatus(); //for refresh
                },
               
                icon: const Icon(Icons.fingerprint),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Mark Attendance', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),

             
             
              // History বাটন
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child:
                      Text('Attendance History', style: TextStyle(fontSize: 16)),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}