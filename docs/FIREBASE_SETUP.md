# Firebase Setup Guide

This guide will help you set up Firebase for the MarketMate project.

## Prerequisites

- Google Account
- Flutter development environment
- Node.js installed

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: `marketmate` (or your preferred name)
4. Enable/disable Google Analytics (optional)
5. Click "Create Project"

## Step 2: Enable Firebase Services

### Authentication
1. Navigate to **Authentication** in the left sidebar
2. Click "Get Started"
3. Enable sign-in methods:
   - Email/Password
   - Google (optional)
   - Phone (optional)

### Firestore Database
1. Navigate to **Firestore Database**
2. Click "Create Database"
3. Choose production mode or test mode
4. Select your preferred location
5. Click "Enable"

### Firebase Storage
1. Navigate to **Storage**
2. Click "Get Started"
3. Accept the default security rules
4. Click "Done"

### Cloud Messaging (for notifications)
1. Navigate to **Cloud Messaging**
2. Click "Get Started"
3. Note down the Server Key for backend use

## Step 3: Add Apps to Firebase Project

### For Android App

1. Click the Android icon in Project Overview
2. Enter Android package name: `com.marketmate.app`
3. Enter app nickname: `MarketMate Android`
4. Download `google-services.json`
5. Place the file in `mobile/android/app/`

### For iOS App

1. Click the iOS icon in Project Overview
2. Enter iOS bundle ID: `com.marketmate.app`
3. Enter app nickname: `MarketMate iOS`
4. Download `GoogleService-Info.plist`
5. Place the file in `mobile/ios/Runner/`

### For Web App (optional)

1. Click the Web icon in Project Overview
2. Register app nickname: `MarketMate Web`
3. Copy the Firebase config object
4. Update `mobile/lib/config/firebase_options.dart`

## Step 4: Configure Backend (Firebase Admin SDK)

1. Go to **Project Settings** > **Service Accounts**
2. Click "Generate New Private Key"
3. Download the JSON file
4. Save as `backend/src/config/serviceAccountKey.json` (development only)

**For Production:**
- Store the JSON content as an environment variable
- Set `FIREBASE_SERVICE_ACCOUNT` in your deployment environment

## Step 5: Firestore Database Structure

Create the following collections in Firestore:

### Collection: `users`
```json
{
  "uid": "string",
  "name": "string",
  "email": "string",
  "phoneNumber": "string | null",
  "preferredLanguages": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: `agents`
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phoneNumber": "string",
  "profileImageUrl": "string | null",
  "bio": "string",
  "languages": ["string"],
  "specialties": ["string"],
  "rating": "number",
  "totalReviews": "number",
  "verified": "boolean",
  "available": "boolean",
  "location": "geopoint",
  "city": "string",
  "country": "string",
  "hourlyRate": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: `bookings`
```json
{
  "id": "string",
  "userId": "string",
  "agentId": "string",
  "type": "string", // escort | search | purchase | translation
  "status": "string", // pending | confirmed | inProgress | completed | cancelled
  "title": "string",
  "description": "string",
  "scheduledDate": "timestamp",
  "location": "string",
  "locationCoordinates": "geopoint | null",
  "estimatedHours": "number",
  "totalCost": "number",
  "notes": "string | null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "completedAt": "timestamp | null"
}
```

### Collection: `reviews`
```json
{
  "id": "string",
  "userId": "string",
  "agentId": "string",
  "bookingId": "string",
  "rating": "number",
  "comment": "string",
  "createdAt": "timestamp"
}
```

### Collection: `messages`
```json
{
  "id": "string",
  "bookingId": "string",
  "senderId": "string",
  "receiverId": "string",
  "message": "string",
  "type": "string", // text | image | location
  "read": "boolean",
  "createdAt": "timestamp"
}
```

## Step 6: Firestore Security Rules

Update Firestore security rules to protect your data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Agents collection
    match /agents/{agentId} {
      allow read: if true; // Public read for discovery
      allow write: if request.auth != null && request.auth.uid == agentId;
    }

    // Bookings collection
    match /bookings/{bookingId} {
      allow read: if request.auth != null &&
        (resource.data.userId == request.auth.uid ||
         resource.data.agentId == request.auth.uid);
      allow create: if request.auth != null;
      allow update: if request.auth != null &&
        (resource.data.userId == request.auth.uid ||
         resource.data.agentId == request.auth.uid);
    }

    // Reviews collection
    match /reviews/{reviewId} {
      allow read: if true; // Public read
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
        resource.data.userId == request.auth.uid;
    }

    // Messages collection
    match /messages/{messageId} {
      allow read: if request.auth != null &&
        (resource.data.senderId == request.auth.uid ||
         resource.data.receiverId == request.auth.uid);
      allow create: if request.auth != null;
    }
  }
}
```

## Step 7: FlutterFire CLI Setup (Recommended)

1. Install FlutterFire CLI:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Run FlutterFire configuration:
   ```bash
   cd mobile
   flutterfire configure
   ```

This will automatically generate the `firebase_options.dart` file with all platform configurations.

## Environment Variables

### Backend (.env)
```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_DATABASE_URL=https://your-project-id.firebaseio.com
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_SERVICE_ACCOUNT=<json-string-or-path>
```

## Testing Firebase Connection

### Test Backend Connection
```bash
cd backend
npm run dev
# Should see "Firebase Admin SDK initialized successfully"
```

### Test Mobile App
```bash
cd mobile
flutter run
# App should launch without Firebase errors
```

## Common Issues

### Issue: "Default FirebaseApp is not initialized"
**Solution**: Ensure `Firebase.initializeApp()` is called in `main.dart` before `runApp()`.

### Issue: "Service account key not found"
**Solution**: Check that `serviceAccountKey.json` is in the correct location or environment variable is set.

### Issue: "Permission denied" in Firestore
**Solution**: Review and update Firestore security rules.

## Next Steps

1. Set up Google Maps API (see GOOGLE_MAPS_SETUP.md)
2. Configure push notifications
3. Set up Firebase Cloud Functions for advanced features
4. Configure Firebase Analytics (optional)

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
