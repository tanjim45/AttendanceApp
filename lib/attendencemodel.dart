import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String date; 
  final String time;  
  final String status; 

  AttendanceModel({
    required this.date,
    required this.time,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      status: map['status'] ?? '',
    );
  }
}