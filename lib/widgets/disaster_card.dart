// lib/widgets/disaster_card.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DisasterCard extends StatefulWidget {
  final String type;
  final String title;
  final String location;
  const DisasterCard({super.key, required this.type, required this.title, required this.location});

  @override
  State<DisasterCard> createState() => _DisasterCardState();
}

class _DisasterCardState extends State<DisasterCard> {
  bool _isPressed = false;

  Color _getTypeColor() => widget.type == 'Flood' ? AppTheme.primary : AppTheme.warning;

  IconData _getTypeIcon() => widget.type == 'Flood' ? Icons.water_drop : Icons.terrain;

  String _getStatusText() {
    // Mock status based on type for demo
    return widget.type == 'Flood' ? 'Monitoring' : 'Reported';
  }

  Color _getStatusColor() {
    final status = _getStatusText();
    if (status == 'Monitoring') return AppTheme.success;
    if (status == 'Reported') return AppTheme.warning;
    return AppTheme.neutral600;
  }

  Color _getStatusBackgroundColor() {
    final status = _getStatusText();
    if (status == 'Monitoring') return AppTheme.successContainer;
    if (status == 'Reported') return AppTheme.warningContainer;
    return AppTheme.surfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();
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
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(),
                    color: typeColor,
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
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.location,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusBackgroundColor(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: const Color(0xFF64748B),
                        size: 16,
                      ),
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
