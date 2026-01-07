// lib/screens/community_screen.dart
import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/disaster_report.dart';
import '../theme/app_theme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  Color _credibilityColor(int score) {
    if (score >= 75) return AppTheme.success;
    if (score >= 50) return AppTheme.warning;
    return AppTheme.error;
  }

  void _upvote(String id) {
    MockDataService.upvote(id);
    setState(() {});
  }

  void _downvote(String id) {
    MockDataService.downvote(id);
    setState(() {});
  }

  void _addComment(String id) async {
    final controller = TextEditingController();
    final res = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add comment'),
        content: TextField(
          controller: controller, 
          autofocus: true, 
          maxLines: 3, 
          decoration: const InputDecoration(hintText: 'Write a comment')
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('Cancel')
          ), 
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()), 
            child: const Text('Post')
          )
        ],
      ),
    );
    if (res != null && res.isNotEmpty) {
      MockDataService.addComment(id, res);
      setState(() {});
    }
  }

  void _reshare(String id) {
    MockDataService.reshare(id);
    setState(() {});
  }

  void _report(String id) {
    MockDataService.removePost(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final posts = MockDataService.fetchPosts();
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Community Hub'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: posts.isEmpty 
        ? _buildEmptyState() 
        : LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 768;
              final maxWidth = isTablet ? 600.0 : double.infinity;
              
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: isTablet ? 24 : 16,
                      right: isTablet ? 24 : 16,
                      top: 16,
                      bottom: 120, // Space for expandable bottom nav
                    ),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) => _buildPostCard(posts[i], constraints),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildPostCard(DisasterReport r, BoxConstraints constraints) {
    final isNarrow = constraints.maxWidth < 400;
    final initials = r.username.isNotEmpty ? r.username[0] : 'U';
    
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(isNarrow ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(r, initials, isNarrow),
            const SizedBox(height: 12),
            _buildPostContent(r),
            if (r.hasMedia) ...[
              const SizedBox(height: 12),
              _buildMediaPreview(),
            ],
            const SizedBox(height: 16),
            _buildPostActions(r, isNarrow),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(DisasterReport r, String initials, bool isNarrow) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: isNarrow ? 18 : 20,
          backgroundColor: AppTheme.primary,
          child: Text(
            initials, 
            style: TextStyle(
              color: Colors.white,
              fontSize: isNarrow ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      r.username,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.slate800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: r.role == 'NGO' ? AppTheme.primary.withOpacity(0.1) : AppTheme.slate100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      r.role,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: r.role == 'NGO' ? AppTheme.primary : AppTheme.slate600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    '${_timeAgo(r.timestamp)} • ${r.location}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.slate500,
                    ),
                  ),
                  if (r.status.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.slate100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        r.status,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.slate600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              if (r.role == 'NGO' && r.isVerified) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 16, color: AppTheme.info),
                      const SizedBox(width: 6),
                      Text(
                        'Official NGO Update',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _credibilityColor(r.credibility).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${r.credibility}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _credibilityColor(r.credibility),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostContent(DisasterReport r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          r.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.slate700,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (r.severity.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, size: 14, color: AppTheme.error),
                    const SizedBox(width: 4),
                    Text(
                      'Severity: ${r.severity}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (r.isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 14, color: AppTheme.success),
                    const SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.slate100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image, size: 32, color: AppTheme.slate400),
            const SizedBox(height: 4),
            Text(
              'Media Attachment',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostActions(DisasterReport r, bool isNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton(
                  Icons.thumb_up_outlined, 
                  r.upvotes, 
                  false, 
                  () => _upvote(r.id),
                  isNarrow,
                ),
                SizedBox(width: isNarrow ? 8 : 12),
                _buildActionButton(
                  Icons.thumb_down_outlined, 
                  r.downvotes, 
                  false, 
                  () => _downvote(r.id),
                  isNarrow,
                ),
                SizedBox(width: isNarrow ? 8 : 12),
                _buildActionButton(
                  Icons.chat_bubble_outline, 
                  r.comments.length, 
                  false, 
                  () => _addComment(r.id),
                  isNarrow,
                ),
                SizedBox(width: isNarrow ? 8 : 12),
                _buildActionButton(
                  Icons.repeat, 
                  0, 
                  false, 
                  () => _reshare(r.id),
                  isNarrow,
                ),
              ],
            ),
          ),
        ),
        _buildActionButton(
          Icons.flag_outlined, 
          0, 
          false, 
          () => _report(r.id),
          isNarrow,
          isReport: true,
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, int count, bool active, VoidCallback onTap, bool isNarrow, {bool isReport = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? 8 : 10, 
          vertical: 6
        ),
        decoration: BoxDecoration(
          color: active 
            ? AppTheme.primary.withOpacity(0.1) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              size: isNarrow ? 16 : 18, 
              color: active 
                ? AppTheme.primary 
                : isReport 
                  ? AppTheme.error 
                  : AppTheme.slate500,
            ),
            if (count > 0 && !isReport) ...[
              const SizedBox(width: 4),
              Text(
                '$count',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: active ? AppTheme.primary : AppTheme.slate500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.slate100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.forum_outlined, 
                size: 48, 
                color: AppTheme.slate400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Community Posts Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.slate700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share a disaster report with the community!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.slate500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
