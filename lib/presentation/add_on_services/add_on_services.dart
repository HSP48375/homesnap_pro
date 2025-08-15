import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/job_summary_card_widget.dart';
import './widgets/pricing_breakdown_widget.dart';
import './widgets/service_card_widget.dart';
import './widgets/service_detail_modal_widget.dart';

class AddOnServices extends StatefulWidget {
  const AddOnServices({super.key});

  @override
  State<AddOnServices> createState() => _AddOnServicesState();
}

class _AddOnServicesState extends State<AddOnServices> {
  final List<String> _selectedServiceIds = [];
  bool _isLoading = false;
  bool _showPricingDetails = false;

  // Updated services with new pricing structure
  final List<Map<String, dynamic>> _availableServices = [
    {
      "id": "photo_editing",
      "name": "Photo Editing",
      "description":
          "Professional photo enhancement with color correction, brightness adjustment, and quality optimization.",
      "detailedDescription":
          "Our expert photo editors will enhance your property photos with professional color correction, brightness and contrast adjustments, sharpening, and overall quality optimization. Each photo is individually processed to showcase your property in the best possible light.",
      "price": "\$1.50",
      "pricePerPhoto": true,
      "deliveryTime": "2-4 hours",
      "guarantee": "Professional Quality",
      "beforeImage":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1571463/pexels-photo-1571463.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Professional color correction",
        "Brightness & contrast optimization",
        "Image sharpening",
        "Quality enhancement",
        "Individual photo attention"
      ]
    },
    {
      "id": "twilight_photo",
      "name": "Twilight Photo",
      "description":
          "Transform day photos into stunning twilight shots with warm interior lighting and dramatic sky.",
      "detailedDescription":
          "Create captivating twilight shots from your daytime exterior photos. Our editors add warm interior lighting, dramatic evening sky, and perfect ambient lighting to make your property stand out with that magical golden hour appeal.",
      "price": "\$15.00",
      "pricePerPhoto": true,
      "deliveryTime": "4-6 hours",
      "guarantee": "Dramatic Results",
      "beforeImage":
          "https://images.pexels.com/photos/1396122/pexels-photo-1396122.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1396132/pexels-photo-1396132.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Dramatic twilight transformation",
        "Warm interior lighting effects",
        "Evening sky replacement",
        "Professional ambient lighting",
        "High-impact curb appeal"
      ]
    },
    {
      "id": "virtual_staging",
      "name": "Virtual Staging",
      "description":
          "Transform empty rooms into beautifully furnished spaces that help buyers visualize the property's potential.",
      "detailedDescription":
          "Our professional virtual staging service uses advanced 3D rendering technology to furnish empty rooms with high-quality, photorealistic furniture and decor. Perfect for vacant properties, this service helps potential buyers visualize the space's full potential.",
      "price": "\$20.00",
      "pricePerPhoto": true,
      "deliveryTime": "6-8 hours",
      "guarantee": "100% Satisfaction",
      "beforeImage":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1571463/pexels-photo-1571463.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Professional 3D furniture placement",
        "Multiple style options available",
        "High-resolution output",
        "Unlimited revisions",
        "Buyer visualization enhancement"
      ]
    },
    {
      "id": "item_removal_small",
      "name": "Small Item Removal",
      "description":
          "Remove up to 3 small items or clutter from your property photos for a cleaner look.",
      "detailedDescription":
          "Clean up your property photos by removing small unwanted items, personal belongings, or clutter. Perfect for removing items like toys, personal photos, small appliances, or other distracting elements (up to 3 small items per photo).",
      "price": "\$5.00",
      "pricePerPhoto": true,
      "deliveryTime": "2-4 hours",
      "guarantee": "Seamless Results",
      "beforeImage":
          "https://images.pexels.com/photos/1571452/pexels-photo-1571452.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1571457/pexels-photo-1571457.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Remove up to 3 small items",
        "Clean, decluttered appearance",
        "Seamless background reconstruction",
        "Natural lighting preservation",
        "Professional retouching"
      ]
    },
    {
      "id": "item_removal_large",
      "name": "Large Item Removal",
      "description":
          "Remove over 3 items or large objects like furniture for a completely clean appearance.",
      "detailedDescription":
          "Professional removal of large items or multiple objects from your property photos. Ideal for removing furniture, large appliances, or more than 3 items per photo. Our editors will seamlessly reconstruct backgrounds and maintain natural lighting.",
      "price": "\$12.00",
      "pricePerPhoto": true,
      "deliveryTime": "4-6 hours",
      "guarantee": "Professional Results",
      "beforeImage":
          "https://images.pexels.com/photos/1571452/pexels-photo-1571452.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1571457/pexels-photo-1571457.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Remove 4+ items or large objects",
        "Complete furniture removal",
        "Advanced background reconstruction",
        "Professional editing techniques",
        "Extensive clean-up capability"
      ]
    },
    {
      "id": "floorplan_2d",
      "name": "2D Floorplan Creation",
      "description":
          "Create professional 2D floorplans from your walkthrough video, delivered in 12-14 hours.",
      "detailedDescription":
          "Record a walkthrough video using our app (CubiCasa-style workflow) and receive a professionally created 2D floorplan. Perfect for listings, marketing materials, and helping buyers understand the property layout. Floorplans are delivered within 12-14 hours of video upload.",
      "price": "\$25.00",
      "pricePerFloorplan": true,
      "deliveryTime": "12-14 hours",
      "guarantee": "Accurate Measurements",
      "beforeImage":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1571463/pexels-photo-1571463.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Professional 2D floorplan creation",
        "CubiCasa-style video workflow",
        "Accurate room measurements",
        "Print-ready quality",
        "12-14 hour delivery"
      ],
      "hasWhiteLabel": true,
      "whiteLabelPrice": 5.00
    },
    {
      "id": "photo_branding",
      "name": "Photo Branding",
      "description":
          "Add your custom logo or watermark to delivered images for professional branding.",
      "detailedDescription":
          "Enhance your professional brand by adding your custom logo or watermark to all delivered property photos. Perfect for real estate agents who want to maintain brand visibility and professional presentation in their marketing materials.",
      "price": "\$3.00",
      "pricePerJob": true,
      "deliveryTime": "1-2 hours additional",
      "guarantee": "Brand Consistency",
      "beforeImage":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1571463/pexels-photo-1571463.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Custom logo placement",
        "Professional watermarking",
        "Brand consistency",
        "Marketing material ready",
        "Multiple format options"
      ]
    },
    {
      "id": "branded_delivery",
      "name": "Branded Gallery Delivery",
      "description":
          "Receive a custom branded download page with your logo and colors for client presentation.",
      "detailedDescription":
          "Upgrade your client delivery experience with a custom branded gallery page featuring your logo, colors, and professional presentation. Perfect for impressing clients and maintaining brand consistency throughout the entire service experience.",
      "price": "\$9.00",
      "pricePerDelivery": true,
      "deliveryTime": "Same as main service",
      "guarantee": "Professional Presentation",
      "beforeImage":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800",
      "afterImage":
          "https://images.pexels.com/photos/1571463/pexels-photo-1571463.jpeg?auto=compress&cs=tinysrgb&w=800",
      "features": [
        "Custom branded download page",
        "Your logo and colors",
        "Professional client presentation",
        "Enhanced brand experience",
        "Client impression management"
      ]
    }
  ];

  // Mock job data
  final Map<String, dynamic> _jobData = {
    "selectedImage":
        "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800",
    "photoCount": 12,
    "basePricing": "\$89.00"
  };

  double get _basePrice => 89.00;

  double get _totalAddOnPrice {
    double total = 0.0;
    int photoCount = _jobData['photoCount'] as int;

    for (String serviceId in _selectedServiceIds) {
      final service =
          _availableServices.firstWhere((s) => s['id'] == serviceId);
      final priceString = service['price'] as String;
      final price =
          double.parse(priceString.replaceAll('\$', '').replaceAll(',', ''));

      // Apply pricing logic based on service type
      if (service['pricePerPhoto'] == true) {
        total += price * photoCount;
      } else {
        total += price;
      }

      // Add white-label cost if applicable
      if (service['hasWhiteLabel'] == true &&
          service['whiteLabelPrice'] != null) {
        // For now, auto-add white-label (could be made optional with checkbox)
        total += service['whiteLabelPrice'] as double;
      }
    }
    return total;
  }

  String get _totalPrice {
    final total = _basePrice + _totalAddOnPrice;
    return '\$${total.toStringAsFixed(2)}';
  }

  List<Map<String, dynamic>> get _selectedServices {
    return _availableServices
        .where((service) => _selectedServiceIds.contains(service['id']))
        .toList();
  }

  void _toggleService(String serviceId) {
    setState(() {
      if (_selectedServiceIds.contains(serviceId)) {
        _selectedServiceIds.remove(serviceId);
      } else {
        _selectedServiceIds.add(serviceId);
      }
    });
  }

  void _showServiceDetails(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailModalWidget(
        service: service,
        isSelected: _selectedServiceIds.contains(service['id']),
        onToggle: () => _toggleService(service['id'] as String),
      ),
    );
  }

  void _togglePricingDetails() {
    setState(() {
      _showPricingDetails = !_showPricingDetails;
    });
  }

  Future<void> _continueToCheckout() async {
    if (_selectedServiceIds.isEmpty) {
      _showSkipConfirmation();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pushNamed(context, '/order-summary');
    }
  }

  void _showSkipConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Skip Add-on Services?',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You can proceed with basic photo processing only. Consider these popular add-ons:',
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 2.h),
            Text('• Photo Editing: \$1.50/photo',
                style: TextStyle(fontWeight: FontWeight.w600)),
            Text('• Virtual Staging: \$20/image',
                style: TextStyle(fontWeight: FontWeight.w600)),
            Text('• 2D Floorplan: \$25/floorplan',
                style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.yellow.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.yellow, width: 1),
              ),
              child: Text(
                'Subscribe for \$15/month to unlock unlimited whitelabeling & branding add-ons.',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Go Back',
                style: AppTheme.lightTheme.textTheme.labelLarge
                    ?.copyWith(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/order-summary');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentStart,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Continue',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.backgroundElevated,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _handleContinueToOrderSummary() {
    Navigator.pushNamed(
      context,
      '/order-summary',
      arguments: {
        'photos': _jobData['photoCount'],
        'property_address': 'Property Address',
        'selected_services': _selectedServices,
        'total_amount': _totalPrice,
        'estimated_delivery': '24-48 hours',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
              iconName: 'arrow_back', color: AppTheme.textPrimary, size: 6.w),
        ),
        title: Text(
          'Select Your Add-Ons',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.yellow.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.yellow, width: 1),
            ),
            child: Text(
              'New!',
              style: TextStyle(
                  color: AppTheme.yellow,
                  fontWeight: FontWeight.w700,
                  fontSize: 12),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subscription offer banner
          Container(
            margin: EdgeInsets.all(4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.yellow.withAlpha(26),
                  AppTheme.yellow.withAlpha(13)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.yellow, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: AppTheme.yellow, size: 6.w),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subscribe for \$15/month',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(
                        'Unlock unlimited whitelabeling & branding add-ons',
                        style: TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Subscription feature coming soon!'),
                          backgroundColor: AppTheme.yellow),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellow,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                  child: Text('Learn More',
                      style: TextStyle(
                          color: AppTheme.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ),
              ],
            ),
          ),

          // Job summary card
          JobSummaryCardWidget(
            selectedImagePath: _jobData['selectedImage'] as String,
            basePricing: _jobData['basePricing'] as String,
            photoCount: _jobData['photoCount'] as int,
          ),

          // Services list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 1.h, bottom: 25.h),
              itemCount: _availableServices.length,
              itemBuilder: (context, index) {
                final service = _availableServices[index];
                final isSelected = _selectedServiceIds.contains(service['id']);

                return ServiceCardWidget(
                  service: service,
                  isSelected: isSelected,
                  onToggle: () => _toggleService(service['id'] as String),
                  onTap: () => _showServiceDetails(service),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: PricingBreakdownWidget(
        selectedServices: _selectedServices,
        basePricing: _jobData['basePricing'] as String,
        totalPrice: _totalPrice,
        onViewDetails: _togglePricingDetails,
      ),
      floatingActionButton: Container(
        width: 90.w,
        margin: EdgeInsets.only(bottom: 20.h),
        child: FloatingActionButton.extended(
          onPressed: _isLoading ? null : _continueToCheckout,
          backgroundColor: _selectedServiceIds.isEmpty
              ? AppTheme.textSecondary
              : AppTheme.accentStart,
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          label: _isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.backgroundElevated)),
                    ),
                    SizedBox(width: 2.w),
                    Text('Processing...',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                                color: AppTheme.backgroundElevated,
                                fontWeight: FontWeight.w600)),
                  ],
                )
              : Text(
                  _selectedServiceIds.isEmpty
                      ? 'Skip Add-ons'
                      : 'Continue to Checkout',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.backgroundElevated,
                      fontWeight: FontWeight.w600)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}