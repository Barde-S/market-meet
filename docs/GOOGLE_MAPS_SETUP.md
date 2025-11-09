# Google Maps API Setup Guide

This guide will help you integrate Google Maps into the MarketMate mobile app.

## Prerequisites

- Google Cloud Platform account
- MarketMate Flutter app set up
- Billing enabled on GCP (required for Maps API)

## Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Note down your Project ID

## Step 2: Enable Required APIs

Enable the following APIs in your Google Cloud project:

1. Go to **APIs & Services** > **Library**
2. Search and enable:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API
   - Geolocation API
   - Directions API (optional, for navigation)

## Step 3: Create API Keys

### Create Android API Key

1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **API Key**
3. Click **Restrict Key**
4. Name it: `MarketMate Android`
5. Under **Application restrictions**:
   - Select **Android apps**
   - Click **Add an item**
   - Package name: `com.marketmate.app`
   - SHA-1 certificate fingerprint: (see below)
6. Under **API restrictions**:
   - Select **Restrict key**
   - Choose: Maps SDK for Android, Places API, Geocoding API
7. Click **Save**

### Get SHA-1 Certificate Fingerprint

For debug builds:
```bash
cd mobile/android
./gradlew signingReport
```

For release builds:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Create iOS API Key

1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **API Key**
3. Click **Restrict Key**
4. Name it: `MarketMate iOS`
5. Under **Application restrictions**:
   - Select **iOS apps**
   - Click **Add an item**
   - Bundle ID: `com.marketmate.app`
6. Under **API restrictions**:
   - Select **Restrict key**
   - Choose: Maps SDK for iOS, Places API, Geocoding API
7. Click **Save**

### Create Web API Key (for Web version)

1. Follow similar steps as above
2. Restrict to **HTTP referrers**
3. Add your domain

## Step 4: Configure Android App

### 1. Update AndroidManifest.xml

Edit `mobile/android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.marketmate.app">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

    <application
        android:label="MarketMate"
        android:icon="@mipmap/ic_launcher">

        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_ANDROID_API_KEY"/>

        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />

            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

### 2. Update build.gradle

Edit `mobile/android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.marketmate.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
    }
}

dependencies {
    implementation 'com.google.android.gms:play-services-maps:18.2.0'
    implementation 'com.google.android.gms:play-services-location:21.0.1'
}
```

## Step 5: Configure iOS App

### 1. Update AppDelegate.swift

Edit `mobile/ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 2. Update Info.plist

Edit `mobile/ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>MarketMate needs your location to find nearby agents and markets</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>MarketMate needs your location to provide better service recommendations</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

### 3. Update Podfile

Edit `mobile/ios/Podfile`:

```ruby
platform :ios, '12.0'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # Add this line
  pod 'GoogleMaps'
end
```

Then run:
```bash
cd mobile/ios
pod install
```

## Step 6: Implement Maps in Flutter

### Create Maps Service

Create `mobile/lib/services/maps_service.dart`:

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  static LatLng positionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  static double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }
}
```

### Create Map Screen Example

Create `mobile/lib/screens/map_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/maps_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final position = await MapsService.getCurrentLocation();
      setState(() {
        _currentPosition = MapsService.positionToLatLng(position);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Agents'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
    );
  }
}
```

## Step 7: Environment Variables

Store API keys securely (optional):

Create `mobile/.env`:
```
GOOGLE_MAPS_ANDROID_API_KEY=your_android_key
GOOGLE_MAPS_IOS_API_KEY=your_ios_key
```

**Note**: Never commit API keys to version control.

## Step 8: Testing

### Test on Android
```bash
flutter run
```

### Test on iOS
```bash
flutter run -d ios
```

### Common Issues

**Map not showing:**
- Verify API key is correct
- Check billing is enabled
- Ensure APIs are enabled in GCP
- Check AndroidManifest.xml / Info.plist configuration

**Location permission denied:**
- Check Info.plist has location usage descriptions
- Check AndroidManifest.xml has location permissions

## Features to Implement

1. **Agent Markers**: Show verified agents on the map
2. **Clustering**: Group nearby agents into clusters
3. **Directions**: Navigate to agent or market location
4. **Search**: Search for places and addresses
5. **Geofencing**: Alert when user enters/exits market area

## Cost Optimization

- Enable billing alerts
- Set usage quotas
- Restrict API keys properly
- Use static maps for previews
- Cache geocoding results

## Resources

- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Geolocator Plugin](https://pub.dev/packages/geolocator)
- [Geocoding Plugin](https://pub.dev/packages/geocoding)

## Next Steps

1. Implement agent location markers
2. Add search functionality
3. Integrate with booking system
4. Add navigation features
