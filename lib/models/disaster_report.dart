// lib/models/disaster_report.dart
class DisasterReport {
  String id;
  String username;
  String role;
  String description;
  int upvotes;
  int downvotes;
  List<String> comments;
  bool hasMedia;
  DateTime timestamp;
  String location;
  int credibility;
  String type;
  String status;
  String severity;
  bool isVerified;

  DisasterReport({
    required this.id,
    required this.username,
    required this.role,
    required this.description,
    this.upvotes = 0,
    this.downvotes = 0,
    List<String>? comments,
    this.hasMedia = false,
    required this.timestamp,
    this.location = '',
    this.credibility = 50,
    this.type = 'Flood',
    this.status = 'Pending',
    this.severity = 'Low',
    this.isVerified = false,
  }) : comments = comments ?? [];

  // compatibility getter used in other files
  DateTime get time => timestamp;
}
