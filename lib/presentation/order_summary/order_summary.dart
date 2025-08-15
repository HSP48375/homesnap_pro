import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/payment_service.dart';
import '../../theme/app_theme.dart';
import './widgets/contact_preferences_widget.dart';
import './widgets/delivery_info_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/pricing_summary_widget.dart';
import './widgets/promo_code_widget.dart';
import './widgets/property_photo_gallery_widget.dart';
import './widgets/service_breakdown_widget.dart';
import './widgets/special_instructions_widget.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  Map<String, dynamic> _orderData = {};
  List<Map<String, dynamic>> _photos = [];
  String _selectedPaymentMethod = 'card';
  String _promoCode = '';
  double _discount = 0.0;
  bool _isProcessingPayment = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _orderData = args;
      // Convert List<String> to List<Map<String, dynamic>>
      final photoUrls = List<String>.from(args['photos'] ?? []);
      _photos = photoUrls
          .map((url) => {
                'url': url,
                'room': 'Room ${photoUrls.indexOf(url) + 1}',
              })
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Order Summary',
                style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            backgroundColor: AppTheme.black,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppTheme.white),
                onPressed: () => Navigator.pop(context))),
        backgroundColor: AppTheme.black,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Property Photo Gallery
              if (_photos.isNotEmpty)
                PropertyPhotoGalleryWidget(capturedPhotos: _photos),

              SizedBox(height: 3.h),

              // Service Breakdown
              ServiceBreakdownWidget(
                  selectedServices: _orderData['services'] ?? []),

              SizedBox(height: 3.h),

              // Pricing Summary
              PricingSummaryWidget(
                  subtotal: _orderData['basePrice']?.toDouble() ?? 0.0,
                  taxAmount: 0.0,
                  total:
                      (_orderData['basePrice']?.toDouble() ?? 0.0) - _discount),

              SizedBox(height: 3.h),

              // Payment Method
              PaymentMethodWidget(onPaymentMethodChanged: (String method) {
                setState(() => _selectedPaymentMethod = method);
              }),

              SizedBox(height: 3.h),

              // Promo Code
              PromoCodeWidget(onPromoCodeApplied: (String code) {
                // Calculate discount based on promo code
                double discount = 0.0;
                switch (code.toUpperCase()) {
                  case 'FIRST20':
                    discount =
                        (_orderData['basePrice']?.toDouble() ?? 0.0) * 0.20;
                    break;
                  case 'SAVE15':
                    discount =
                        (_orderData['basePrice']?.toDouble() ?? 0.0) * 0.15;
                    break;
                  case 'NEWUSER':
                  case 'WELCOME10':
                    discount =
                        (_orderData['basePrice']?.toDouble() ?? 0.0) * 0.10;
                    break;
                }
                setState(() {
                  _promoCode = code;
                  _discount = discount;
                });
              }),

              SizedBox(height: 3.h),

              // Special Instructions
              SpecialInstructionsWidget(
                  initialInstructions: _orderData['specialInstructions'] ?? '',
                  onInstructionsChanged: (String instructions) {
                    _orderData['specialInstructions'] = instructions;
                  }),

              SizedBox(height: 3.h),

              // Contact Preferences
              ContactPreferencesWidget(
                selectedMethods: [],
                onMethodsChanged: (List<String> methods) {},
              ),

              SizedBox(height: 3.h),

              // Delivery Information
              DeliveryInfoWidget(),

              SizedBox(height: 4.h),

              // Confirm Order Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _isProcessingPayment ? null : _processOrder,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.yellow,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: _isProcessingPayment
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              'Confirm Order - \$${((_orderData['basePrice']?.toDouble() ?? 0.0) - _discount).toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: AppTheme.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700)))),

              SizedBox(height: 2.h),
            ])));
  }

  Future<void> _processOrder() async {
    setState(() => _isProcessingPayment = true);

    try {
      final total = (_orderData['basePrice']?.toDouble() ?? 0.0) - _discount;

      final paymentResult = await PaymentService()
          .processTestPayment(amount: total, orderData: _orderData);

      if (paymentResult['success']) {
        _showOrderConfirmation();
      } else {
        _showErrorMessage(paymentResult['error'] ?? 'Payment failed');
      }
    } catch (e) {
      _showErrorMessage('Payment processing failed: ${e.toString()}');
    } finally {
      setState(() => _isProcessingPayment = false);
    }
  }

  void _showOrderConfirmation() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                backgroundColor: AppTheme.white,
                title: Row(children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 6.w),
                  SizedBox(width: 2.w),
                  Text('Order Confirmed!',
                      style: GoogleFonts.poppins(
                          color: AppTheme.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ]),
                content: Text(
                    'Your photography order has been confirmed. You will receive updates via your preferred contact method.',
                    style: GoogleFonts.poppins(
                        color: AppTheme.black, fontSize: 14)),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text('Return to Dashboard',
                          style: GoogleFonts.poppins(
                              color: AppTheme.yellow,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))),
                ]));
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));
  }
}
