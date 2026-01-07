// lib/screens/report_screen.dart
import 'package:flutter/material.dart';
import '../models/disaster_report.dart';
import '../services/mock_data_service.dart';
import '../theme/app_theme.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Flood';
  String _description = '';
  final String _mockLocation = 'Mocked Location: 12.3456, -98.7654';
  bool _submitting = false;

  // Mocked media previews (UI-only identifiers)
  final List<String> _mediaPreviews = [];

  void _addMockMedia(String type) {
    setState(() {
      _mediaPreviews.add('$type-${DateTime.now().millisecondsSinceEpoch}');
    });
  }

  void _removeMedia(String id) {
    setState(() {
      _mediaPreviews.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Report Disaster'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 768;
            final maxWidth = isTablet ? 600.0 : double.infinity;
            final padding = isTablet ? 32.0 : 16.0;
            
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: padding,
                    right: padding,
                    top: padding,
                    bottom: 120, // Space for expandable bottom nav
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeaderCard(context, isTablet),
                        const SizedBox(height: 24),
                        _buildReportForm(context, isTablet),
                        const SizedBox(height: 24),
                        _buildMediaSection(context, isTablet),
                        const SizedBox(height: 24),
                        _buildLocationCard(context, isTablet),
                        const SizedBox(height: 32),
                        _buildActionButtons(context, isTablet),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.report_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Disaster Report',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Help your community by reporting disasters',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportForm(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disaster Type',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.slate800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.slate200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'Flood', child: Text('🌊 Flood')),
                  DropdownMenuItem(value: 'Earthquake', child: Text('🏔️ Earthquake')),
                  DropdownMenuItem(value: 'Landslide', child: Text('⛰️ Landslide')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'Flood'),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.slate400),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.slate800,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Describe what you observed, including location details, severity, and any immediate dangers...',
              hintStyle: TextStyle(color: AppTheme.slate400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.slate200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.slate200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
              filled: true,
              fillColor: AppTheme.slate50,
            ),
            onChanged: (v) => setState(() => _description = v),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a description' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Media (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.slate800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Photos and videos help verify your report',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.slate500,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildMediaButton(
                Icons.camera_alt,
                'Camera',
                () => _addMockMedia('camera'),
                isTablet,
              ),
              _buildMediaButton(
                Icons.photo_library,
                'Gallery',
                () => _addMockMedia('gallery'),
                isTablet,
              ),
              _buildMediaButton(
                Icons.videocam,
                'Video',
                () => _addMockMedia('video'),
                isTablet,
              ),
            ],
          ),
          if (_mediaPreviews.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _mediaPreviews.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => _buildMediaPreview(_mediaPreviews[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaButton(IconData icon, String label, VoidCallback onTap, bool isTablet) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: AppTheme.slate50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.slate200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: isTablet ? 24 : 20, color: AppTheme.slate600),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.slate600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview(String id) {
    final type = id.split('-').first;
    return Stack(
      children: [
        Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.slate100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type == 'camera' ? Icons.camera_alt : 
                  type == 'gallery' ? Icons.image : Icons.videocam,
                  size: 24,
                  color: AppTheme.slate500,
                ),
                const SizedBox(height: 4),
                Text(
                  type.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.slate500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeMedia(id),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.location_on,
              color: AppTheme.info,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.slate800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _mockLocation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.slate500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _submitting ? null : _onSubmit,
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_submitting) ...[
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Submitting...',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ] else ...[
                      const Icon(Icons.send, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Submit Report',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.slate200),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _formKey.currentState?.reset();
                setState(() {
                  _type = 'Flood';
                  _description = '';
                  _mediaPreviews.clear();
                });
              },
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: AppTheme.slate600, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Reset Form',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.slate600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 350));

    final newPost = DisasterReport(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      username: 'You',
      role: 'Citizen',
      description: _description.trim(),
      upvotes: 0,
      downvotes: 0,
      comments: [],
      hasMedia: _mediaPreviews.isNotEmpty,
      timestamp: DateTime.now(),
      location: _mockLocation,
      credibility: 60,
      type: _type,
    );

    MockDataService.addPost(newPost);

    // Report submitted successfully - navigation handled by drawer system

    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Report submitted successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
    _formKey.currentState?.reset();
    setState(() {
      _type = 'Flood';
      _mediaPreviews.clear();
      _description = '';
    });
  }

  @override
  bool get wantKeepAlive => true;
}
