import 'package:attendance_app/attendencemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _recordsRef =>
      _firestore.collection('attendance').doc(_uid).collection('records');

  // today date aformate
  String get todayDateId => DateFormat('yyyy-MM-dd').format(DateTime.now());

  // if there any mark chek
  Future<bool> isTodayMarked() async {
    final doc = await _recordsRef.doc(todayDateId).get();
    return doc.exists;
  }

  Future<bool> markAttendance() async {
    final alreadyMarked = await isTodayMarked();
    if (alreadyMarked) return false;

    final now = DateTime.now();
    final record = AttendanceModel(
      date: todayDateId,
      time: DateFormat('hh:mm a').format(now),
      status: 'Present',
    );

    await _recordsRef.doc(todayDateId).set(record.toMap());
    return true;
  }

  //attendence history strem )
  Stream<List<AttendanceModel>> getHistoryStream() {
    return _recordsRef
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AttendanceModel.fromMap(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
