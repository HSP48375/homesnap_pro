# HomeSnap Pro - Export & Deployment Instructions

## 📱 Export Instructions

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.0 or higher
- Android Studio (for Android builds)
- Xcode (for iOS builds - macOS only)

### 1. Clone/Export Project
```bash
# If exporting from development environment
# Copy the entire project folder to your desired location
cp -r homesnap_pro /path/to/your/projects/
cd /path/to/your/projects/homesnap_pro
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Environment Setup
See `ENV_SETUP.md` for complete environment variable configuration.

## 🚀 Local Development

### Run Locally (Debug Mode)
```bash
flutter run \
  --dart-define=SUPABASE_URL=your_supabase_url \
  --dart-define=SUPABASE_ANON_KEY=your_supabase_key
```

### Run with Hot Reload
```bash
flutter run --hot
```

### Run on Specific Device
```bash
flutter devices  # List available devices
flutter run -d device_id
```

## 📦 Production Builds

### Android APK Build
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release \
  --dart-define=SUPABASE_URL=your_production_supabase_url \
  --dart-define=SUPABASE_ANON_KEY=your_production_supabase_key \
  --dart-define=STRIPE_PUBLISHABLE_KEY=your_production_stripe_key
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=your_production_supabase_url \
  --dart-define=SUPABASE_ANON_KEY=your_production_supabase_key
```

### iOS Build
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release \
  --dart-define=SUPABASE_URL=your_production_supabase_url \
  --dart-define=SUPABASE_ANON_KEY=your_production_supabase_key
```

## 🔧 Platform-Specific Setup

### Android Setup
1. **Update package name** in:
   - `android/app/build.gradle` (applicationId)
   - `android/app/src/main/AndroidManifest.xml` (package attribute)

2. **Signing configuration** (for release):
   ```bash
   keytool -genkey -v -keystore ~/homesnap-release-key.keystore -name homesnap -keyalg RSA -keysize 2048 -validity 10000
   ```

3. **Create signing config** in `android/app/build.gradle`:
   ```gradle
   signingConfigs {
       release {
           keyAlias 'homesnap'
           keyPassword 'your_key_password'
           storeFile file('/path/to/homesnap-release-key.keystore')
           storePassword 'your_store_password'
       }
   }
   ```

### iOS Setup
1. **Update bundle identifier** in:
   - `ios/Runner.xcodeproj/project.pbxproj`
   - `ios/Runner/Info.plist`

2. **Configure signing** in Xcode:
   - Open `ios/Runner.xcworkspace`
   - Select Runner project
   - Update Team and Bundle Identifier in Signing & Capabilities

3. **Add Firebase configuration**:
   - Place `GoogleService-Info.plist` in `ios/Runner/`

## 📂 Project Structure

```
homesnap_pro/
├── lib/
│   ├── core/               # Core utilities and exports
│   ├── presentation/       # UI screens and widgets
│   ├── services/          # Business logic and API services
│   ├── theme/             # App theming
│   ├── widgets/           # Reusable widgets
│   └── routes/            # Navigation routes
├── supabase/
│   └── migrations/        # Database migrations
├── android/               # Android configuration
├── ios/                   # iOS configuration
├── web/                   # Web configuration
└── assets/               # Images and assets
```

## 🛠️ Key Features Implemented

✅ **Authentication System**
- Sign up, sign in, sign out
- User profiles and role management
- Supabase authentication integration

✅ **Camera Integration**
- Professional photo capture
- Multiple photo selection
- Real-time camera preview with controls

✅ **Photo Processing Workflow**
- Upload to Supabase Storage
- Professional editing services
- Progress tracking and notifications

✅ **Payment Processing**
- Stripe integration
- Secure payment handling
- Order management

✅ **Push Notifications**
- Firebase Cloud Messaging
- Job status updates
- Payment confirmations

✅ **Database Integration**
- Complete Supabase schema
- Real-time data synchronization
- Row Level Security (RLS)

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 📈 Performance Optimization

### Analyze Bundle Size
```bash
flutter build apk --analyze-size
flutter build ios --analyze-size
```

### Performance Profiling
```bash
flutter run --profile
```

## 🚀 Deployment

### Google Play Store (Android)
1. Build release app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Configure store listing and pricing
4. Submit for review

### Apple App Store (iOS)
1. Build release: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect
4. Configure app information
5. Submit for review

## 🔍 Troubleshooting

### Common Issues

**1. Build Failures**
```bash
flutter clean
flutter pub get
flutter pub deps
```

**2. Android Signing Issues**
- Verify keystore path and passwords
- Check signing configuration in build.gradle

**3. iOS Provisioning Issues**
- Update bundle identifier
- Verify team and certificates in Xcode

**4. Environment Variables Not Working**
- Ensure proper --dart-define syntax
- Check for typos in variable names

### Debug Commands
```bash
flutter doctor          # Check Flutter installation
flutter devices         # List connected devices
flutter logs            # View device logs
flutter analyze         # Static code analysis
```

## 📞 Support

For deployment support or issues:
1. Check Flutter documentation: https://flutter.dev/docs
2. Review platform-specific guides
3. Consult the error logs and stack traces
4. Verify all environment variables are correctly set

## 🎯 Production Checklist

Before going live:

- [ ] All environment variables configured for production
- [ ] Database migrations applied
- [ ] Stripe webhooks configured
- [ ] Firebase push notifications tested
- [ ] Camera permissions working on both platforms
- [ ] Payment flow tested end-to-end
- [ ] App icons and launch screens configured
- [ ] Privacy policy and terms of service added
- [ ] App store metadata prepared
- [ ] Beta testing completed

The app is now ready for production deployment! 🚀