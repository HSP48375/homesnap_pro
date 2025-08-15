import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/address_input_widget.dart';
import './widgets/cost_estimate_widget.dart';
import './widgets/job_type_selector_widget.dart';
import './widgets/photo_count_estimator_widget.dart';
import './widgets/property_details_widget.dart';
import './widgets/scheduling_section_widget.dart';
import './widgets/special_instructions_widget.dart';

class NewJobScreen extends StatefulWidget {
  const NewJobScreen({super.key});

  @override
  State<NewJobScreen> createState() => _NewJobScreenState();
}

class _NewJobScreenState extends State<NewJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _squareFootageController =
      TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _specialInstructionsController =
      TextEditingController();

  // Job Configuration
  String _selectedJobType = 'full';
  String _propertyAddress = '';
  double? _latitude;
  double? _longitude;
  String _streetViewThumbnail = '';
  int _squareFootage = 0;
  int _bedrooms = 0;
  int _bathrooms = 0;
  int _estimatedPhotos = 25;
  DateTime? _scheduledDate;
  bool _isImmediateCapture = true;
  String _specialInstructions = '';
  double _estimatedCost = 149.99;
  String _deliveryTimeline = '24-48 hours';

  bool _isLoading = false;
  bool _addressValidated = false;

  String _selectedAddress = '';
  String _selectedPlaceId = '';
  String _jobName = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _squareFootageController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
        setState(() {
          _addressController.text = address.trim();
          _propertyAddress = address.trim();
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _onAddressSelected(String address, String placeId) async {
    setState(() {
      _propertyAddress = address;
      _addressController.text = _propertyAddress;
      _addressValidated = true;
      _selectedAddress = _propertyAddress;
      _selectedPlaceId = placeId;
      // Use address as job name if no custom name is provided
      if (_jobName.isEmpty) {
        _jobName =
            _propertyAddress.split(',').first; // Use first part of address
      }
    });

    // Get coordinates for the selected address
    try {
      List<Location> locations = await locationFromAddress(_propertyAddress);
      if (locations.isNotEmpty) {
        setState(() {
          _latitude = locations[0].latitude;
          _longitude = locations[0].longitude;
          _streetViewThumbnail =
              'https://maps.googleapis.com/maps/api/streetview?size=400x200&location=${_latitude},${_longitude}&key=YOUR_API_KEY';
        });
      }
    } catch (e) {
      debugPrint('Error getting coordinates: $e');
    }
  }

  void _proceedToCamera() {
    if (_selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a property address'),
          backgroundColor: Colors.orange));
      return;
    }

    if (_selectedJobType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a job type'),
          backgroundColor: Colors.orange));
      return;
    }

    // Navigate to camera interface
    Navigator.pushNamed(context, AppRoutes.cameraInterface, arguments: {
      'address': _selectedAddress,
      'placeId': _selectedPlaceId,
      'jobType': _selectedJobType,
      'jobName': _jobName,
    });
  }

  void _onJobTypeChanged(String jobType) {
    setState(() {
      _selectedJobType = jobType;
      _updateEstimates();
    });
  }

  void _onPropertyDetailsChanged({
    int? squareFootage,
    int? bedrooms,
    int? bathrooms,
  }) {
    setState(() {
      if (squareFootage != null) _squareFootage = squareFootage;
      if (bedrooms != null) _bedrooms = bedrooms;
      if (bathrooms != null) _bathrooms = bathrooms;
      _updateEstimates();
    });
  }

  void _onSchedulingChanged({
    bool? isImmediate,
    DateTime? scheduledDate,
  }) {
    setState(() {
      if (isImmediate != null) _isImmediateCapture = isImmediate;
      if (scheduledDate != null) _scheduledDate = scheduledDate;
    });
  }

  void _onSpecialInstructionsChanged(String instructions) {
    setState(() {
      _specialInstructions = instructions;
    });
  }

  void _updateEstimates() {
    int basePhotos = _selectedJobType == 'interior'
        ? 15
        : _selectedJobType == 'exterior'
            ? 10
            : 25;

    int additionalPhotos = (_squareFootage / 1000 * 5).round() +
        (_bedrooms * 3) +
        (_bathrooms * 2);

    setState(() {
      _estimatedPhotos = basePhotos + additionalPhotos;

      double baseCost = _selectedJobType == 'interior'
          ? 99.99
          : _selectedJobType == 'exterior'
              ? 79.99
              : 149.99;

      double additionalCost = additionalPhotos * 2.50;
      _estimatedCost = baseCost + additionalCost;

      _deliveryTimeline = _isImmediateCapture ? '24-48 hours' : '48-72 hours';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Row(children: [
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                        color: AppTheme.white.withAlpha(26),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppTheme.white.withAlpha(51),
                                            width: 1)),
                                    child: Icon(Icons.arrow_back_ios_new,
                                        color: AppTheme.white, size: 5.w))),
                            SizedBox(width: 4.w),
                            Text('New Photography Job',
                                style: GoogleFonts.poppins(
                                    color: AppTheme.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                          ])),

                      const SizedBox(height: 24),

                      // Address Input with Google Places
                      AddressInputWidget(
                          onAddressSelected: _onAddressSelected,
                          initialAddress: _selectedAddress.isNotEmpty
                              ? _selectedAddress
                              : null),

                      const SizedBox(height: 24),

                      // Job Type Selector
                      JobTypeSelectorWidget(
                          selectedType: _selectedJobType,
                          onTypeChanged: _onJobTypeChanged),

                      SizedBox(height: 3.h),

                      // Property Details
                      PropertyDetailsWidget(
                          squareFootageController: _squareFootageController,
                          bedroomsController: _bedroomsController,
                          bathroomsController: _bathroomsController,
                          onDetailsChanged: _onPropertyDetailsChanged),

                      SizedBox(height: 3.h),

                      // Photo Count Estimator
                      PhotoCountEstimatorWidget(
                          estimatedPhotos: _estimatedPhotos,
                          jobType: _selectedJobType),

                      SizedBox(height: 3.h),

                      // Scheduling Section
                      SchedulingSectionWidget(
                          isImmediate: _isImmediateCapture,
                          scheduledDate: _scheduledDate,
                          onSchedulingChanged: _onSchedulingChanged),

                      SizedBox(height: 3.h),

                      // Special Instructions
                      SpecialInstructionsWidget(
                          controller: _specialInstructionsController,
                          onChanged: _onSpecialInstructionsChanged),

                      SizedBox(height: 3.h),

                      // Cost Estimate
                      CostEstimateWidget(
                          estimatedCost: _estimatedCost,
                          deliveryTimeline: _deliveryTimeline),

                      SizedBox(height: 4.h),

                      // Start Photography Button
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: _proceedToCamera,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Text('Start Photo Capture',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600)))),

                      SizedBox(height: 4.h),
                    ]))));
  }

  void _handleStartPhotography() async {
    if (!_formKey.currentState!.validate()) return;
    if (_propertyAddress.isEmpty) {
      _showErrorMessage('Please enter a property address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save job parameters
      final jobData = {
        'property_address': _propertyAddress,
        'latitude': _latitude,
        'longitude': _longitude,
        'job_type': _selectedJobType,
        'square_footage': _squareFootage,
        'bedrooms': _bedrooms,
        'bathrooms': _bathrooms,
        'estimated_photos': _estimatedPhotos,
        'estimated_cost': _estimatedCost,
        'is_immediate': _isImmediateCapture,
        'scheduled_date': _scheduledDate?.toIso8601String(),
        'special_instructions': _specialInstructions,
        'delivery_timeline': _deliveryTimeline,
      };

      // Navigate to camera interface with job parameters
      Navigator.pushNamed(context, '/camera-interface', arguments: jobData);
    } catch (e) {
      _showErrorMessage('Failed to start photography session: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.black,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));
  }
}
