// lib/widgets/alert_card.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AlertCard extends StatefulWidget {
  final String title;
  final String severity;
  final String type;
  final String time;
  const AlertCard({super.key, required this.title, required this.severity, required this.type, required this.time});

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  bool _isPressed = false;

  Color _accentForType() => widget.type == 'Flood' ? AppTheme.primary : AppTheme.warning;

  Color _backgroundColorForSeverity() {
    final sev = widget.severity.toLowerCase();
    if (sev.contains('warn')) return AppTheme.warningContainer;
    if (sev.contains('watch')) return AppTheme.successContainer;
    return AppTheme.errorContainer;
  }

  Color _textColorForSeverity() {
    final sev = widget.severity.toLowerCase();
    if (sev.contains('warn')) return AppTheme.warning;
    if (sev.contains('watch')) return AppTheme.success;
    return AppTheme.error;
  }

  IconData _iconForSeverity() {
    final sev = widget.severity.toLowerCase();
    if (sev.contains('warn')) return Icons.warning_amber_rounded;
    if (sev.contains('watch')) return Icons.info_outline;
    return Icons.error_outline;
  }

  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentForType();
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isPressed ? 0.08 : 0.05),
            blurRadius: _isPressed ? 12 : 10,
            offset: Offset(0, _isPressed ? 4 : 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          onHighlightChanged: (pressed) => setState(() => _isPressed = pressed),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconForSeverity(),
                    color: accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _backgroundColorForSeverity(),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.severity,
                              style: textTheme.bodySmall?.copyWith(
                                color: _textColorForSeverity(),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.type,
                            style: textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(widget.time),
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.chevron_right,
                      color: const Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
