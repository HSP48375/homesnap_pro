import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../core/env.dart';
import 'supabase_service.dart';

class StripeService {
  static bool _inited = false;

  static Future<void> init() async {
    if (_inited) return;
    // Configure publishable key + merchant identifier (Apple Pay)
    Stripe.publishableKey = Env.stripePublishableKey;
    Stripe.merchantIdentifier = Env.stripeMerchantId;
    await Stripe.instance.applySettings();
    _inited = true;
  }

  /// Invoke the Supabase Edge Function to create a PaymentIntent and return client_secret
  static Future<String> _createPaymentIntent({
    required int amountCents,
    String currency = 'usd',
  }) async {
    // Use Supabase Functions client instead of manually crafting the REST URL
    final res = await SupabaseService.client.functions.invoke(
      'create-payment-intent',
      body: {'amount': amountCents, 'currency': currency},
    );

    if (res.data == null) {
      throw Exception('PaymentIntent failed: empty response');
    }

    // The function either returns { clientSecret: '...' } or an error payload
    if (res.data is Map && res.data['clientSecret'] is String) {
      return res.data['clientSecret'] as String;
    }

    // If function returned an error shape, surface it
    throw Exception('PaymentIntent failed: ${res.data}');
  }

  /// Opens the Stripe PaymentSheet for the given amount (in cents)
  static Future<void> pay({
    required int amountCents,
    String currency = 'usd',
    String merchantDisplayName = 'HomeSnap Pro',
  }) async {
    final clientSecret = await _createPaymentIntent(
      amountCents: amountCents,
      currency: currency,
    );

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantDisplayName,
        // Simple card-only flow; Apple Pay/Google Pay can be added later
      ),
    );

    await Stripe.instance.presentPaymentSheet();
  }
}
