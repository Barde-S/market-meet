# MarketMate Quick Start Guide

## Current Status ✅

### Backend Server
**Status**: ✅ **RUNNING** on port 3000 in demo mode

The backend server is currently running and accessible at:
- Health Check: http://localhost:3000/health
- Root API: http://localhost:3000/
- API Endpoints: http://localhost:3000/api/*

**Note**: Currently running in **demo mode** without Firebase. Database-dependent endpoints will return errors until Firebase is configured.

### Mobile App
**Status**: ⚠️ **NOT AVAILABLE** - Flutter not installed in this environment

To run the mobile app, you'll need Flutter SDK installed on your local machine.

---

## What's Working Now

### ✅ Working Endpoints
- `GET /health` - Server health check
- `GET /` - API information

### ⚠️ Needs Firebase Configuration
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/agents` - Agent discovery
- `POST /api/bookings` - Create bookings
- All other data endpoints

---

## Next Steps to Run Fully

### 1. Set Up Firebase (Required for Data Features)

Follow the detailed guide: [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md)

**Quick steps**:
1. Create a Firebase project at https://console.firebase.google.com/
2. Enable Authentication, Firestore, and Storage
3. Download service account key
4. Place in `backend/src/config/serviceAccountKey.json`
5. Restart the backend server

**After Firebase setup**, the server will show:
```
✓ Firebase Admin SDK initialized successfully
✓ MarketMate API server running on port 3000
```

### 2. Set Up Google Maps (Required for Mobile App)

Follow the detailed guide: [docs/GOOGLE_MAPS_SETUP.md](docs/GOOGLE_MAPS_SETUP.md)

**Quick steps**:
1. Enable Maps APIs in Google Cloud Console
2. Create Android and iOS API keys
3. Add keys to mobile app configuration
4. Run `flutterfire configure`

### 3. Install Flutter and Run Mobile App

**On your local machine**:

```bash
# Check Flutter installation
flutter doctor

# Install dependencies
cd mobile
flutter pub get

# Configure Firebase
flutterfire configure

# Run the app
flutter run
```

---

## Testing the API

### Health Check
```bash
curl http://localhost:3000/health
```

**Response**:
```json
{
  "status": "OK",
  "timestamp": "2025-11-09T12:17:54.298Z",
  "uptime": 37.647860821
}
```

### API Info
```bash
curl http://localhost:3000/
```

**Response**:
```json
{
  "message": "MarketMate API",
  "version": "0.1.0",
  "documentation": "/api/docs"
}
```

### Test with Authentication (After Firebase Setup)
```bash
# Register a new user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "Test User"
  }'
```

---

## Stopping the Server

The server is running in the background. To stop it:

```bash
# Find the process
ps aux | grep "node src/server.js"

# Kill the process
kill <PID>

# Or use pkill
pkill -f "node src/server.js"
```

---

## Development Workflow

### Backend Development
```bash
cd backend

# Install dependencies (already done)
npm install

# Run in development mode with auto-reload
npm run dev

# Run tests
npm test

# Lint code
npm run lint
```

### Mobile Development
```bash
cd mobile

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Build release
flutter build apk  # Android
flutter build ios  # iOS
```

---

## Project Structure

```
market-meet/
├── backend/          ✅ Configured and running
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── routes/
│   │   └── server.js
│   └── package.json
│
├── mobile/           ⚠️ Needs Flutter SDK
│   ├── lib/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── main.dart
│   └── pubspec.yaml
│
└── docs/
    ├── FIREBASE_SETUP.md
    └── GOOGLE_MAPS_SETUP.md
```

---

## Environment Configuration

### Backend (.env)
Currently configured for development mode:
```env
NODE_ENV=development
PORT=3000
FIREBASE_PROJECT_ID=marketmate-demo
# Add real credentials when setting up Firebase
```

---

## Common Issues

### "Flutter command not found"
**Solution**: Install Flutter SDK from https://flutter.dev/docs/get-started/install

### "Firebase not initialized"
**Solution**: Follow [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) to set up Firebase

### "Port 3000 already in use"
**Solution**:
```bash
# Find process using port 3000
lsof -i :3000
# Kill it
kill -9 <PID>
```

---

## Resources

- 📖 [Main README](README.md) - Project overview
- 🔥 [Firebase Setup Guide](docs/FIREBASE_SETUP.md) - Complete Firebase integration
- 🗺️ [Google Maps Setup](docs/GOOGLE_MAPS_SETUP.md) - Maps API configuration
- 🤝 [Contributing Guide](docs/CONTRIBUTING.md) - How to contribute
- 📋 [Backend API Docs](backend/README.md) - API endpoints documentation
- 📱 [Mobile App Docs](mobile/README.md) - Flutter app documentation

---

## Support

For issues or questions:
- Check the documentation in `/docs`
- Open an issue on GitHub
- Review the setup guides

---

**Last Updated**: 2025-11-09
**Server Status**: ✅ Running on port 3000
