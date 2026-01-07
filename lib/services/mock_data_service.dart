// lib/services/mock_data_service.dart
import '../models/disaster_report.dart';

class MockDataService {
  // in-memory posts list (singleton-style)
  static final List<DisasterReport> posts = List.generate(
    6,
    (i) => DisasterReport(
      id: 'p$i',
      username: 'User$i',
      role: (i % 3 == 0) ? 'NGO' : 'Citizen',
      description: 'Mocked report #$i with observed effects and notes. This is sample content to demonstrate the feed.',
      upvotes: i * 2,
      downvotes: i,
      comments: ['Thanks', 'Stay safe'],
      hasMedia: i % 3 == 0,
      timestamp: DateTime.now().subtract(Duration(minutes: i * 14)),
      location: i % 2 == 0 ? 'Riverside Ave' : 'Hilltop St',
      credibility: 40 + (i * 11) % 60,
      type: i % 2 == 0 ? 'Flood' : 'Earthquake',
      status: i % 3 == 0 ? 'In Progress' : 'Pending',
      severity: (i % 3 == 0) ? 'High' : (i % 3 == 1 ? 'Medium' : 'Low'),
      isVerified: i % 3 == 0,
    ),
  );

  static List<DisasterReport> fetchPosts() => posts;

  static void addPost(DisasterReport p) {
    posts.insert(0, p);
  }

  static void removePost(String id) {
    posts.removeWhere((p) => p.id == id);
  }

  static void upvote(String id) {
    final p = posts.firstWhere((p) => p.id == id, orElse: () => throw StateError('Post not found'));
    p.upvotes += 1;
  }

  static void downvote(String id) {
    final p = posts.firstWhere((p) => p.id == id, orElse: () => throw StateError('Post not found'));
    p.downvotes += 1;
  }

  static void addComment(String id, String comment) {
    final p = posts.firstWhere((p) => p.id == id, orElse: () => throw StateError('Post not found'));
    p.comments.add(comment);
  }

  static void reshare(String id) {
    final p = posts.firstWhere((p) => p.id == id, orElse: () => throw StateError('Post not found'));
    final copy = DisasterReport(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      username: p.username,
      role: p.role,
      description: p.description,
      upvotes: 0,
      downvotes: 0,
      comments: [],
      hasMedia: p.hasMedia,
      timestamp: DateTime.now(),
      location: p.location,
      credibility: p.credibility,
      type: p.type,
    );
    posts.insert(0, copy);
  }

  // role storage
  static String currentRole = 'Citizen'; // Default to Citizen for testing
  static void setRole(String r) => currentRole = r;

  static void changeStatus(String id, String status) {
    final p = posts.firstWhere((p) => p.id == id, orElse: () => throw StateError('Post not found'));
    p.status = status;
  }

  static void postOfficialUpdate(String message) {
    final post = DisasterReport(
      id: 'ngo${DateTime.now().millisecondsSinceEpoch}',
      username: 'Official NGO',
      role: 'NGO',
      description: message,
      upvotes: 0,
      downvotes: 0,
      comments: [],
      hasMedia: false,
      timestamp: DateTime.now(),
      location: 'Official',
      credibility: 100,
      type: 'Update',
      status: 'Resolved',
      severity: 'Low',
      isVerified: true,
    );
    posts.insert(0, post);
  }

  // Compatibility methods used elsewhere in the app
  static Future<Map<String, dynamic>> fetchWeatherSummary() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'temp': 25, 'condition': 'Sunny', 'humidity': 47};
  }

  static Future<List<Map<String, dynamic>>> fetchAlerts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {'id': 'a1', 'type': 'Flood', 'title': 'River rising', 'severity': 'Warning', 'time': DateTime.now().toIso8601String()},
      {'id': 'a2', 'type': 'Earthquake', 'title': 'Minor tremor', 'severity': 'Watch', 'time': DateTime.now().toIso8601String()},
    ];
  }
}
