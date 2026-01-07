// lib/screens/location_calibration_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LocationCalibrationScreen extends StatefulWidget {
  const LocationCalibrationScreen({super.key});

  @override
  State<LocationCalibrationScreen> createState() => _LocationCalibrationScreenState();
}

class _LocationCalibrationScreenState extends State<LocationCalibrationScreen> {
  bool _isCalibrating = false;
  String _currentLocation = 'Location not detected';
  double _accuracy = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Location Calibration'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 768;
            final padding = isTablet ? 32.0 : 16.0;
            
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, isTablet),
                  const SizedBox(height: 32),
                  _buildLocationStatus(context, isTablet),
                  const SizedBox(height: 32),
                  _buildCalibrationButton(context, isTablet),
                  const SizedBox(height: 32),
                  _buildInstructions(context, isTablet),
                  const Spacer(),
                  _buildEmergencyNote(context, isTablet),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.info, AppTheme.info.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.info.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location Calibration',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ensure accurate emergency response',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatus(BuildContext context, bool isTablet) {
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
        children: [
          Icon(
            Icons.location_on,
            size: isTablet ? 64 : 48,
            color: _accuracy > 0 ? AppTheme.success : AppTheme.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            'Current Location',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.neutral800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentLocation,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.neutral600,
            ),
            textAlign: TextAlign.center,
          ),
          if (_accuracy > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Accuracy: ${_accuracy.toStringAsFixed(1)}m',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalibrationButton(BuildContext context, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isCalibrating 
              ? [AppTheme.neutral400, AppTheme.neutral400]
              : [AppTheme.primary, AppTheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isCalibrating ? null : [
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
          borderRadius: BorderRadius.circular(16),
          onTap: _isCalibrating ? null : _startCalibration,
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isCalibrating) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Calibrating Location...',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.gps_fixed, color: Colors.white, size: 24),
                  const SizedBox(width: 16),
                  Text(
                    'Start Location Calibration',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    );
  }

  Widget _buildInstructions(BuildContext context, bool isTablet) {
    final instructions = [
      'Move to an open area with clear sky view',
      'Ensure GPS is enabled on your device',
      'Wait for accurate location detection',
      'Calibration improves emergency response time',
    ];

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
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.info, size: 24),
              const SizedBox(width: 12),
              Text(
                'Calibration Instructions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.neutral800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...instructions.map((instruction) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.info,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    instruction,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.neutral600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEmergencyNote(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: AppTheme.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'In emergencies, call local emergency services immediately. Location calibration helps but should not delay emergency calls.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startCalibration() async {
    setState(() {
      _isCalibrating = true;
      _currentLocation = 'Detecting location...';
    });

    // Simulate location calibration process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isCalibrating = false;
      _currentLocation = 'Riverside District, Emergency Zone A\n12.3456°N, 98.7654°E';
      _accuracy = 5.2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Location calibrated successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
  }
}