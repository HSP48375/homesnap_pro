import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final Dio _dio = Dio();
  static const String _stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );
  static const String _stripeSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: '',
  );

  Future<void> initialize() async {
    if (_stripePublishableKey.isEmpty) {
      debugPrint(
          '⚠️ Stripe publishable key not configured - running in demo mode');
      return;
    }

    try {
      Stripe.publishableKey = _stripePublishableKey;
      await Stripe.instance.applySettings();
      debugPrint('✅ Stripe initialized successfully');
    } catch (e) {
      debugPrint('⚠️ Stripe initialization failed: $e - running in demo mode');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
    Map<String, String>? metadata,
  }) async {
    try {
      // For demo purposes, we'll simulate payment intent creation
      // In production, this should call your backend API
      if (kIsWeb || _stripeSecretKey.isEmpty) {
        // Simulate successful payment intent creation for demo
        return {
          'success': true,
          'clientSecret':
              'pi_demo_client_secret_${DateTime.now().millisecondsSinceEpoch}',
          'paymentIntentId': 'pi_demo_${DateTime.now().millisecondsSinceEpoch}',
        };
      }

      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'amount': amount,
          'currency': currency,
          'payment_method_types[]': 'card',
          if (metadata != null)
            ...metadata.map((key, value) => MapEntry('metadata[$key]', value)),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'success': true,
          'clientSecret': data['client_secret'],
          'paymentIntentId': data['id'],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to create payment intent',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> confirmPayment(String clientSecret) async {
    try {
      if (kIsWeb || _stripeSecretKey.isEmpty) {
        // Simulate successful payment confirmation for demo
        await Future.delayed(const Duration(seconds: 2));
        return {
          'success': true,
          'paymentIntentId': 'pi_demo_${DateTime.now().millisecondsSinceEpoch}',
        };
      }

      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        options: const PaymentMethodOptions(
          setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
        ),
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        return {
          'success': true,
          'paymentIntentId': paymentIntent.id,
        };
      } else {
        return {
          'success': false,
          'error': 'Payment confirmation failed: ${paymentIntent.status}',
        };
      }
    } catch (e) {
      if (e is StripeException) {
        return {
          'success': false,
          'error': e.error.localizedMessage ?? 'Payment failed',
        };
      }
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<bool> isStripeConfigured() async {
    return _stripePublishableKey.isNotEmpty;
  }

  Future<Map<String, dynamic>> processTestPayment({
    required double amount,
    required Map<String, dynamic> orderData,
  }) async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    // Always succeed for demo purposes
    return {
      'success': true,
      'paymentIntentId': 'pi_demo_${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'currency': 'usd',
    };
  }
}
