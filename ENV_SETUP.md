# HomeSnap Pro - Environment Setup Guide

## Required Environment Variables

To run HomeSnap Pro, you need to set up the following environment variables using `--dart-define` flags:

### Supabase Configuration
```bash
--dart-define=SUPABASE_URL=your_supabase_project_url
--dart-define=SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Stripe Configuration (for payments)
```bash
--dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
--dart-define=STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
```

### Firebase Configuration (for push notifications)
```bash
--dart-define=FIREBASE_PROJECT_ID=your_firebase_project_id
--dart-define=FIREBASE_API_KEY=your_firebase_api_key
--dart-define=FIREBASE_APP_ID=your_firebase_app_id
```

## Complete Run Command Example

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key_here \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here \
  --dart-define=STRIPE_SECRET_KEY=sk_test_your_key_here \
  --dart-define=FIREBASE_PROJECT_ID=your_project_id \
  --dart-define=FIREBASE_API_KEY=your_api_key \
  --dart-define=FIREBASE_APP_ID=your_app_id
```

## Build Commands

### Android APK Build
```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key_here \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
```

### iOS Build
```bash
flutter build ios --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key_here \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
```

## Service Setup Instructions

### 1. Supabase Setup
1. Create a new project at https://supabase.com
2. Go to Settings > API to get your URL and anon key
3. Run the provided SQL migrations in the SQL editor
4. Enable Row Level Security on all tables
5. Configure Storage bucket for photos

### 2. Stripe Setup
1. Create account at https://stripe.com
2. Get your publishable and secret keys from the dashboard
3. Set up webhooks for payment confirmations
4. Configure your payment methods and currencies

### 3. Firebase Setup
1. Create project at https://firebase.google.com
2. Add iOS and Android apps to your project
3. Download google-services.json (Android) and GoogleService-Info.plist (iOS)
4. Place configuration files in correct locations
5. Enable Cloud Messaging in Firebase console

## Quick Start (Demo Mode)

For testing without full service configuration:

```bash
flutter run --dart-define=SUPABASE_URL=demo --dart-define=SUPABASE_ANON_KEY=demo
```

The app will run in demo mode with limited functionality.