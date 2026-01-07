// lib/screens/ngo_report_management_screen.dart
import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';

class NGOReportManagementScreen extends StatefulWidget {
  const NGOReportManagementScreen({super.key});

  @override
  State<NGOReportManagementScreen> createState() => _NGOReportManagementScreenState();
}

class _NGOReportManagementScreenState extends State<NGOReportManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final posts = MockDataService.fetchPosts();
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Manage Reports'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final p = posts[i];
          return ListTile(
            title: Text(p.description),
            subtitle: Text('Severity: ${p.severity} • Status: ${p.status}'),
            trailing: DropdownButton<String>(
              value: p.status,
              items: const [DropdownMenuItem(value: 'Pending', child: Text('Pending')), DropdownMenuItem(value: 'In Progress', child: Text('In Progress')), DropdownMenuItem(value: 'Resolved', child: Text('Resolved'))],
              onChanged: (v) {
                if (v == null) return;
                MockDataService.changeStatus(p.id, v);
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
